

import 'package:boids/poly.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'view.dart';

class Model {
  Model() {
    polys = getModel();
  }

  List<Poly> polys = [];
  getModel() {}

  getWireframe() {
    return true;
  }
}


mixin ModelInstance {
  late final Model model;
  final Matrix4 mm = Matrix4.zero();

  Vector3 scale = Vector3(1, 1, 1);

  void prepareFrame(Vector3 position, Vector3 heading,  View view) {
    setModelMatrix(mm, heading.normalized() , Vector3(0, -1, 0),
        position.x, position.y, position.z);
    mm.scale(scale.x, scale.y, scale.z);
    model.polys.forEach((poly) => view.addPoly(mm, poly));
  }

}

class Wedge extends Model {
  List getModel() {
    return makeModel([
      [
        Colors.red,
        [
          [-2, 0, 0],
          [2, 0, 0],
          [0, 2, 0]
        ]
      ],
      [
        Colors.green,
        [
          [-2, 0, 0],
          [2, 0, 0],
          [1, 1, -6]
        ]
      ],
      [
        Colors.amber,
        [
          [-2, 0, 0],
          [0, 2, 0],
          [1, 1, -6]
        ]
      ],
      [
        Colors.blue,
        [
          [2, 0, 0],
          [0, 2, 0],
          [1, 1, -6]
        ]
      ]
    ], false);
  }
}


class Panel extends Model {
  getModel() {
    return makeModel([
      [
        Colors.amber,
        [
          [1, 1, 0],
          [1, -1, 0],
          [-1, -1, -0],
          [-1, 1, -0],
          [1, 1, 0]
        ]
      ]
    ],
        false);
  }

}

class Box extends Model {
  getModel() {
    return makeModel([
      [
        Colors.amber,
        [
          [1, 1, 1],
          [1, -1, 1],
          [1, -1, -1],
          [1, 1, -1],
          [1, 1, 1]
        ]
      ],
      [
        Colors.blue,
        [
          [1, 1, 1],
          [-1, 1, 1],
          [-1, 1, -1],
          [1, 1, -1],
          [1, 1, 1]
        ]
      ],
     [
        Colors.deepOrange,
        [
          [1, 1, 1],
          [1, -1, 1],
          [-1, -1, 1],
          [-1, 1, 1],
          [1, 1, 1]
        ]
      ],
      [
        Colors.deepPurple,
        [
          [1, -1, 1],
          [-1, -1, 1],
          [-1, -1, -1],
          [1, -1, -1],
          [1, -1, 1]
        ]
      ],
      [
        Colors.green,
        [
          [1, 1, -1],
          [-1, 1, -1],
          [-1, -1, -1],
          [1, -1, -1],
          [1, 1, -1]
        ]
      ],
      [
        Colors.blueGrey,
        [
          [-1, -1, -1],
          [-1, -1, 1],
          [-1, 1, 1],
          [-1, 1, -1],
          [-1, -1, -1]
        ]
      ]
    ], false);
  }
}