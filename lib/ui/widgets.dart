import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:url_launcher/url_launcher.dart';


import '../globals.dart';


class SettingsWidget extends StatefulWidget  {
  SettingsWidget({Key? key}) : super(key: key);
  @override
  SettingsWidgetState createState()  {
    return SettingsWidgetState();
  }
}

class SettingsWidgetState extends State<SettingsWidget> {

  OverlayEntry? settingsButton;
  OverlayEntry? settingsPanel;



  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=>showSettings());
    settingsPanelState = this;
  }


  bool settingsOpen = false;
  void showSettings() {
    final o = Overlay.of(context);

    settingsPanel =  OverlayEntry(builder: (ctx)=> Positioned(left: 20, top: 20, child: BoidSettings() ),maintainState: true);
    settingsButton = OverlayEntry(builder: (ctx)=> Positioned(left: 20, top: 20, child: IconButton(
        color: Colors.deepOrange,
        icon: Icon(Icons.settings),
        onPressed: (){
      settingsButton?.remove();
      o.insert(settingsPanel!);
    }), ), maintainState: true);
    o.insert(settingsButton!);
  }


  void swapBack() {
    if (settingsPanel?.mounted == true) {
      settingsState = null;
      settingsPanel?.remove();
      final o = Overlay.of(context);
      o.insert(settingsButton!);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Text('');
  }
}


class BoidSettings extends StatefulWidget {
  BoidSettings({Key? key}) : super(key: key);
  @override
  BoidSettingsState createState()  {
    settingsState = BoidSettingsState();
    return settingsState;
  }

}


class BoidSettingsState extends State<BoidSettings> {
  @override
  Widget build(BuildContext context) {



    return Material(
        color: Colors.transparent,
        child: Container(
            width: 282.0,
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(4)
            ),
            child:  Padding(
              padding: EdgeInsets.all(10),
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                              onPressed: () =>  _launchInBrowser(Uri(scheme: 'https', host: 'www.github.com', path: 'j6c-001/badboids')),
                              label: Text('Bad Boids', style: textStyleWhiteBold),
                              icon: Icon(Icons.open_in_browser_sharp, color: Colors.deepOrange),
                          ),
                          IconButton(

                            tooltip: 'Turn Sound ${myGame.audioManager.playing ? 'Off' : 'On'}',
                            color: Colors.deepOrange,
                            onPressed: myGame.play ? () {
                              setState(() {
                                myGame.audioManager.toggle();
                              });
                            } : null,
                            icon: Icon(myGame.audioManager.playing ? Icons.volume_up : Icons.volume_off),
                          ),
                          IconButton(
                            tooltip: '${musicControlled ? 'Disable' : 'Enable'} music controlled boids',
                              color: Colors.deepOrange,
                              onPressed: () {
                                setState(() {
                                  musicControlled = !musicControlled;
                                });
                              },
                              icon: Icon(musicControlled ? Icons.music_note_sharp : Icons.music_off_sharp),
                          ),
                          IconButton(
                              color: Colors.deepOrange,
                              onPressed: () {
                                settingsPanelState.swapBack();
                              },
                              icon: Icon(Icons.close_sharp)
                          ),

                        ]
                    ),
                    Divider(),
                    Row(
                      children: [
                        IconButton(
                            tooltip: 'Switch between follow or fixed camera',
                            icon: Icon(boidCameraOnOff ? Icons.camera_outlined : Icons.camera),
                            color: Colors.deepOrange,
                            onPressed: () {
                              boidCameraOnOff = !boidCameraOnOff;
                            }),
                        IconButton(
                            tooltip: 'Point camera at a random boid',
                            icon: Icon(Icons.cameraswitch_sharp),
                            color: Colors.deepOrange,
                            onPressed: () {
                              cameraBoidIndex = Random().nextInt(numberOfBoids);
                            }),
                        IconButton(
                            tooltip: 'Switch to ' + (cameraDirection < 0 ? 'back facing camera' : 'front facing camera'),
                            icon: Icon(cameraDirection > 0 ? Icons.arrow_forward_sharp : Icons.arrow_back_sharp),
                            color: Colors.deepOrange,
                            onPressed: () {
                              cameraDirection *= -1.0;
                              cameraCut = true;
                            }),

                        IconButton(
                            tooltip: 'Play Simulation',
                            icon: Icon(Icons.play_arrow),
                            color: Colors.deepOrange,
                            disabledColor: Colors.grey,
                            onPressed: myGame.play ? null : () {
                              myGame.play = true;
                              myGame.audioManager.playIfNecessary();
                            }
                        ),
                        IconButton(
                            tooltip: 'Pause Simulation',
                            icon: Icon(Icons.pause),
                            disabledColor: Colors.grey,
                            color: Colors.deepOrange,
                            onPressed: myGame.play ? () {
                              myGame.play = false;
                              myGame.audioManager.pauseAndRemember();

                            } : null
                        ),
                        IconButton(
                            tooltip: 'Reset Simulation',
                            icon: Icon(Icons.lock_reset),
                            color: Colors.deepOrange,
                            onPressed: () {
                              myGame.needsReset = true;
                            }
                        ),

                      ],
                    ),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Cohesion', style: textStyleWhite), Slider(
                          activeColor: Colors.deepOrange,
                          value: cohesionFactor,
                          max: 3,
                          min: 0,
                          divisions: 100,
                          onChanged: (double v) {
                            setState(() {
                              cohesionFactor = v;
                            });
                          },

                        )]),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Alignment', style: textStyleWhite),Slider(
                          activeColor: Colors.deepOrange,
                          value: alignmentFactor,
                          max: 3,
                          min: 0,
                          divisions: 100,
                          onChanged: (double v) {
                            setState(() {
                              alignmentFactor = v;
                            });
                          },

                        )]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Avoidance', style: textStyleWhite),Slider(
                          activeColor: Colors.deepOrange,
                          value: avoidOthersFactor,
                          max: 3,
                          min: 0,
                          divisions: 100,
                          onChanged: (double v) {
                            setState(() {
                              avoidOthersFactor = v;
                            });
                          },

                        )]),



                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Boids', style: textStyleWhite),
                          Slider(
                            activeColor: Colors.deepOrange,
                            value: log(numberOfBoids)/(log(maxBoids)/99)+1,
                            label: 'Boids: $numberOfBoids',
                            max: 100,
                            min: 1,
                            onChanged: (double v) {
                              setState(() {
                                numberOfBoids = pow(exp(log(maxBoids)/99), v-1).ceil();
                              });
                            },
                          )]),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Mix b/w/g', style: textStyleWhite),
                          RangeSlider(
                            inactiveColor: Colors.deepOrange,
                            activeColor: Colors.tealAccent,
                            values: RangeValues(mixBirdies, mixWedges),
                            labels: RangeLabels('B:${(mixBirdies*100).round()}%  W:${(mixWedges*100).round()}% G:${((1-mixWedges)*100).round()}% ', 'B:${(mixBirdies*100).round()}% W:${(mixWedges*100).round()}% G:${((1-mixWedges)*100).round()}% '),
                            onChangeEnd: (RangeValues v) {

                            },
                            onChanged: (RangeValues v) {
                              setState(() {
                                mixBirdies = v.start;
                                mixWedges = v.end;
                                myGame.needsMixReset = true;
                              });
                            },
                          )]),


                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Zoom', style: textStyleWhite),
                          Slider(
                            activeColor: Colors.deepOrange,
                            value: log(myGame.camera.viewingDistance)/(log(maxViewingDistance)/99)+1,
                            max: 100,
                            min: 1,
                            onChanged: (double v) {
                              setState(() {
                                myGame.camera.viewingDistance =  pow(exp(log(maxViewingDistance)/99), v-1).ceilToDouble();
                              });
                          },
                        )]),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( 'Boids: $countBoids', style: textStyleWhite),
                        Text( 'FPS: ${fps.toStringAsFixed(1)}', style: textStyleWhite),
                        Text( 'Tris: ${myGame.view.cntPolysRendered}/${myGame.view.cntPolys}', style: textStyleWhite)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Birdies: $countBirdies', style: textStyleWhite),
                        Text('Wedges: $countWedges', style: textStyleWhite),
                        Text('Gems: $countGems', style: textStyleWhite),
                      ],
                    ),
                    Divider(),
                    ... (!musicControlled ? [] : [
                    Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Parameter', style: colHeader),
                            Text('Band', style: colHeader),
                            Tooltip(
                                message: 'Use the sliders below to configure the influence each frequency band Low/Mid/High has on the corresponding flock parameter (Cohesion/Alignment/Avoidance)',
                                child: Icon(Icons.info_outline, color: Colors.orange),

                            )
                          ]
                    ),
                    Divider(thickness: 1, indent: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Cohesion', style: textStyleWhite),
                          RangeSlider(
                            inactiveColor: Colors.deepOrange,
                            activeColor: Colors.tealAccent,
                            values: RangeValues(bassMixCohesion, bassMixCohesion + midMixCohesion),
                            onChanged: (RangeValues v) {
                              setState(() {
                                bassMixCohesion = v.start;
                                midMixCohesion = v.end - v.start;
                                highMixCohesion = 1 - v.end;
                              });
                            },
                          )]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Alignment', style: textStyleWhite),
                          RangeSlider(
                            inactiveColor: Colors.deepOrange,
                            activeColor: Colors.tealAccent,
                            values: RangeValues(bassMixAlignment, bassMixAlignment + midMixAlignment),
                            onChanged: (RangeValues v) {
                              setState(() {
                                bassMixAlignment = v.start;
                                midMixAlignment = v.end - v.start;
                                highMixAlignment = 1 - v.end;
                              });
                            },
                          )]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Avoidance', style: textStyleWhite),
                          RangeSlider(
                            inactiveColor: Colors.deepOrange,
                            activeColor: Colors.tealAccent,
                            values: RangeValues(bassMixAvoidance, bassMixAvoidance + midMixAvoidance),
                            onChanged: (RangeValues v) {
                              setState(() {
                                bassMixAvoidance = v.start;
                                midMixAvoidance = v.end - v.start;
                                highMixAvoidance = 1 - v.end;
                              });
                            },
                          )]),
                    ]),
                 /*   Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TracK ${myGame.audioManager.trackName}'),
                        IconButton(onPressed: {

                        }, icon: Icon( Icons.restore_page_outlined) )
                      ]
                    )*/


                  ]),
            )
    ));
  }
}


Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

Widget dropzone1(BuildContext context) {
  DropzoneViewController? dzCtrl;
  return Builder(
      builder: (context) =>
          SizedBox.square(dimension: 40, child: DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: (ctrl) => dzCtrl = ctrl,
            onLoaded: () => print('Zone 1 loaded'),
            onError: (ev) => print('Zone 1 error: $ev'),
            onHover: () {
              print('Zone 1 hovered');
            },
            onLeave: () {
              print('Zone 1 left');
            },
            onDrop: (ev) async {
              print('Zone 1 drop: ${ev.name}, $dzCtrl');
              myGame.audioManager.trackName = ev.name;
              final bytes = await dzCtrl?.getFileData(ev);
              myGame.audioManager.loadMusic(bytes!.buffer);
            },
            onDropMultiple: (ev) async {
              print('Zone 1 drop multiple: $ev');
            },
          ),
          ));
}