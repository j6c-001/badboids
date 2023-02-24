

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple3d/simple3d.dart';
import 'package:simple3d/vertex_model.dart';


final aWedge = makeVertexModel([
    [
      [0,0,1],
      [0,1,0],
      [0,0,-1],
      [-1,0,0],
    ],
    [
      [Colors.red, [0,1,3]],
      [Colors.green, [2,1,3]],
      [Colors.deepPurple, [0,1,2]],
      [Colors.blue, [0,2,3]],
    ]
]);

final r2 = sqrt(2.0)/2.0;

final aGem =  makeVertexModel([
  [
    [-1,0,0],
   [-r2,0,r2],
    [r2,0,r2],
    [1,0,0],
    [r2,0,-r2],
    [-r2,0,-r2],
    [0,1,0],
    [0,-1,0],
  ],
    [
      [Colors.green, [0,6, 1]],
      [Colors.red, [1,6, 2]],
      [Colors.blue, [2,6, 3]],
      [Colors.deepOrange, [3,6, 4]],
      [Colors.amber, [4,6, 5]],
      [Colors.indigo, [5,6, 0]],
      [Colors.green, [0,7, 1]],
      [Colors.red, [1,7, 2]],
      [Colors.blue, [2,7, 3]],
      [Colors.deepOrange, [3,7, 4]],
      [Colors.amber, [4,7, 5]],
      [Colors.indigo, [5,7, 0]],
    ]
  ]
);

final aBird = aWedge;
