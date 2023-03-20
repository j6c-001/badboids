import 'dart:ui';

import 'package:boids/audio-manager.dart';
import 'package:boids/globals.dart';

class ShaderManager {


  late FragmentShader boidsShader;
  late FragmentShader bkShader;

  double bass= 0;
  double mid = 0;
  double high = 0;

  Future<void> init() async {
    var shaderProgram = await FragmentProgram.fromAsset('assets/shaders/boid.frag');
    var bkgShaderProgram = await FragmentProgram.fromAsset('assets/shaders/bkgd.frag');


    boidsShader = shaderProgram.fragmentShader();
    bkShader = bkgShaderProgram.fragmentShader();
  }

  double elapsedTime = 0;
  update(double dt) {

    if(!myGame.play) {
      return;
    }

    elapsedTime += dt;




    AudioManager audioAnalyser = myGame.audioManager;
    bass = (.95*bass + .05*audioAnalyser.bass);
    mid = (.95*mid + .05*audioAnalyser.mid);
    high = (.95*high + .05*audioAnalyser.high);

    if(musicControlled) {
      avoidOthersFactor = 3 - 3 * (bass* bassMixAvoidance + mid* midMixAvoidance + high* highMixAvoidance);
      cohesionFactor = 3 * (bass*bassMixCohesion + mid*midMixCohesion + high* highMixCohesion);
      alignmentFactor = 3 * (bass*bassMixAlignment + mid*midMixAlignment + high*highMixAlignment);
    }


    updateShader(boidsShader);
    updateShader(bkShader);

  }

  void updateShader(FragmentShader shader) {
    shader.setFloat(0, myGame.size.x);
    shader.setFloat(1, myGame.size.y);
    shader.setFloat(2, elapsedTime );

    shader.setFloat(3, myGame.camera.pos.x);
    shader.setFloat(4, myGame.camera.pos.y);
    shader.setFloat(5, myGame.camera.pos.z);

    shader.setFloat(6, myGame.camera.target.x);
    shader.setFloat(7, myGame.camera.target.y);
    shader.setFloat(8, myGame.camera.target.z);

    shader.setFloat(9, bass);
    shader.setFloat(10, mid);
    shader.setFloat(11,  high);

  }
}