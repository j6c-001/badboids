
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_audio';


class AudioAnalyser {

  late final audioBuffer;
  late final audioSource;
  late final analyser;

  final audioContext = AudioContext();
  late final analyserBuffer;

  double get bass =>  (analyserBuffer[0]+analyserBuffer[1]+analyserBuffer[2]+analyserBuffer[3]+analyserBuffer[4]) / (5*255);
  double get mid =>  (analyserBuffer[5]+analyserBuffer[6]+analyserBuffer[7]+analyserBuffer[8]+analyserBuffer[9]) / (5*255);
  double get high =>  (analyserBuffer[10]+analyserBuffer[11]+analyserBuffer[12]+analyserBuffer[13]+analyserBuffer[14]) / (5*255);



  Future<void>  init() async {
    var audioReq = await HttpRequest.request('assets/sounds/sample.mp3', responseType: 'arraybuffer');
    audioBuffer = await audioContext.decodeAudioData(audioReq.response);
    audioSource =  audioContext.createBufferSource();
    audioSource.buffer = audioBuffer;
    audioSource.connectNode(audioContext.destination!);

    analyser = audioContext.createAnalyser();
    audioSource.connectNode(analyser);

    analyser.fftSize = 32;
    analyserBuffer = Uint8List(analyser.frequencyBinCount);

    audioSource.playbackRate.value = 1.0;
    audioSource.loop = true;
    audioSource.start();
  }

  void update() {
    analyser.getByteFrequencyData(analyserBuffer);

  }


}