
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'poly.dart';

final  Vector3 up = Vector3(0,-1,0);

class ViewPoly extends LinkedListEntry<ViewPoly> {
  double distToCam = -10000;
  Poly poly = Poly([],Colors.green, false);
  late Matrix4 mm = Matrix4.zero();
  late Matrix4 VxMM = Matrix4.zero();


  render(Canvas c, Matrix4 v) {
    VxMM.setFrom(v);
    VxMM.multiply(mm);
    poly.render(c, VxMM);
  }
}

class View {
  Matrix4 matrix = Matrix4.zero();
  Matrix4 view = Matrix4.zero();
  List<ViewPoly> polys = List.generate(50000, (ii) => ViewPoly() );
  Vector3 cam = Vector3.zero();
  Vector3 camTemp = Vector3.zero();

  int polyIndex = 0;
  final p = makePerspectiveMatrix(57.3 * 2 , 16/9, 1, -1);

  prepareFrame() {
    polyIndex = 0;
  }

  void addPoly(Matrix4 modelMatrix, Poly poly) {
    final vp = polys[polyIndex++];
    final s = modelMatrix.storage;
    final p = poly.centroid.storage;
    camTemp.setValues(cam.x -s[12]- p[0], cam.y - s[13]-p[1], cam.z - s[14]-p[2]);
    vp.distToCam = camTemp.length;
    vp.poly = poly;
    vp.mm.setFrom(modelMatrix);

  }

  renderFrame(Canvas c) {

    mergeSort<ViewPoly>(polys, start: 0, end: polyIndex, compare: (a, b)=> a.distToCam > b.distToCam ? -1 : 1);
    for(int i = 0; i < polyIndex; i++) {
      polys[i].render(c, matrix);
    }
  }

  update(Vector3 camPosition, Vector3 targetPosition) {
    cam.setFrom(camPosition);
    setViewMatrix(view, camPosition, targetPosition, up);
    matrix.setFrom(p);
    matrix.multiply(view);
  }

}