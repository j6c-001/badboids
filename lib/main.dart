
import 'dart:collection';
import 'dart:math';

import 'package:boids/boids.dart';
import 'package:boids/display.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'globals.dart';
import 'ui/widgets.dart';
import 'camera.dart';
import 'view.dart';


void main() {
   myGame = MyGame();
  runApp(
    FlutterApp()
  );
}


class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bad Boids',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
            toolbarHeight: 00,
            actions: [],
        ),

        body: body(context)
      )
    );

  }

  Widget body(ctx) {
  return Row(
    children: [
    SettingsWidget(),
    Expanded(child: GameWidget<MyGame>(
      game: myGame,
    ))],
    );
  }
}


class MyGame extends Component with Game, PanDetector, KeyboardEvents {
  View view = View();
  Matrix4 cview = Matrix4.zero();
  Vector3 target = Vector3(-00, -00, 0);
  Vector3 pos = Vector3(1500, 1500, 1000);

  CameraWedge camera = CameraWedge();

  bool play = true;

  bool needsReset = false;
  bool needsMixReset = false;

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
    theta += details.delta.global.x * .01;
    double dy = details.delta.global.y;
    double dx = details.delta.global.x;

    camera.deltaAngleZ += dy;
    camera.deltaAngleY += dx;
  }

  final List<Boid> boids = [];

  final boidBuckets = BoidBucket();

  @override
  Future<void>? onLoad() {
    for (int i = 0; i < numberOfBoids; i++) {
      Boid(this);

    }
    return super.onLoad();
  }



  double theta = 0;
  double viewDistance = 100;
  bool shifted = false;
  bool spaceDown = false;

  int updates = 0;
  int simUpdates = 0;

  @override
  void update(double dt) {

    lifecycle.processQueues();
    children.updateComponentList();

    int ba = numberOfBoids - boids.length;

    while (ba > 0) {
      Boid(this);
      ba--;
    }

    while (ba < 0) {
      Boid b = boids[boids.length+ba];
      remove(b);
      ba++;
    }

    if (needsReset) {
      reset();
    }


    view.update(pos, target);
    camera.update(dt);

    Boid cameraTargetBoid = cameraBoidIndex < boids.length ? boids[cameraBoidIndex] : boids.last;
    if (boidCameraOnOff) {

      Vector3 newPos = (cameraTargetBoid.pos + cameraTargetBoid.velocity.normalized() * viewDistance);
      Vector3 newTarget = cameraTargetBoid.pos -
          cameraTargetBoid.velocity.normalized() * cameraDirection * .1;
      pos = (pos * .95) + (newPos * .05);
      target = (target * .95) + (newTarget * .05);
    } else {
      pos.x = viewDistance * cos(theta);
      pos.z = viewDistance * sin(theta);
      pos.y = 0;
      Vector3 newTarget = cameraTargetBoid.pos;
      target = target = (target * .95) + (newTarget * .05);
    }
    camera.deltaAngleY = 0;
    camera.deltaAngleZ = 0;

    if (play) {
      for(Component c in children) {
          c.update(dt);
      }
    }
   needsMixReset = false;

   settingsState?.setState(() {});

    if (et > 2.0) {
      fps = fc / et;
      et = 0;
      fc = 0;
    } else {
      ++fc;
      et += dt;
    }
  }

  double et = 0;
  int fc = 0;

  @override
  void render(Canvas canvas) {
   view.prepareFrame();
    for(Component c in children) {
        c.render(canvas);
    };
    view.renderFrame(canvas);
  }

  void reset() {
    children.whereType<Boid>().forEach((c) => c.reset());
    needsReset = false;
  }

}

final bucketSizer = (1500 * 2 ~/ visibility) +1;
final maxBuckets = bucketSizer * bucketSizer * bucketSizer;
class BoidBucket {

  static int bk(double v) {
    return v ~/ visibility;
  }

  static int indexFromXYZ(Vector3 v) {
    int x = v.x < 0 ? bk(v.x).abs() : bucketSizer ~/2 + bk(v.x);
    int y = v.y < 0 ? bk(v.y).abs() : bucketSizer ~/2 + bk(v.y);
    int z = v.z < 0 ? bk(v.z).abs() : bucketSizer ~/2 + bk(v.z);

    final index = x + bucketSizer * y + bucketSizer * bucketSizer * z;

    return index < maxBuckets ? index : 0;
  }

 List<LinkedList<BoidWrapper>> xyzBuckets = List.filled(bucketSizer * bucketSizer * bucketSizer, LinkedList<BoidWrapper>() );
  void remove(Boid b) {
    int currentBucket = indexFromXYZ(b.pos);
    xyzBuckets[currentBucket].remove(b.bucketNode);
  }
}









