import 'package:flutter/material.dart';
import 'package:weatherapp/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

class Microphone extends StatefulWidget {
  const Microphone({super.key});

  @override
  State<Microphone> createState() => _MicrophoneState();
}

class _MicrophoneState extends State<Microphone> {
  final Constants _constants = Constants();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void saveAudio() async {
    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.wav';
    if (!isRecorderInit) {
      return;
    }
    if (isRecording) {
      await _soundRecorder!.stopRecorder();
    } else {
      await _soundRecorder!.startRecorder(
        toFile: path,
      );
    }

    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: isRecording
            ? _constants.initialCircleAvatar
            : _constants.recordingCircleAvatar,
        child: GestureDetector(
          onTap: saveAudio,
          child: Icon(
            isRecording ? Icons.close : Icons.mic,
            color: Colors.white,
          ),
        ));
  }
}
