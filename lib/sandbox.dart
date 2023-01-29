

import 'package:boids/models.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'main.dart';

class Sandbox extends Component with ModelInstance {
  Vector3 pos = Vector3.zero();

  final MyGame owner;

  Sandbox(this.owner) {
    model = Box();
    scale = Vector3.all(50);
  }

  @override
  void render(Canvas c) {
    prepareFrame(pos, Vector3(0, 0, 1), owner.view);
  }
}
