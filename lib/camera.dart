
import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:simple3d/simple3d.dart';


import 'models.dart';

class CameraWedge {
  Vector3 pos = Vector3.zero();
  Vector3 camPos = Vector3.zero();



  Vector3 velocity = Vector3.zero();
  double deltaAngleY = 0;
  double deltaAngleZ = 0;

  Vector3 heading = Vector3(0,0,1);
  double speed = 1;

  bool faster = false;
  VertexModelInstance modelInstance = VertexModelInstance();
  CameraWedge() {
    modelInstance.model = aWedge;
  }


  void update(double dt) {
    if(faster) {
      speed *= 1.05;
    } else {
      speed *= .99;
    }

    Quaternion.axisAngle(Vector3(0,1,0), deltaAngleY * .01).rotate(heading);
    Quaternion.axisAngle(Vector3(1,0,0), deltaAngleZ * .03).rotate(heading);


      pos += heading * 10 * speed * dt;

      camPos = pos + heading.normalized() * 10;
  }

  void render(Canvas c, View view) {
   // modelInstance.prepareFrame(pos.x,pos.y,pos.z, heading.x, heading.y, heading.z , view,0 ) ;
  }
}