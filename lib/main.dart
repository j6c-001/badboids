import 'dart:math';
import 'dart:ui';

import 'package:boids/boids.dart';
import 'package:boids/display.dart';
import 'package:boids/sandbox.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'camera.dart';
import 'view.dart';

void main() {
  print('hello');
  final myGame = MyGame();
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}


class MyGame extends Component with Game, PanDetector, KeyboardEvents {
  View view = View();
  Matrix4 cview = Matrix4.zero();
  Vector3 target = Vector3(-00, -00, 0);
  Vector3 pos = Vector3(1500,1500,1000);


  MyGame();

  onGameResize(Vector2 size) {
    super.onGameResize(size);
    g_Display.dimensions.setFrom(size);
    setMounted();
  }


  KeyEventResult onKeyEvent(RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed) {

    shifted = keysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
        keysPressed.contains(LogicalKeyboardKey.shiftRight);
    spaceDown = keysPressed.contains(LogicalKeyboardKey.space);

    return KeyEventResult.handled;
  }


  void onPanUpdate(DragUpdateInfo details) {
    if (shifted) {
      viewDistance += details.delta.global.y;
    } else {
      theta += details.delta.global.x * .01;
    }
  }

  final N = 1000;

  @override
  Future<void>? onLoad() {
    final List<Boid> boids = [];
    for (int i = 0; i < N; i++) {
      boids.add(Boid(this));
    }

    boids.forEach((b) {
      b.behavior = Behavior(b, boids);
       add(b);
    });

    return super.onLoad();
  }

  @override
  onMount() {

  }


  double theta = 0;
  double viewDistance = 2000;
  bool shifted = false;
  bool spaceDown = false;

  @override
  void update(double dt) {
    lifecycle.processQueues();
    children.updateComponentList();

    view.update(pos, target);

    pos.x =  viewDistance * cos(theta);
    pos.z =  viewDistance * sin(theta);
    pos.y = 000;
    children.forEach((c) => c.update(dt));
  }

  @override
  void render(Canvas canvas) {
    view.prepareFrame();
    children.forEach((c) => c.render(canvas));

    view.renderFrame(canvas);
  }
}




