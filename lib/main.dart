
import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:boids/boids.dart';
import 'package:boids/display.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple3d/display.dart';
import 'package:simple3d/simple3d.dart';

import 'camera.dart';
import 'globals.dart';
import 'my-game.dart';
import 'ui/widgets.dart';



void main() {
   myGame = MyGame();
  runApp(
    FlutterApp()
  );
}


class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bad Boids',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
            toolbarHeight: 00,
            actions: [],
        ),

        body: body(context)
      )
    );

  }

  Widget body(ctx) {
  return Row(
    children: [
    SettingsWidget(),
    Expanded(child: GameWidget<MyGame>(
      game: myGame,
    ))],
    );
  }
}








