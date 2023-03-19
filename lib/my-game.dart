

import 'dart:ui';

import 'package:boids/audio-manager.dart';
import 'package:boids/shader-manager.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:simple3d/simple3d.dart';

import 'boidbucket.dart';
import 'boids.dart';
import 'camera.dart';
import 'globals.dart';

class MyGame extends Component with Game, PanDetector, KeyboardEvents {
  View3d view = View3d(60000,100, 100);

  late final GameCamera camera;

  bool play = true;

  bool needsReset = false;
  bool needsMixReset = false;
  final List<Boid> boids = [];

  final boidBuckets = BoidBucket();

  AudioManager audioManager = AudioManager();
  ShaderManager shaderManager = ShaderManager();

  Paint bkPaint = Paint();

  double et = 0;
  int fc = 0;

  Vertices? screenVerts;

  MyGame(){
    camera = GameCamera(this);
  }

  onGameResize( size) {
    super.onGameResize(size);
    view.dimensions.x = size.x;
    view.dimensions.y = size.y;

    screenVerts = Vertices(VertexMode.triangles, [Offset(0,0),Offset(0,size.y), Offset(size.x, size.y),Offset(0,0), Offset(size.x, 0), Offset(size.x, size.y) ]);


    setMounted();
  }


  void onPanUpdate(DragUpdateInfo details) {
    camera.orbitAngle += details.delta.global.x * .01;
    double dy = details.delta.global.y;
    double dx = details.delta.global.x;

    camera.deltaAngleZ += dy;
    camera.deltaAngleY += dx;
  }

  @override
  Future<void>?  onLoad() async{
    for (int i = 0; i < numberOfBoids; i++) {
      Boid(this);

    }

    await audioManager.init();
    await shaderManager.init();

    return super.onLoad();
  }

  @override
  void update(double dt) {

    lifecycle.processQueues();
    children.updateComponentList();

    audioManager.update();
    shaderManager.update(dt);

    spawnBoidsIfNecessary(dt);

    if (needsReset) {
      reset();
    }

    camera.update(dt);
    view.update(camera.pos.x, camera.pos.y, camera.pos.z, camera.target.x, camera.target.y, camera.target.z);
    if (play) {
      for(Component c in children) {
        c.update(dt);
      }
    }

    needsMixReset = false;

    settingsState?.setState(() {

    });



    if (et > .1) {
      fps = fc / et;
      et = 0;
      fc = 0;
    } else {
      ++fc;
      et += dt;
    }
  }

  void spawnBoidsIfNecessary(double dt) {

    if(autoSpawnTimeRemainingInSeconds > 0) {
      if (fps > targetFPS - 1.0 && numberOfBoids < maxBoids - 1) {
        numberOfBoids += 1;
      }

      if (fps < targetFPS - 1.0 && numberOfBoids > 1) {
        numberOfBoids -= 1;
      }
      autoSpawnTimeRemainingInSeconds -= dt;
    }

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
  }


  @override
  void render(Canvas canvas) {
    view.prepareFrame();
    for(Component c in children) {
      c.render(canvas);
    };

    bkPaint.shader = shaderManager.bkShader;
    view.paint.shader= shaderManager.boidsShader;
    view.blendMode = BlendMode.multiply;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      bkPaint,
    );

    canvas.drawVertices(screenVerts!, BlendMode.src, bkPaint);
    view.renderFrame(canvas);
  }

  void reset() {
    children.whereType<Boid>().forEach((c) => c.reset());
    needsReset = false;
  }

}

