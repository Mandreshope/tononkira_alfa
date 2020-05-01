import 'package:flutter/cupertino.dart';
import 'package:tononkira_alfa/tools/hive.dart';
import 'package:wakelock/wakelock.dart';

class SettingsBloc with ChangeNotifier {

  SettingsBloc() {
    init();
  }

  int fontSize = 14;
  bool wakelock = false;
  bool zefyr = true;

  init(){
    initWakelock();
    initFontSize();
    initZefyr();
  }

  initWakelock() async {
    var wakelo = await getWakelock();
    if(wakelo == true) {
      wakelock = true;
      Wakelock.enable();
    }else if(wakelo == false){
      wakelock = false;
      Wakelock.disable();
    }else {
      wakelock = true;
      Wakelock.enable();
    }
    notifyListeners();
  }

  initFontSize() async {
    fontSize = await getFontSizek() ?? 14;
    notifyListeners();
  }

  initZefyr() async {
    var zef = await getZefyr();
    if(zef == true) {
      zefyr = true;
    }else if(zef == false){
      zefyr = false;
    }
    notifyListeners();
  }

  addZefyr(bool v) async {
    await setZefyr(v);
    zefyr = v;
    notifyListeners();
  }
  
  addFontSize(int v) async {
    await setFontSize(v);
    fontSize = v;
    notifyListeners();
  }

  addWakelock(bool v) async {
    await setWakelock(v);
    wakelock = v;
    Wakelock.toggle(on: v);
    notifyListeners();
  }
  
}