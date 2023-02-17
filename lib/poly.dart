import 'dart:ui';

import 'package:boids/display.dart';
import 'package:boids/main.dart';
import 'package:flame/components.dart';

class Poly {
  final List<Vector3> points;
  final List<Offset> screenCoords;
  final Vector4 centroid;
  final Color color;
  final Paint paint;
  final Path path;
  Vector4 txPt;

  Poly(this.points, this.color, wireFrame)
      : centroid = points.fold(Vector4.zero(), (Vector4 value, Vector3 pt) => value += Vector4(pt.x, pt.y,pt.z,1)/(1.0*points.length) ),
        txPt = Vector4(0,0,0,1),
        path = Path(),
        screenCoords = List.filled(points.length, Offset.zero, growable: false),
        paint = Paint()
    ..style = wireFrame ? PaintingStyle.stroke : PaintingStyle.fill
    ..color = color;


  render(Canvas canvas, Matrix4 tx) {
    var nearPlane = tx.transformed(centroid).w;
    if( nearPlane < 10) {
      return;
    }

    for(int i = 0; i < points.length; i++ ) {
       Vector3 pt = points[i];
       txPt.setValues(pt.x, pt.y, pt.z, 1);
       tx.transform(txPt);
       screenCoords[i] = Offset((txPt.x/txPt.w+1)*g_Display.dimensions.x/2,(txPt.y/txPt.w+1)*g_Display.dimensions.y/2);
    }

    path.reset();
    path.addPolygon(screenCoords, true);
    canvas.drawPath(path, paint);

    cntPolysRendered++;
  }
}

List<Poly> makeModel(List<List> polys, bool wireFrame, {bool swap = false}) {
  return polys.map((poly) {
    final pts = poly[1].map<Vector3>((List<num> point) {
      return swap ? Vector3(point[0] * 1.0, point[2] * 1.0, point[1] * 1.0) :
      Vector3(point[0] * 1.0, point[1] * 1.0, point[2] * 1.0);
    }).toList();
    final Color color = poly[0];
    return Poly(pts, color, wireFrame);
  }).toList();
}
