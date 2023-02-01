
import 'dart:math';
import 'dart:ui';

import 'package:boids/models.dart';
import 'package:flame/components.dart';

import 'main.dart';


class Boid extends Component with ModelInstance {
  Behavior? behavior;
  Vector3 velocity = Vector3.zero();
  Vector3 pos = Vector3.zero();
  bool fear = false;

  final MyGame owner;

  Boid(this.owner) {
    model = Wedge();
    scale = Vector3.all(2);
    velocity = Vector3(-50, -50, -50) + Vector3.random() * 400;
  }
  @override
  onMount() {

  }
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    behavior?.size = Vector3(size.x, size.y, size.y) / 2;
    reset();
  }

  @override
  void update(double dt) {
    behavior?.update();

    pos += velocity * dt;
  }

  void reset() {

    fear = false;
    var size = behavior?.size ?? Vector3(1000,1000,1000);
    pos.x = size.x * Random().nextDouble() - size.x / 2;
    pos.y = size.y * Random().nextDouble() - size.y / 2;
    pos.z = size.y * Random().nextDouble() - size.y / 2;


  }

  @override
  void render(Canvas c) {
    prepareFrame(pos, velocity, owner.view);
  }
}

class Behavior {
  Behavior(this._boid, List<Boid> boids) {
    _boids = boids.where((b) => b != _boid).toList();
  }

  Vector3 size = Vector3.zero();

  final Boid _boid;
  List<Boid> _boids = [];

  List<Boid> _visibleBoids = [];

  void update() {
    _visibleBoids =
        _boids.where((b) => b.pos.distanceToSquared(_boid.pos) <  150*150).toList();
    Vector3 b = bounds();
    if (b.length2 > 0) {
      _boid.velocity += b;
    }

    if (_visibleBoids.length == 0) {
      return;
    }

    Vector3 v =
        _boid.velocity + aimForCenterOfMass() + avoidOthers() + matchVelocity();

    if (v.length > 300) {
      // v = v.normalized() * 300;
    }
    _boid.velocity = v;
  }

  Vector3 bounds() {
    Vector3 v = Vector3.zero();
    const double safety = 50;
    var dist = 0;
    if (_boid.pos.x < (safety - size.x)) {
      v.x = 10;
    }

    if (_boid.pos.x > (size.x - safety)) {
      v.x = -10;
    }

    if (_boid.pos.y < (safety - size.y)) {
      v.y = 10;
    }

    if (_boid.pos.y > (size.y - safety)) {
      v.y = -10;
    }

    if (_boid.pos.z < (safety - size.z)) {
      v.z = 10;
    }

    if (_boid.pos.z > (size.y - safety)) {
      v.z = -10;
    }

    return v * .2;
  }

  Vector3 aimForCenterOfMass() {
    Vector3 pc = Vector3.zero();

    _visibleBoids.forEach((b) {
      pc += b.pos;
    });

    pc /= _visibleBoids.length * 1.0;

    bool fear = _boid.owner.spaceDown;
    return (pc - _boid.pos) * 0.01 * (fear ? -4.0 : 1.0);
  }

  Vector3 avoidOthers() {
    Vector3 c = Vector3.zero();

    _visibleBoids.forEach((b) {
      if (_boid.pos.distanceTo(b.pos) < 30) {
        c -= (b.pos - _boid.pos) * .01;
      }
    });

    return c;
  }

  Vector3 matchVelocity() {
    Vector3 pc = Vector3.zero();

    _visibleBoids.forEach((b) {
      pc += b.velocity;
    });

    pc /= _visibleBoids.length * 1.0;

    return (pc - _boid.velocity) * 0.005;
  }
}
