import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetch_voice_data/firebase/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseApi {
  static Future<void> addVoice(File voiceFile, Voice voice) async {
    // Put voice in Storage
    final _firebaseStorage = FirebaseStorage.instance;
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('voices')
        .add(voice.toJson());

    Voice newVoice = Voice(
      id: docRef.id,
      userId: voice.userId,
      state: voice.state,
      createdAt: voice.createdAt,
      text: voice.text,
    );
    await docRef.update({'id': docRef.id});
    //Upload to Firebase
    var snapshot = await _firebaseStorage
        .ref()
        .child(
            'voices/${describeEnum(newVoice.state)}/${newVoice.id}|${newVoice.userId}|${describeEnum(newVoice.state)}.wav')
        .putFile(voiceFile);
    var voiceUrl = await snapshot.ref.getDownloadURL();
    print(voiceUrl);

    // Update voice in firestore

    await docRef.update({"url": voiceUrl});
  }
}

class FireAuth {
  static Future<String> signIn() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    return userCredential.user!.uid;
  }
}
