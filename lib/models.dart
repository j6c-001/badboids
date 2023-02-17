

import 'dart:math';

import 'package:boids/poly.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'view.dart';


final aWedge = Wedge();
final aGem = Gem();
final aBird = Bird();

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
  late Model model;
  final Matrix4 mm = Matrix4.zero();

  Vector3 scale = Vector3(1, 1, 1);


  void prepareFrame(Vector3 position, Vector3 heading,  View view, double angle) {
    setModelMatrix(mm, heading.normalized() , Vector3(0, -1, 0),
        position.x, position.y, position.z);
    mm.scale(scale.x, scale.y, scale.z);
    mm.rotate(heading.normalized(), angle);
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
final r2 = sqrt(2.0)/2.0;

class Gem extends Model {
  List getModel() {
    return makeModel([
      [
        Colors.red,
        [
          [0, 1, 0],
          [r2, r2, 0],
          [0, 0, 1]
        ]

      ],
      [
        Colors.deepOrange,
        [
          [r2, r2, 0],
          [1, 0 , 0],
          [0, 0, 1]
        ]

      ],
      [
        Colors.deepPurple,
        [
          [1, 0, 0],
          [r2, -r2, 0],
          [0, 0, 1]
        ]

      ],
      [
        Colors.green,
        [
          [r2, -r2, 0],
          [0, -1, 0],
          [0, 0, 1]
        ]

      ],
      [
        Colors.amber,
        [
          [0, -1, 0],
          [-r2, -r2, 0],
          [0, 0, 1]
        ]

      ],
      [
        Colors.blue,
        [
          [-r2, -r2, 0],
          [-1, 0, 0],
          [0, 0, 1]
        ]

      ],
      [
        Colors.cyanAccent,
        [
          [-1, 0, 0],
          [-r2, r2, 0],
          [0, 0, 1]
        ]

      ],
      [
        Colors.lime,
        [
          [-r2, r2, 0],
          [0, 1, 0],
          [0, 0, 1]
        ]

      ],
      [
        Colors.lime,
        [
          [0, 1, 0],
          [r2, r2, 0],
          [0, 0, -1]
        ]

      ],
      [
        Colors.cyanAccent,
        [
          [r2, r2, 0],
          [1, 0 , 0],
          [0, 0, -1]
        ]

      ],
      [
        Colors.blue,
        [
          [1, 0, 0],
          [r2, -r2, 0],
          [0, 0, -1]
        ]

      ],
      [
        Colors.amber,
        [
          [r2, -r2, 0],
          [0, -1, 0],
          [0, 0, -1]
        ]

      ],
      [
        Colors.green,
        [
          [0, -1, 0],
          [-r2, -r2, 0],
          [0, 0, -1]
        ]

      ],
      [
        Colors.deepPurple,
        [
          [-r2, -r2, 0],
          [-1, 0, 0],
          [0, 0, -1]
        ]

      ],
      [
        Colors.deepOrange,
        [
          [-1, 0, 0],
          [-r2, r2, 0],
          [0, 0, -1]
        ]

      ],
      [
        Colors.red,
        [
          [-r2, r2, 0],
          [0, 1, 0],
          [0, 0, -1]
        ]

      ],



    ], false);
  }
}


class Bird extends Model {
  List getModel() {
    return makeModel([
      [
        Colors.red,
        [
          [0, -3, 0],
          [0, -2.5, 1],
          [-2, 0,0],
          [0, -3, 0]
        ]
      ],
      [
        Colors.red,
        [
          [0, -3, 0],
          [0, -2.5, 1],
          [2, 0,0],
          [0, -3, 0]
        ]
      ],
      [
        Colors.amber,
        [
          [0, -2.5, 1],
          [-2, 0, 0],
          [-.5, -2, 0],
          [0, -2.5, 1],

        ]
      ],
      [
        Colors.amber,
        [
          [0, -2.5, 1],
          [2, 0,0],
          [.5, -2, 0],
          [0, -2.5, 1],
        ]
      ],
      [
        Colors.green,
        [
          [0, -2.5, 1],
          [0, 2, 0],
          [-.5, -2, 0],
          [0, -2.5, 1],
        ]
      ],
      [
        Colors.green,
        [
          [0, -2.5, 1],
          [0, 2, 0],
          [-.5, -2, 0],
          [0, -2.5, 1],
        ]
      ]

    ], false, swap: true);
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

class TrackModel extends Model {
  List getModel() {
    return makeModel(
        [[ Colors.amber, [
          [0.0, 0.0, 0.0],

          [1.3273008274073845, -1.4960192760169093, -0.014101040734658454],
          [0.9854194672542462, -1.7109336163389344, -9.318981172357667],
          [-0.3247003306944407, -0.20000000000004547, -9.344782762229443],
          [0.0, 0.0, 0.0]
        ]]
        ], false);
  }
}
