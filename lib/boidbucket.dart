
import 'dart:collection';

import 'package:flame/extensions.dart';

import 'boids.dart';
import 'globals.dart';

final bucketSizer = (1500 * 2 ~/ visibility) +1;
final maxBuckets = bucketSizer * bucketSizer * bucketSizer;
class BoidBucket {

  static int bk(double v) {
    return v ~/ visibility;
  }

  static int indexFromXYZ(Vector3 v) {
    int x = v.x < 0 ? bk(v.x).abs() : bucketSizer ~/2 + bk(v.x);
    int y = v.y < 0 ? bk(v.y).abs() : bucketSizer ~/2 + bk(v.y);
    int z = v.z < 0 ? bk(v.z).abs() : bucketSizer ~/2 + bk(v.z);

    final index = x + bucketSizer * y + bucketSizer * bucketSizer * z;

    return index < maxBuckets ? index : 0;
  }

  List<LinkedList<BoidWrapper>> xyzBuckets = List.filled(bucketSizer * bucketSizer * bucketSizer, LinkedList<BoidWrapper>() );
  void remove(Boid b) {
    int currentBucket = indexFromXYZ(b.pos);
    xyzBuckets[currentBucket].remove(b.bucketNode);
  }
}
