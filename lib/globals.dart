
// shock horror of global variables
import 'package:flutter/material.dart';

import 'my-game.dart';
late MyGame myGame;

var settingsState;
var settingsPanelState;

// styling
const  textStyleWhiteBold = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
const textStyleWhite = TextStyle(color: Colors.white);
const colHeader = TextStyle(color: Colors.orange);


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

// when music controlled use these influences

bool musicControlled = true;

double bassMixCohesion = .33;
double bassMixAlignment = .33;
double bassMixAvoidance = .33;

double midMixCohesion = .33;
double midMixAlignment = .33;
double midMixAvoidance = .33;

double highMixCohesion = .33;
double highMixAlignment = .33;
double highMixAvoidance = .33;

int cameraBoidIndex = 0;
double cameraDirection = 1.0;
bool cameraCut  = true;
bool boidCameraOnOff = true;
bool flyCamOn = false;


double targetFPS = 60.0;
double autoSpawnTimeRemainingInSeconds = 20.0;