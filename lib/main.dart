import 'package:flame/game.dart';
import 'package:flutter/material.dart';

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
