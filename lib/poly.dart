import 'dart:ui';

import 'package:boids/display.dart';
import 'package:flame/components.dart';

class Poly {
  final List<Vector3> points;
  final Vector3 centroid;
  final Color color;
  final Paint paint;

  Poly(this.points, this.color, wireFrame)
      : centroid = points.fold(Vector3.zero(), (value, pt) => value += pt/(1.0*points.length) ),
        paint = Paint()
    ..style = wireFrame ? PaintingStyle.stroke : PaintingStyle.fill
    ..color = color;


  render(Canvas canvas, Matrix4 tx) {
    var nearPlane = tx.transformed(Vector4(centroid.x, centroid.y, centroid.z, 1)).w;
    if( nearPlane < 100) {
      return;
    }

    final pts = points
        .map((p) => tx.transformed(Vector4(p.x, p.y, p.z, 1)).normalized())
        .map((p) => Offset((p.x/p.w+1)*g_Display.dimensions.x/2, (p.y/p.w+1)*g_Display.dimensions.y/2))
        .toList(growable: false);
    Path p = Path()..addPolygon(pts, true);
    canvas.drawPath(p, paint);
  }
}

List<Poly> makeModel(List<List> polys, bool wireFrame) {
  return polys.map((poly) {
    final pts = poly[1].map<Vector3>((List<int> point) {
      return Vector3(point[0] * 1.0, point[1] * 1.0, point[2] * 1.0);
    }).toList();
    final Color color = poly[0];
    return Poly(pts, color, wireFrame);
  }).toList();
}
