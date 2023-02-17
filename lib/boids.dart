
import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:boids/models.dart';
import 'package:flame/components.dart';

import 'main.dart';
enum BoidType {
  BOID_BIRDIE,
  BOID_WEDGE,BOID_GEM
}

class Boid extends Component with ModelInstance {
  Vector3 velocity = Vector3.zero();
  Vector3 pos = Vector3.zero();

  int bk(double v) {
    return v ~/ visibility;
  }
  int bi(Vector3 v) {
    int x = v.x < 0 ? bk(v.x).abs() : 50 + bk(v.x);
    int y = v.y < 0 ? bk(v.y).abs() : 50 + bk(v.y);
    int z = v.z < 0 ? bk(v.z).abs() : 50 + bk(v.z);

    return x + 100 * y + 100 * 100 * z;
  }

  int bucketIndex() => bi(pos);

  void updateBuckets(Vector3 curPos, Vector3 newPos, {bool update = false})
  {
     int currentBucket = bi(curPos);
      int newBucket = bi(newPos);

      if (currentBucket != newBucket || update) {
        owner.simData.xyzBuckets[currentBucket].remove(this.bucketNode);
        owner.simData.xyzBuckets[newBucket].add(this.bucketNode);
      }

    }

    @override
  void onRemove() {
    super.onRemove();
    owner.boids.remove(this);
    int currentBucket = bi(pos);
    owner.simData.xyzBuckets[currentBucket].remove(this.bucketNode);
    countBoids--;
    if(type == BoidType.BOID_BIRDIE) countBirdies--;
    if(type == BoidType.BOID_WEDGE)  countWedges--;
  }

    late BoidWrapper bucketNode;

    Vector3 steeringForce = Vector3.zero();


    double angle = 0;
    bool fear = false;

    final MyGame owner;

    BoidType type = BoidType.BOID_BIRDIE;
    Boid(this.owner)
    {
      bucketNode = BoidWrapper(this);
      type = Random().nextBool() ? BoidType.BOID_BIRDIE : BoidType.BOID_WEDGE;
      owner.boids.add(this);
      owner.simData.add();
      owner.add(this);
      model =  type == BoidType.BOID_BIRDIE ? Bird() : Wedge();
      scale = Vector3.all(type == BoidType.BOID_BIRDIE ? 2 : 1);
      countBoids++;
      if(type == BoidType.BOID_BIRDIE) countBirdies++;
      if(type == BoidType.BOID_WEDGE)  countWedges++;

      reset();

    }

    @override
    void update(double dt) {
      updateSteering();
      velocity.add(steeringForce);
      velocity.add(bounds());

      if (velocity.length2 > maxSpeed * maxSpeed ) {
        velocity.normalize();
        velocity.scale(maxSpeed);
      }

      Vector3 p = pos;
      pos += velocity * dt;
      updateBuckets(p, pos);

     // angle += .1;

    }

    void reset() {

      fear = false;
      Vector3 p = Vector3.zero();
      Vector3 s = owner.size.xyy.scaled(.25);
      p.x = s.x * Random().nextDouble() -s.x / 2;
      p.y = s.y * Random().nextDouble() - s.y / 2;
      p.z = s.y * Random().nextDouble() - s.y / 2;

      pos = p;

      velocity = Vector3(Random().nextBool() ? -10 : 10, Random().nextBool() ? -10 : 10, Random().nextBool() ? -10 : 10) + Vector3.random() * 5;
      updateBuckets(Vector3.zero(), pos, update: true);


    }

    @override
    void render(Canvas c) {
      prepareFrame(pos, velocity, owner.view, angle);
    }

    Vector3 bounds() {
      Vector3 p = pos;
      Vector3 s = owner.size.xyy.scaled(.25);

      if (p.x > s.x || p.y > s.y || p.z > s.z ||
          p.x < -s.x || p.y < -s.y || p.z < -s.z) {
        return -p.normalized()*velocity.length;
      }

      return Vector3.zero();
    }



  LinkedList<BoidWrapper> get visibleBoids  {
    return  owner.simData.xyzBuckets[bucketIndex()];
  }

  Vector3 temp = Vector3.zero();


  void updateSteering() {
    Vector3 aimForCenterOfMass = Vector3.zero();
    Vector3 matchVelocity = Vector3.zero();
    Vector3 avoidOthers = Vector3.zero();


    int cnt = 0;
    int acnt = 0;

    final vb = visibleBoids;
    BoidWrapper? b = vb.first;

    int i = 0;
    double d = 0;
    int otherCnt = 0;

    while (i <vb.length && b != null && i < 100) {
      d = (b.boid.pos-pos).length2;
      if ( d > 0 && d < visibility*visibility) {
        cnt++;
        if(type == b.boid.type) {
          aimForCenterOfMass.add(b.boid.pos);
          matchVelocity.add(b.boid.velocity);
        } else if (type == BoidType.BOID_BIRDIE) {
          otherCnt++;
          avoidOthers.add((b.boid.pos - pos) * otherCnt.toDouble());
        }

        if ( d < 30 * 30) {
          acnt++;
          avoidOthers.add((b.boid.pos - pos).normalized()/d);
        }
      }

      b = b.next;
      i++;

    }
    steeringForce.setZero();
    if (cnt > 0 ) {
      Vector3 toCOM = (aimForCenterOfMass / cnt.toDouble() - pos).normalized() * maxSpeed;
      steeringForce.add(limit(toCOM - velocity) *  cohesionFactor);

      Vector3 match = (matchVelocity).normalized() * maxSpeed;
      steeringForce.add( limit(match - velocity) * alignmentFactor);

    }

    if (acnt > 0 ) {
      Vector3 toAvoid= avoidOthers.normalized() * maxSpeed;
      steeringForce.sub(limit(toAvoid - velocity) *  avoidOthersFactor);
    }
  }



  Vector3 limit(Vector3 v) {
    if(v.length2 >  maxForce * maxForce) {
      v.normalized() ;
      v.scale(maxForce);
    }
    return v;
  }


}



class BoidWrapper  with LinkedListEntry<BoidWrapper> {
  Boid boid;
  BoidWrapper(this.boid);
}
