
import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:boids/models.dart';
import 'package:flame/components.dart';

import 'main.dart';
enum BoidType {
  BOID_BIRDIE,
  BOID_WEDGE,
  BOID_GEM
}

class Boid extends Component with ModelInstance {
  Vector3 velocity = Vector3.zero();
  Vector3 pos = Vector3.zero();

  late BoidWrapper bucketNode;
  Vector3 steeringForce = Vector3.zero();
  double angle = 0;
  bool fear = false;
  final MyGame owner;
  BoidType type = BoidType.BOID_BIRDIE;

  Boid(this.owner)
  {
    bucketNode = BoidWrapper(this);
    type = selectType();
    owner.boids.add(this);
    owner.add(this);
    model =  buildModel();
    scale = Vector3.all(type == BoidType.BOID_BIRDIE ? 2 : 1);
    countBoids++;
    doTypeAccounting(1);
    reset();

  }

  @override
  void onRemove() {
    super.onRemove();
    owner.boids.remove(this);
    owner.boidBuckets.remove(this);

    countBoids--;
    doTypeAccounting(-1);
  }

  BoidType selectType() {
    double r = Random().nextDouble();
    if (r < mixBirdies) {
      return BoidType.BOID_BIRDIE;
    } else if ( r < mixWedges) {
      return BoidType.BOID_WEDGE;
    }
    return BoidType.BOID_GEM;
  }

  Model buildModel() {
    if (type == BoidType.BOID_WEDGE) {
      return aWedge;
    } else if(type == BoidType.BOID_BIRDIE) {
      return aBird;
    }
    return aGem;
  }

  @override
  void update(double dt) {

    if(owner.needsMixReset) {
      updateMix();
    }

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
  }



  int bucketIndex() => BoidBucket.indexFromXYZ(pos);

  void updateBuckets(Vector3 curPos, Vector3 newPos, {bool update = false})
  {
    int currentBucket =BoidBucket.indexFromXYZ(curPos);
    int newBucket = BoidBucket.indexFromXYZ(newPos);

    if (currentBucket != newBucket || update) {
      owner.boidBuckets.xyzBuckets[currentBucket].remove(this.bucketNode);
      owner.boidBuckets.xyzBuckets[newBucket].add(this.bucketNode);
    }

  }

  void doTypeAccounting(int i) {
    if(type == BoidType.BOID_BIRDIE) countBirdies+=i;
    if(type == BoidType.BOID_WEDGE)  countWedges+=i;
    if(type == BoidType.BOID_GEM)  countGems+=i;

  }




  void updateMix() {
    final newType = selectType();
    if (newType != type ) {
      doTypeAccounting(-1);
      type =  newType;
      doTypeAccounting(1);
      model = buildModel();
    }
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
    return  owner.boidBuckets.xyzBuckets[bucketIndex()];
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
          matchVelocity.sub(b.boid.velocity);
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
