import 'dart:collection';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:async/async.dart';


import 'package:boids/boids.dart';
import 'package:boids/display.dart';
import 'package:boids/sandbox.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'Track.dart';
import 'camera.dart';
import 'view.dart';
var myGame;
void main() {
  print('hello');
   myGame = MyGame();

  runApp(
    FlutterApp()
  );
}


int numberOfBoids = 1000;
int visibility = 150;
double maxSpeed = 100;
double maxForce = .05;
double cohesionFactor = .99;
double alignmentFactor = 1;
double avoidOthersFactor = 1;
int cameraBoidIndex = 0;
double cameraDirection = -1.0;
bool boidCameraOnOff = false;
bool flyCamOn = false;

class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bad Boids',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),

      home: Scaffold(
        appBar: AppBar(
            toolbarHeight: 100,
            actions: [BoidSettings()],
        ),
        body: Row(
          children: [
            Expanded(child: GameWidget<MyGame>(
            game: myGame,
          ))],
        )
      )
    );
  }
}

class BoidSettings extends StatefulWidget {
  BoidSettings({Key? key}) : super(key: key);
  @override
  BoidSettingsState createState() => BoidSettingsState();
}

class BoidSettingsState extends State<BoidSettings> {
  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Slider(
            value: alignmentFactor,
            max: 3,
            min: 0,
            divisions: 100,
            label: 'Alignment $alignmentFactor',
            onChanged: (double v) {
              setState(() {
                alignmentFactor = v;
              });
            },

          ),
          Slider(
            value: avoidOthersFactor,
            max: 3,
            min: 0,
            divisions: 100,
            label: 'Avoidance $avoidOthersFactor',
            onChanged: (double v) {
              setState(() {
                avoidOthersFactor = v;
              });
            },

          ),

          Slider(
            value: cohesionFactor,
            label: 'Cohesion $cohesionFactor',
            max: 3,
            min: 0,
            divisions: 100,
            onChanged: (double v) {
              setState(() {
                cohesionFactor = v;
              });
            },

          ),

          Slider(
            value: visibility.toDouble(),
            label: 'Visibility: $visibility',
            max: 500,
            min: 1,
            onChanged: (double v) {
              setState(() {
                visibility = v.toInt();
              });
            },

          ),

         Slider(
           value: numberOfBoids.toDouble(),
           label: 'Boids: $numberOfBoids',
           max:5000,
           min: 1,
           onChanged: (double v) {
             setState(() {
               numberOfBoids = v.toInt();
             });
           },

         ),
          TextButton(
            child: Text('Reset'),
            onPressed: () {
              myGame.needsReset = true;
            },
          ),
          IconButton(icon: Icon(Icons.camera_outlined), onPressed: () {
            boidCameraOnOff = !boidCameraOnOff;
          }),
          IconButton(icon: Icon(Icons.cameraswitch_sharp), onPressed: () {
            cameraBoidIndex = Random().nextInt(numberOfBoids);
          }),
          IconButton(icon: Icon(Icons.compare_arrows_sharp), onPressed: () {
            cameraDirection *= -1.0;
          }),

          IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                myGame.play = true;
              }
          ),
          IconButton(
              icon: Icon(Icons.pause),
              onPressed: () {
                myGame.play = false;
              }
          )
        ]);
  }
}




class MyGame extends Component with Game, PanDetector, KeyboardEvents {
  View view = View();
  Matrix4 cview = Matrix4.zero();
  Vector3 target = Vector3(-00, -00, 0);
  Vector3 pos = Vector3(1500, 1500, 1000);

  CameraWedge camera = CameraWedge();
  Track track = Track();

  bool play = true;

  bool needsReset = false;

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
    double dy = details.delta.global.y;
    double dx = details.delta.global.x;

    camera.deltaAngleZ += dy;
    camera.deltaAngleY += dx;
  }

  final List<Boid> boids = [];

  final simData = SimData();

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

  ReceivePort receivePort = ReceivePort();
  SendPort? sendPort;

  @override
  void update(double dt) {

    lifecycle.processQueues();
    children.updateComponentList();

    int ba = numberOfBoids - boids.length;

    while (ba > 0) {
      Boid b = Boid(this);
      ba--;
    }

    while (ba < 0) {
      Component b = children.last;
      remove(b);
      boids.remove(b);
      simData.remove();
      ba++;
    }

    if (needsReset) {
      reset();
    }

    view.update(pos, target);
    camera.update(dt);

    if (boidCameraOnOff) {
      Boid bc = boids[cameraBoidIndex];
      Vector3 newPos = (bc.pos /*+ bc.velocity.normalized() * .1*/);
      Vector3 newTarget = bc.pos -
          bc.velocity.normalized() * cameraDirection * .1;
      pos = (pos * .95) + (newPos * .05);
      target = (target * .95) + (newTarget * .05);
    } else if (flyCamOn) {
      pos = camera.camPos;
      target = camera.facing;
    } else {
      pos.x = viewDistance * cos(theta);
      pos.z = viewDistance * sin(theta);
      pos.y = 000;
      target =  boids[cameraBoidIndex].pos;
    }
    camera.deltaAngleY = 0;
    camera.deltaAngleZ = 0;

    if (play) {
      children.forEach((c) => c.update(dt));
    }

    if (et > 2.0) {
      fps = fc / et;
      et = 0;
      fc = 0;
      print(fps);
    } else {
      ++fc;
      et += dt;
    }
  }

  double fps = 0;
  double et = 0;
  int fc = 0;

  @override
  void render(Canvas canvas) {
   view.prepareFrame();
    //track.render(canvas, view);
    children.forEach((c) => c.render(canvas));
    view.renderFrame(canvas);
  }

  void reset() {
    children.whereType<Boid>().forEach((c) => c.reset());
    needsReset = false;
  }

}
class SimData {
 List<LinkedList<BoidWrapper>> xyzBuckets = List.filled(100 * 100 * 100, LinkedList<BoidWrapper>() );


  void add() {

  }

  void remove() {

  }
}









