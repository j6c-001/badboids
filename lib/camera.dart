import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'main.dart';
import 'models.dart';

class CameraWedge extends Component with ModelInstance {
  Vector3 pos = Vector3.zero();

  final MyGame owner;

  CameraWedge(this.owner) {
    model = Wedge();
    scale =Vector3.all(50);
  }



  @override
  void render(Canvas c) {
    prepareFrame(pos,  Vector3(1, 0, 0), owner.view) ;
  }
}