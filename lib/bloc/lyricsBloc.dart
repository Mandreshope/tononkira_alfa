import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:tononkira_alfa/models/lyrics.dart';
import 'package:tononkira_alfa/services/firebaseService.dart';

class LyricsBloc with ChangeNotifier {

  LyricsBloc() {
    init();
  }

  Box _lyricsBox;
  Box _favorisBox;
  List<LyricsModel> lyricsListFromFirebase = List<LyricsModel>();
  List<dynamic> lyricsList = List<dynamic>();
  List<dynamic> favorisList = List<dynamic>();
  bool updateState = false;

  LoadingState allLyricsFromFirebaseSate;
  set setallLyricsFromFirebaseSate(LoadingState val) {
    allLyricsFromFirebaseSate = val;
    notifyListeners();
  }

  LoadingState loading;
  set setLoading(LoadingState val) {
    loading = val;
    notifyListeners();
  }

  int index = 0;
  set setIndex(val) {
    index = val;
    notifyListeners();
  }

  set setupdateState(bool v) {
    updateState = v;
    notifyListeners();
  }

  init() {
    openFavorisBox();
    openLyricsBox();
    getAllLyrics();
    getAllFavoris();
  }

  Future openFavorisBox() async {
    _favorisBox = await Hive.openBox("favoris");
    return;
  }

  Future openLyricsBox() async {
    _lyricsBox = await Hive.openBox("lyrics");
    return;
  }

  getAllLyricsFromFirebase() async {
    setallLyricsFromFirebaseSate = LoadingState.progress;
    await FirebaseService().getLyrics().then((onValue) {
      lyricsListFromFirebase = onValue.documents.map((doc) => LyricsModel.fromJson(doc)).toList();
      if(lyricsList.length != lyricsListFromFirebase.length || (checkUpdate() is bool && checkUpdate())) {
        setupdateState = true;
      }else{
        setupdateState = false;
      }
      setallLyricsFromFirebaseSate = LoadingState.success;
      notifyListeners();
    }).catchError((onError) {
      setallLyricsFromFirebaseSate = LoadingState.error;
    });
  }

  bool checkUpdate() {
    bool updateState;
    lyricsList.forEach((f){
      for (var item in lyricsListFromFirebase) {
        if(item.id == f.id && item.date != f.date) {
          updateState = true;
        }
      }
    });
    return updateState;
  }

  getAllLyrics() {
    Map<dynamic, dynamic> raw = _lyricsBox != null ? _lyricsBox.toMap() : {};
    var list = raw.values.toList()..sort((a, b) => a.date.compareTo(b.date));
    lyricsList = list.reversed.toList();
  }

  getIndex(String id) {
    int index = 0;
    for (var item in lyricsList) {
      if(item.id == id) {
        index = lyricsList.indexOf(item);
      }
    }
    return index;
  }

  getIndexlyricsListFromFirebase(String id) {
    int index = 0;
    for (var item in lyricsListFromFirebase) {
      if(item.id == id) {
        index = lyricsListFromFirebase.indexOf(item);
      }
    }
    return index;
  }

  void setFavoris(int index, LyricsModel lyricsModel) {
    if(lyricsModel.favoris == 1) {
      _favorisBox.put(lyricsModel.id, lyricsModel);
    }else {
      _favorisBox.delete(lyricsModel.id);
    }
    _lyricsBox.putAt(index, lyricsModel);
    lyricsList[index] = lyricsModel;
    notifyListeners();
  }

  getAllFavoris() {
    Map<dynamic, dynamic> raw = _favorisBox != null ? _favorisBox.toMap() : {};
    favorisList = raw.values.toList();
  }

  Future<void> add(LyricsModel lyricsModel) async {
    setLoading = LoadingState.progress;
    await FirebaseService().addLyrics(lyricsModel);
    setLoading = LoadingState.success;
  }

  void addAllLyricsFromFirebaseInHive() {
    _favorisBox.clear();
    for (var item in lyricsList) {
      _lyricsBox.delete(item.id);
    }
    for (var lyrics in lyricsListFromFirebase) {
      _lyricsBox.put(lyrics.id, lyrics);
    }
    getAllLyrics();
  }

  Future<void> update(LyricsModel lyricsModel, index) async {
    setLoading = LoadingState.progress;
    await FirebaseService().updateLyrics(lyricsModel);
    setLoading = LoadingState.success;
    lyricsListFromFirebase[index] = lyricsModel;
    notifyListeners();
    // getAllLyricsFromFirebase();
  }

  Future<void> delete(LyricsModel lyricsModel, index) async {
    FirebaseService().deleteLyrics(lyricsModel);
    lyricsListFromFirebase.removeAt(index);
    notifyListeners();
  }

}

enum LoadingState {initializing, progress, success, error}