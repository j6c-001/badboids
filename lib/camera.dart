
import 'dart:math';

import 'package:boids/boids.dart';
import 'package:flame/extensions.dart';
import 'package:simple3d/simple3d.dart';

import 'globals.dart';
import 'my-game.dart';


class GameCamera {

  final MyGame owner;
  Vector3 target = Vector3.zero();
  Vector3 pos = Vector3(1000,1000,1000);

  double viewingDistance = 1000;
  double orbitAngle = 0;


  double deltaAngleZ = 0;
  double deltaAngleY = 0;

  GameCamera(this.owner);


  void update(double dt) {
    List<Boid> boids = owner.boids;
    Boid cameraTargetBoid = cameraBoidIndex <boids.length ? boids[cameraBoidIndex] : boids.last;
    if (boidCameraOnOff) {

      Vector3 offsetDir = (pos-cameraTargetBoid.pos);
      Quaternion q= Quaternion.axisAngle(Vector3(0,-1,0), orbitAngle);
      q.rotate(offsetDir);
      offsetDir.normalize();
      Vector3 newPos = (cameraTargetBoid.pos  + offsetDir * viewingDistance);

      orbitAngle = 0;
      Vector3 newTarget = cameraTargetBoid.pos;
      pos = (pos * .98) + (newPos * .02);
      target = (target * .95) + (newTarget * .05);
    } else {
      pos.x = viewingDistance * cos(orbitAngle);
      pos.z = viewingDistance * sin(orbitAngle);
      pos.y = 0;
      Vector3 newTarget = cameraTargetBoid.pos;
      target = (target * .95) + (newTarget * .05);
    }

  }

  void render(Canvas c, View3d view) {
  }
}