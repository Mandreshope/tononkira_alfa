import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

//------------lyrics-----------------



//-----------------------------------

//--------------Wakelock----------------
Future initWakelockBox() async {
  await Hive.initFlutter();
  await openBoxWakelock();
}

Future<Box<bool>> openBoxWakelock() async {
  var box = await Hive.openBox<bool>('wakelock');
  return box;
}

Future<void> setWakelock(bool val) async {
  var box = await Hive.openBox<bool>('wakelock');
  box.put('wakelock', val); 
  print('set ok');
}

Future<bool> getWakelock() async {
  var box = await openBoxWakelock();
  print('get ok');
  return box.get('wakelock');
}

//-----------------------------

//-------------FontSize----------------
Future initFontSizeBox() async {
  await Hive.initFlutter();
  await openBoxWakelock();
}

Future<Box<int>> openBoxFontSize() async {
  var box = await Hive.openBox<int>('fontSize');
  return box;
}

Future<void> setFontSize(int val) async {
  var box = await Hive.openBox<int>('fontSize');
  box.put('fontSize', val); 
  print('set fontSize ok');
}

Future<int> getFontSizek() async {
  var box = await openBoxFontSize();
  print('get fontSize ok');
  return box.get('fontSize');
}
//-----------------------------

//-------------Zefyr----------------
Future initZefyrBox() async {
  await Hive.initFlutter();
  await openBoxWakelock();
}

Future<Box<bool>> openBoxZefyr() async {
  var box = await Hive.openBox<bool>('Zefyr');
  return box;
}

Future<void> setZefyr(bool val) async {
  var box = await Hive.openBox<bool>('Zefyr');
  box.put('Zefyr', val); 
  print('set Zefyr ok');
}

Future<bool> getZefyr() async {
  var box = await openBoxZefyr();
  print('get Zefyr ok');
  return box.get('Zefyr');
}
//-----------------------------