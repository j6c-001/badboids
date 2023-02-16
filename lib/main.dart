import 'dart:collection';
import 'dart:math';

import 'package:boids/boids.dart';
import 'package:boids/display.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'Track.dart';
import 'camera.dart';
import 'view.dart';

// shock horror of gloabl variables
var myGame;
var settingsState;
var settingsPanelState;

void main() {
   myGame = MyGame();
  runApp(
    FlutterApp()
  );
}

double fps = 0;
int numberOfBoids = 1000;
int cntPolys = 0;
int countBoids = 0;
int countWedges = 0;
int countBirdies = 0;
int visibility = 150;
double maxSpeed = 100;
double maxForce = .005;


double cohesionFactor =  0.50;
double alignmentFactor = 0.85;
double avoidOthersFactor = 1.70;

int cameraBoidIndex = 0;
double cameraDirection = -1.0;
bool boidCameraOnOff = false;
bool flyCamOn = false;

final textStyleWhiteBold = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
final textStyleWhite = TextStyle(color: Colors.white);


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



class SettingsWidget extends StatefulWidget  {
  SettingsWidget({Key? key}) : super(key: key);
  @override
  SettingsWidgetState createState()  {
    settingsPanelState = SettingsWidgetState();
    return settingsPanelState;
  }

}

class SettingsWidgetState extends State<SettingsWidget> {

  OverlayEntry? settingsButton;
  OverlayEntry? settingsPanel;


  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>showSettings());
  }


  bool settingsOpen = false;
  void showSettings() {
    final o = Overlay.of(context);

    settingsPanel =  OverlayEntry(builder: (ctx)=>Positioned(left: 20, top: 20, child: BoidSettings() ),maintainState: true);
    settingsButton = OverlayEntry(builder: (ctx)=>Positioned(left: 20, top: 20, child:  IconButton(
        color: Colors.deepOrange,
        icon: Icon(Icons.settings), onPressed: (){
       settingsButton?.remove();
       o.insert(settingsPanel!);
      }), ), maintainState: true);
    o.insert(settingsButton!);
  }


  void swap() {
    if (settingsPanel?.mounted == true) {
      settingsState = null;
      settingsPanel?.remove();
      final o = Overlay.of(context);
      o.insert(settingsButton!);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Text('');
  }
}


class BoidSettings extends StatefulWidget {
  BoidSettings({Key? key}) : super(key: key);
  @override
  BoidSettingsState createState()  {
    settingsState = BoidSettingsState();
    return settingsState;
  }

}


class BoidSettingsState extends State<BoidSettings> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(4)
          ),
          child: Padding(
              padding: EdgeInsets.all(3),
              child:Column(
              
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                 Row(
                     children: [
                       IconButton(
                           color: Colors.deepOrange,
                           onPressed: () {
                             settingsPanelState.swap();
                           },
                           icon: Icon(Icons.close_sharp)
                       ),
                       Text('  Settings', style: textStyleWhiteBold)
                     ]
                 ),
                Text( 'Boids: $countBoids ${fps.round()}fps Polys: $cntPolys', style: textStyleWhite),
                Text('Birdies: $countBirdies Wedges: $countWedges', style: textStyleWhite),

                Row(children: [Text('Alignment', style: textStyleWhite),Slider(
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

                )]),
                Row(children: [Text('Avoidance', style: textStyleWhite),Slider(
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

                )]),

                Row(children: [Text('Cohesion', style: textStyleWhite),Slider(
                  value: cohesionFactor,
                  max: 3,
                  min: 0,
                  divisions: 100,
                  label: 'Cohesion $cohesionFactor',
                  onChanged: (double v) {
                    setState(() {
                      cohesionFactor = v;
                    });
                  },

                )]),

                Row(children: [Text('Boids', style: textStyleWhite),Slider(
                  value: numberOfBoids.toDouble(),
                  label: 'Boids: $numberOfBoids',
                  max:5000,
                  min: 1,
                  onChanged: (double v) {
                    setState(() {
                      numberOfBoids = v.toInt();
                    });
                  },
                )]),
                Row(children: [Text('Zoom', style: textStyleWhite),Slider(
                  value: myGame.viewDistance,
                  max:5000,
                  min: 2,
                  onChanged: (double v) {
                    setState(() {
                      myGame.viewDistance = v;
                    });
                  },
                )]),

                Row(
                  children: [
                    IconButton(
                        tooltip: 'Switch between follow or fixed camera',
                        icon: Icon(Icons.camera_outlined),
                        color: Colors.deepOrange,
                        onPressed: () {
                        boidCameraOnOff = !boidCameraOnOff;
                    }),
                    IconButton(
                        tooltip: 'Point camera at a random boid',
                        icon: Icon(Icons.cameraswitch_sharp),
                        color: Colors.deepOrange,
                        onPressed: () {
                          cameraBoidIndex = Random().nextInt(numberOfBoids);
                    }),
                    IconButton(
                        tooltip: 'Switch to ' + (cameraDirection < 0 ? 'back facing camera' : 'front facing camera'),
                        icon: Icon(cameraDirection < 0 ? Icons.arrow_forward_sharp : Icons.arrow_back_sharp),
                        color: Colors.deepOrange,
                        onPressed: () {
                          cameraDirection *= -1.0;
                    }),

                    IconButton(
                        tooltip: 'Play Simulation',
                        icon: Icon(Icons.play_arrow),
                        color: Colors.deepOrange,
                        disabledColor: Colors.grey,
                        onPressed: myGame.play ? null : () {
                          myGame.play = true;
                        }
                    ),
                    IconButton(
                        tooltip: 'Pause Simulation',
                        icon: Icon(Icons.pause),
                        disabledColor: Colors.grey,
                        color: Colors.deepOrange,
                        onPressed: myGame.play ? () {
                          myGame.play = false;
                        } : null
                    ),
                    IconButton(
                        tooltip: 'Reset Simulation',
                        icon: Icon(Icons.lock_reset),
                        color: Colors.deepOrange,
                        onPressed: () {
                          myGame.needsReset = true;
                        }
                    ),

                  ],
                ),

              ]),
        )));
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
    theta += details.delta.global.x * .01;
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
      Component b = children.last;
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
      pos.y = 000;
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









