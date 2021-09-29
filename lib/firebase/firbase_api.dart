import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetch_voice_data/firebase/model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseApi {
  static Future<void> addVoice(Voice voice) async {
     DocumentReference docRef =
        await FirebaseFirestore.instance.collection('voices').add(voice.toJson());
  }
}

class FireAuth {
  static Future<void> signIn() {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
  }
}