import 'dart:io';

import 'package:fetch_voice_data/firebase/firbase_api.dart';
import 'package:fetch_voice_data/firebase/model.dart';
import 'package:fetch_voice_data/recording/play_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordingButton extends StatefulWidget {
  final String userId;
  final VoiceState state;
  const RecordingButton({Key? key, required this.state, required this.userId})
      : super(key: key);

  @override
  _RecordingButtonState createState() => _RecordingButtonState();
}

enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _RecordingButtonState extends State<RecordingButton> {
  Directory? appDirectory;

  RecordingState recordingState = RecordingState.Set;

  String filePath = "";
  FlutterSoundRecorder? _myRecorder = FlutterSoundRecorder();
  late bool _mRecorderIsInited;
  String _mPath = "";
  // Recorder properties
  String voiceUrl = "";
  bool alreadyTapped = false;

  @override
  void initState() {
    // TODO: implement initState
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
  }

  Future<void> openTheRecorder() async {
    if (Platform.isAndroid) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }

    await _myRecorder!.openAudioSession();
    _mRecorderIsInited = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    appDirectory = null;
    recordingState = RecordingState.UnSet;
    if (_myRecorder != null) {
      _myRecorder!.closeAudioSession();
      _myRecorder = null;
    }
    super.dispose();
  }

  Future<void> record() async {
    var tempDir = await getTemporaryDirectory();
    _mPath = "${tempDir.path}/sound.wav";
    if (_myRecorder != null) {
      await _myRecorder!.startRecorder(toFile: _mPath, codec: Codec.pcm16WAV);
      recordingState = RecordingState.Recording;
    }
  }

  Future<void> stopRecorder(String userId) async {
    if (_myRecorder != null) {
      setState(() {
        if (_mPath != "") {
          filePath = _mPath;
        }
      });

      if (filePath != "") {
        Voice voice = Voice(state: widget.state);
        // FirebaseApi.addVoice(voice, filePath);
        File record = File(filePath);
        //sendSpeech2(filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.greenAccent,
          content:
              const Text("Try again, there has been a problem with the file"),
        ));
      }

      const String message = 'Your voice has been uploaded ! ☺️';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 15),
          content: Container(
            height: 30,
            child: Center(
              child: const Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          duration: const Duration(milliseconds: 1300),
        ),
      );

      /// sendVoiceMessage
      FocusScope.of(context).unfocus();

      // ici il ya le post
      // faire un await du post -> pour attendre
    }
    // _onRecordComplete();
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        height: MediaQuery.of(context).size.width * 0.23,
        width: MediaQuery.of(context).size.width * 0.23,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple[100]!.withOpacity(0.90),
              offset: const Offset(0, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: PlayButton(
            gradient:
                const LinearGradient(colors: [Colors.white70, Colors.white70]),
            pauseIcon: const Icon(Icons.mic, color: Colors.black, size: 30),
            playIcon: const Icon(Icons.mic_off, color: Colors.black, size: 30),
            onPressed: () async {
              if (!alreadyTapped) {
                await _onRecordButtonPressed(userId);
              } else {
                await _onRecordButtonPressed(userId);
              }
              setState(() {
                alreadyTapped = !alreadyTapped;
              });
            }),
      ),
    );
  }

  Future<void> _onRecordButtonPressed(String userId) async {
    switch (recordingState) {
      case RecordingState.Set:
        await record(); //on attend le lancement du record
        break;

      case RecordingState.Recording: // si on record, on attend la fin du record
        await stopRecorder(userId);
        recordingState = RecordingState.Stopped;
        // _recordIcon = Icons.fiber_manual_record;
        break;

      case RecordingState.Stopped:
        await record();
        //sendSpeech2();
        break;

      case RecordingState.UnSet:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Please allow recording from settings.'),
        ));
        // print(records);
        break;
    }
  }
}
