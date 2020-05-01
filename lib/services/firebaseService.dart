import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tononkira_alfa/models/lyrics.dart';

class FirebaseService {
  //singleton
  static final FirebaseService _bloc = FirebaseService.internal();
  factory FirebaseService() {
    return _bloc;
  }
  FirebaseService.internal();
  final _firestore = Firestore.instance;

  Future<QuerySnapshot> getLyrics() {
    return _firestore
        .collection('lyrics')
        .orderBy("date", descending: true)
        .getDocuments();
  }

  Future<void> addLyrics(LyricsModel lyrics) async {
    var firestore = Firestore.instance;
    var docRef = firestore.collection('lyrics').document();
    docRef.setData(LyricsModel(
      id: docRef.documentID,
      title: lyrics.title,
      content: lyrics.content,
      date: lyrics.date
    ).toJson());
  }

  Future<void> updateLyrics(LyricsModel lyrics) {
    return _firestore
      .collection('lyrics')
      .document(lyrics.id)
      .updateData(lyrics.toJson());
  }

  Future<void> deleteLyrics(LyricsModel lyrics) {
    return _firestore
      .collection('lyrics')
      .document(lyrics.id)
      .delete();
  }
  
}