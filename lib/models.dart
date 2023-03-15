

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple3d/simple3d.dart';
import 'package:simple3d/vertex_model.dart';


/*final aWedge =  makeVertexModel([
  [
    [-1.0,-1.0,-1.0], // triangle 1 : begin
    [-1.0,-1.0, 1.0],
    [-1.0, 1.0, 1.0], // triangle 1 : end
    [1.0, 1.0,-1.0], // triangle 2 : begin
    [-1.0,-1.0,-1.0],
    [-1.0,1.0,-1.0], // triangle 2 : end
    [1.0,-1.0, 1.0,],
    [-1.0,-1.0,-1.0],
    [1.0,-1.0,-1.0,],
    [1.0, 1.0,-1.0,],
    [1.0,-1.0,-1.0,],
    [-1.0,-1.0,-1.0],
    [-1.0,-1.0,-1.0],
    [-1.0, 1.0, 1.0],
    [-1.0, 1.0,-1.0],
    [1.0,-1.0, 1.0],
    [-1.0,-1.0, 1.0],
    [-1.0,-1.0,-1.0],
    [-1.0, 1.0, 1.0],
    [-1.0,-1.0, 1.0],
    [1.0,-1.0, 1.0],
    [1.0, 1.0, 1.0],
    [1.0,-1.0,-1.0],
    [1.0, 1.0,-1.0],
    [1.0,-1.0,-1.0],
    [1.0, 1.0, 1.0],
    [1.0,-1.0, 1.0],
    [1.0, 1.0, 1.0],
    [1.0, 1.0,-1.0],
    [-1.0, 1.0,-1.0],
    [1.0, 1.0, 1.0],
    [-1.0, 1.0,-1.0],
    [-1.0, 1.0, 1.0],
    [1.0, 1.0, 1.0],
    [-1.0, 1.0, 1.0],
    [1.0,-1.0, 1.0]
  ]    ,  [
    [Colors.red, [0, 1, 2]],
    [Colors.green, [3,4,5]],
    [Colors.red, [6,7, 8]],
    [Colors.green, [9, 10, 11]],
    [Colors.red, [12, 13, 14]],
    [Colors.green, [15, 16, 17]],
    [Colors.red, [18, 19, 20]],
    [Colors.green, [21, 22, 23]],
    [Colors.red, [24, 25, 26]],
    [Colors.green, [27, 28, 29]],
    [Colors.red, [30, 31, 32]],
    [Colors.green, [33, 34, 35]],
    [Colors.red, [36, 37, 38]],
    [Colors.green, [39, 40, 41]],
    [Colors.red, [42, 43, 44]],
    [Colors.green, [45, 46, 47]]
  ]
])*/
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

final r2 = sqrt(2.0);

final aGem = makeVertexModel([
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
