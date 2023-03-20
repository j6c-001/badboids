

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple3d/simple3d.dart';
import 'package:simple3d/vertex_model.dart';


final aBox =  makeVertexModel([
  [
      [-1, 1, -1], // 0
      [ 1, 1, -1], // 1
      [ 1, 1,  1], // 2
      [-1, 1,  1], // 3
      [-1, -1, -1], // 4
      [ 1, -1, -1], // 5
      [ 1, -1,  1], // 6
      [-1, -1,  1], // 7
  ]    ,  [
    [Colors.red, [0, 1, 2]],
    [Colors.green, [0,2,3]],
    [Colors.red, [0,1, 4]],
    [Colors.green, [1, 4, 5]],
    [Colors.red, [0, 3, 7]],
    [Colors.green, [0, 4, 6]],
    [Colors.red, [2, 3, 6]],
    [Colors.green, [3, 6, 7]],
    [Colors.red, [4, 6, 7]],
    [Colors.green, [4, 5, 6]],
    [Colors.red, [1, 2, 6]],
    [Colors.green, [1, 2, 5]],
  ]
]);
final aWedge = makeVertexModel([
    [
      [ 0, -1, 0],
      [ 0, 0, -3],
      [ 1, 0,  1],
      [-1, 0,  1]
    ],
    [
      [Colors.red,  [0,2,3]],
      [Colors.green, [0,1,3]],
      [Colors.yellowAccent, [0,1,2]],
      [Colors.indigoAccent, [1,2,3]],
    ]
]);

final r2 = sqrt(2.0)/2;

final aGem = makeVertexModel([
  [
    [0,1, 0],
    [r2, r2, 0],
    [1, 0, 0],
    [r2, -r2, 0],
    [0, -1, 0],
    [-r2, -r2, 0],
    [-1, 0, 0],
    [-r2, r2, 0],
    [0, 0, -2],
    [0, 0,  1],

  ],
    [
      [Colors.green, [0,1, 8]],
      [Colors.red, [1,2, 8]],
      [Colors.blue, [2,3, 8]],
      [Colors.deepOrange, [3,4, 8]],
      [Colors.amber, [4, 5, 8]],
      [Colors.indigo, [5,6, 8]],
      [Colors.green, [6,7, 8]],
      [Colors.cyanAccent, [7,0, 8]],
      [Colors.green, [0,1, 9]],
      [Colors.red, [1,2, 9]],
      [Colors.blue, [2,3, 9]],
      [Colors.deepOrange, [3,4, 9]],
      [Colors.amber, [4, 5, 9]],
      [Colors.indigo, [5,6, 9]],
      [Colors.green, [6,7, 9]],
      [Colors.cyanAccent, [7,0, 9]],

    ]
  ]
);


final aBird = makeVertexModel([
[
  [0, 0, -1],
  [0, 1, 0],
  [0, 0, 4],
  [-.5, 0, .5],
  [-2, 0, 1],
  [.5, 0, .5],
  [2, 0, 1]
],  [
    [Color(0xFFF78E69), [0,1, 2]],
    [Color(0xFFF78E69), [0,1, 4]],
    [Color(0xFFF78E69), [4, 1, 3]],
    [Color(0xFFF78E69), [6,1, 5]],
    [Color(0xFF51513D), [3,2, 1]],
    [Color(0xFF51513D), [5,2, 1]],
    [Color(0xFFE3DC95), [0,3, 2]],
    [Color(0xFFE3DC95), [0,5, 2]],
    [Color(0xFFE3DCC2), [0,4, 3]],
    [Color(0xFFE3DCC2), [0,6, 5]],

]]);
