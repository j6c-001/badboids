
import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'poly.dart';

class ViewPoly {
  double distToCam = -10000;
  Poly poly = Poly([],Colors.green, false);
  late Matrix4 mm = Matrix4.zero();

  render(Canvas c, Matrix4 v) {
    poly.render(c, v *mm);
  }
}

class View {
  Matrix4 matrix = Matrix4.zero();
  List<ViewPoly> polys = List.generate(15000, (ii) => ViewPoly() );

  Vector3 cam = Vector3.zero();

  int polyIndex = 0;

  prepareFrame() {
    polyIndex = 0;
  }

  void addPoly(Matrix4 modelMatrix, Poly poly) {
    final vp = polys[polyIndex++];
    vp.distToCam = (cam - (modelMatrix.getTranslation() + poly.centroid)).length;
    vp.poly = poly;
    vp.mm = modelMatrix;

  }

  renderFrame(Canvas c) {

    mergeSort<ViewPoly>(polys, start: 0, end: polyIndex, compare: (a, b)=> a.distToCam > b.distToCam ? -1 : 1);
    for(int i = 0; i < polyIndex; i++) {
      polys[i].render(c, matrix);
    }
    
    //c.drawRawPoints(pointMode, points, paint)
  }

  update(Vector3 camPosition, Vector3 targetPosition) {
    cam = camPosition;
    final v = makeViewMatrix(camPosition, targetPosition, Vector3(0, -1, 0));
    final p = makePerspectiveMatrix(57.3 * 2 , 16/9, 1, -1);
     matrix = p * v;

  }

}