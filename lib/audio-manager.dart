
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_audio';

import 'package:boids/globals.dart';


class AudioManager {

  var audioSource;
  late final analyser;

  int initWaitFranes = 30;

  bool playing = false;

  final audioContext = AudioContext();
  late final analyserBuffer;

  late String trackName;

  double get bass =>  (analyserBuffer[0]+analyserBuffer[1]+analyserBuffer[2]+analyserBuffer[3]+analyserBuffer[4]) / (5*255);
  double get mid =>  (analyserBuffer[5]+analyserBuffer[6]+analyserBuffer[7]+analyserBuffer[8]+analyserBuffer[9]) / (5*255);
  double get high =>  (analyserBuffer[10]+analyserBuffer[11]+analyserBuffer[12]+analyserBuffer[13]+analyserBuffer[14]) / (5*255);



  Future<void>  init() async {
    analyser = audioContext.createAnalyser();

    analyser.fftSize = 32;
    analyserBuffer = Uint8List(analyser.frequencyBinCount);


    trackName = 'assets/sounds/sample.mp3'.split('/').last;
    var audioReq = await HttpRequest.request('assets/sounds/sample.mp3', responseType: 'arraybuffer');

    loadMusic(audioReq.response);

  }

  loadMusic(ByteBuffer bytes ) async {
    if(audioSource != null) {
      audioSource.disconnect();
    }

    final  as = audioContext.createBufferSource();
    final buffer =  await audioContext.decodeAudioData(bytes);
    as.buffer =  buffer;

    as.connectNode(audioContext.destination!);
    as.playbackRate?.value = 1.0;
    as.loop = true;

    audioSource = as;
    audioSource.connectNode(analyser);
    audioSource.start();

  }

  void update() {

    if ( initWaitFranes > 0) {
      playing = audioContext.state == 'running';
      initWaitFranes--;
    }

    analyser.getByteFrequencyData(analyserBuffer);
  }


  void pause() {
    if (playing) {
      audioContext.suspend();
      playing  = false;
    }
  }

  void resume() {
    if (!playing) {
      audioContext.resume();
      playing = true;
    }
  }

  void toggle() {
    print(audioContext.state);
    if (audioContext.state == 'suspended') {
      resume();
    } else {
      pause();
    }

  }

  bool wasPlaying = false;
  void playIfNecessary() {
    if(wasPlaying) {
      resume();
      wasPlaying = false;
    }
  }

  void pauseAndRemember() {
    wasPlaying = playing;
    if(playing) {
      pause();
    }
  }




}