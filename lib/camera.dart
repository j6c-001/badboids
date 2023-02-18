import 'package:boids/view.dart';
import 'package:flame/extensions.dart';

import 'models.dart';

class CameraWedge  with ModelInstance {
  Vector3 pos = Vector3.zero();
  Vector3 camPos = Vector3.zero();



  Vector3 velocity = Vector3.zero();
  double deltaAngleY = 0;
  double deltaAngleZ = 0;

  Vector3 facing = Vector3(0,0,1);
  double speed = 1;

  bool faster = false;

  CameraWedge() {
    model = Wedge();
    scale = Vector3.all(1);
  }


  void update(double dt) {
    if(faster) {
      speed *= 1.05;
    } else {
      speed *= .99;
    }

    Quaternion.axisAngle(Vector3(0,1,0), deltaAngleY * .01).rotate(facing);
    Quaternion.axisAngle(Vector3(1,0,0), deltaAngleZ * .03).rotate(facing);


      pos += facing * 10 * speed * dt;

      camPos = pos + facing.normalized() * 10;
  }

  void render(Canvas c, View view) {
    prepareFrame(pos, facing , view,0 ) ;
  }
}