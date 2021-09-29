import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetch_voice_data/firebase/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static Future<void> addVoice(Voice voice, String voiceFilePath) async {
    
    // Put voice in Storage
    final _firebaseStorage = FirebaseStorage.instance;
    var file = File(voiceFilePath);

    //Upload to Firebase
    var snapshot = await _firebaseStorage
        .ref()
        .child('voices/${voice.id}|${voice.userId}|${voice.state.toString()}.wav')
        .putFile(file);
    var voiceUrl = await snapshot.ref.getDownloadURL();

    // Update voice in firestore
     DocumentReference docRef =
        await FirebaseFirestore.instance.collection('voices').add(voice.toJson());
      Voice newVoice = Voice(
      id: docRef.id,
      userId: voice.userId,
      state: voice.state,
      createdAt: voice.createdAt,
      url: voiceUrl,
    );
    await docRef.update(newVoice.toJson());
  }
}

class FireAuth {
  static Future<void> signIn() async {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
  }
}