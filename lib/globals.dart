
// shock horror of global variables
import 'package:flutter/material.dart';

import 'my-game.dart';
late MyGame myGame;

var settingsState;
var settingsPanelState;

// styling
final textStyleWhiteBold = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
final textStyleWhite = TextStyle(color: Colors.white);


// Simulation and bookkeeping settings.

double fps = 0;
int cntPolys = 0;
int cntPolysRendered = 0;
int countBoids = 0;
int countWedges = 0;
int countBirdies = 0;
int countGems = 0;

int numberOfBoids = 1;
int visibility = 150;
double maxSpeed = 100;
double maxForce = .005;

double mixBirdies = .3;
double mixWedges = mixBirdies + .3;

double maxBoids = 5000;
double maxViewingDistance = 5000;
int maxPolys = maxBoids.toInt() * 16;

double cohesionFactor =  0.50;
double alignmentFactor = 0.85;
double avoidOthersFactor = 1.70;

int cameraBoidIndex = 0;
double cameraDirection = -1.0;
bool boidCameraOnOff = true;
bool flyCamOn = false;
