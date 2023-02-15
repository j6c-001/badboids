import 'package:boids/view.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'main.dart';
import 'models.dart';

class Track with ModelInstance {
  Vector3 pos = Vector3(0,-100,0);
  double angle = 0;

  Track() {
    model = TrackModel1();
    scale = Vector3.all(1);
  }

  void render(Canvas c, View view) {
    angle += 0.05;
    prepareFrame(pos, Vector3(0,0,1) , view, angle) ;
  }
}