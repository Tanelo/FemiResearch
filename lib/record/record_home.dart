import 'package:fetch_voice_data/firebase/model.dart';
import 'package:fetch_voice_data/record/record_voice.dart';
import 'package:flutter/material.dart';

class RecordHome extends StatefulWidget {
  const RecordHome({Key? key}) : super(key: key);

  @override
  _RecordHomeState createState() => _RecordHomeState();
}

class _RecordHomeState extends State<RecordHome> {
  @override
  Widget build(BuildContext context) {
    return const RecordPage(voiceState: VoiceState.sad);
  }
}
