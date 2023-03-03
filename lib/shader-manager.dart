import 'dart:ui';

import 'package:boids/audio-analyser.dart';
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
    elapsedTime += dt;
    bkShader.setFloat(0, myGame.size.x);
    bkShader.setFloat(1, myGame.size.y);
    bkShader.setFloat(2, elapsedTime );

    AudioAnalyser audioAnalyser = myGame.audioAnalyser;
    bass = (.95*bass + .05*audioAnalyser.bass);
    mid = (.95*mid + .05*audioAnalyser.mid);
    high = (.95*high + .05*audioAnalyser.high);

    avoidOthersFactor =  3- 3* bass*mid;
    cohesionFactor=  3 * high;
    alignmentFactor = 3 * mid * high;

    bkShader.setFloat(3, bass);
    bkShader.setFloat(4, mid);
    bkShader.setFloat(5,  high);
  }
}