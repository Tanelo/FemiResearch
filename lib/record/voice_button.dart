// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fetch_voice_data/record/play_button.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';

class VoiceButton extends StatefulWidget {
  const VoiceButton({Key? key}) : super(key: key);

  @override
  _VoiceButtonState createState() => _VoiceButtonState();
}

enum ButtonState {
  //c'est un dictionnaire qui caractérise tous nos états possibles
  UnSet, //Unset et Set sont disjoints
  Set,
  Recording,
  Stopped,
}

class _VoiceButtonState extends State<VoiceButton> {
  String? voiceFilePath;
  String? _mPath;
  FlutterSoundRecorder? _myRecorder = FlutterSoundRecorder();
  late bool _recorderInitialized;
  bool alreadyTapped = false;
  ButtonState _state = ButtonState.Set;

  Future<void> openTheRecorder() async {
    if (Platform.isAndroid) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }

    await _myRecorder!.openAudioSession();
    _recorderInitialized = true;
  }

  Future<void> record() async {
    var tempDir = await getTemporaryDirectory();
    _mPath = '${tempDir.path}/flutter_sound_example.wav';
    if (_myRecorder != null) {
      await _myRecorder!.startRecorder(toFile: _mPath, codec: Codec.pcm16WAV);
      _state = ButtonState.Recording;
    }
  }

  Future<void> stopRecorder() async {
    if (_myRecorder != null) {
      String filePathAsync = (await _myRecorder!.stopRecorder())!;
      setState(() {
        if (_mPath != null) {
          voiceFilePath = _mPath;
          // print(voiceFilePath);
          voiceFile = File(voiceFilePath!);
        }
      });
      print(voiceFilePath);
    } else {
      _showSnackBarErrorRecording();
    }
  }

  @override
  void dispose() {
    _state = ButtonState.UnSet;
    if (_myRecorder != null) {
      _myRecorder!.closeAudioSession();
      _myRecorder = null;
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    openTheRecorder().then((value) {
      setState(() {
        _recorderInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple[100]!,
            offset: const Offset(0, 1),
            blurRadius: 10,
          ),
        ],
      ),
      height: 100,
      width: 100,
      child: PlayButton(
        pauseIcon: const Icon(Icons.mic, color: Colors.black, size: 30),
        playIcon: const Icon(Icons.mic_off, color: Colors.black, size: 30),
        onPressed: () async {
          if (!alreadyTapped) {
            // print("je suis la ");
            await _onRecordButtonPressed();
          } else {
            // print("je ne suis pas là");
            await _onRecordButtonPressed();
          }
          setState(() {
            alreadyTapped = !alreadyTapped;
          });
        },
        gradient:
            const LinearGradient(colors: [Colors.white70, Colors.white70]),
      ),
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_state) {
      case ButtonState.Set:
        await record(); //on attend le lancement du record
        break;

      case ButtonState.Recording: // si on record, on attend la fin du record
        await stopRecorder();
        _state = ButtonState.Stopped;
        break;

      case ButtonState.Stopped:
        await record();
        break;

      case ButtonState.UnSet:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _showSnackBarAllowRecording();
        // print(records);
        break;
    }
  }
}

void _showSnackBarErrorRecording() {}

void _showSnackBarAllowRecording() {}
