import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/lyricsBloc.dart';
import 'package:tononkira_alfa/pages/admin/root.dart';
import 'package:tononkira_alfa/tools/routeTransition.dart';
import 'package:tononkira_alfa/bloc/settings.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    Provider.of<SettingsBloc>(context, listen: false).init();
    Provider.of<LyricsBloc>(context, listen: false).init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _settingsBloc = Provider.of<SettingsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back), 
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        elevation: 0,
        title: Text("Fikirana"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            ListTile(
              leading: Icon(Icons.text_format),
              title: Text("Aaa", style: TextStyle(fontSize: _settingsBloc.fontSize.toDouble()),),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        leading: Icon(Icons.text_format,),
                        title: Slider(
                          min: 10.0,
                          max: 30.0,
                          value: _settingsBloc.fontSize.toDouble(), 
                          onChanged: (val) {
                            _settingsBloc.addFontSize(val.toInt());
                          }
                        ),
                        trailing: Text(_settingsBloc.fontSize.toString()),
                      ),
                      Divider(height: 1,),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        leading: Icon(Icons.texture, color: Colors.grey),
                        title: Text("Zefyr"),
                        trailing: Switch(
                          value: _settingsBloc.zefyr, 
                          onChanged: (val) {
                            _settingsBloc.addZefyr(val);
                          }
                        ),
                      ),
                      Divider(height: 1,),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        leading: Icon(Icons.phone_android, color: Colors.grey),
                        title: Text("Avela hirehitra"),
                        trailing: Switch(
                          value: _settingsBloc.wakelock, 
                          onChanged: (val) {
                            _settingsBloc.addWakelock(val);
                          }
                        ),
                      ),
                      Divider(height: 1,),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        leading: FaIcon(FontAwesomeIcons.download),
                        title: Text('Vaovao farany'),
                        subtitle: Text("Mitaky fifandraisana amin'ny internet ny fizahana ny fiovana misy amin'ny tononkira", style: TextStyle(fontSize: 12),),
                        onTap: () async {
                          Provider.of<LyricsBloc>(context, listen: false).getAllLyricsFromFirebase();
                          bool confirm = await _getLoadingDialog();
                          if(confirm is bool && confirm) {
                            Provider.of<LyricsBloc>(context, listen: false).addAllLyricsFromFirebaseInHive();
                          }
                        },
                      ),
                      Divider(height: 1,),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        leading: FaIcon(FontAwesomeIcons.dove),
                        title: Text('Hampiditra hira'),
                        trailing: Icon(CupertinoIcons.forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            CustomOffsetRoute(
                              builder: (_) => RootPage(),
                            )
                          );
                        },
                      ),
                    ],
                  ),
                )
              )
            )
          ],
        ),
      ),
    );
  }

  _getLoadingDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        final lyricsBloc = Provider.of<LyricsBloc>(context);
        switch (lyricsBloc.allLyricsFromFirebaseSate) {
          case LoadingState.progress:
            return AlertDialog(
              content: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Text('Eo ampamarana...'),
                  )
                ],
              ), 
            );
            break;
          case LoadingState.success:
            return AlertDialog(
                title: Text('Fampafantarina'),
                content: Row(
                  children: <Widget>[
                    Expanded(
                      child: lyricsBloc.updateState 
                      ? Text('Nisy fanavaozana ny tononkira. \nHaka izany ve ianao ?')
                      : Text('Tsy nahitana fanavaozana ny tononkira')
                    )
                  ],
                ), 
                actions: <Widget>[
                  if(lyricsBloc.updateState)
                  FlatButton(
                    child: Text('TSIA'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  if(lyricsBloc.updateState)
                  FlatButton(
                    child: Text('ENY'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  if(!lyricsBloc.updateState)
                  FlatButton(
                    child: Text('HIALA'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
            );
            break;
          case LoadingState.error:
            return AlertDialog(
              title: Text('Fampafantarina'),
              content: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Nisy tsy fetezana, hamarino ny fifandraisana amin'ny internet"),
                  )
                ],
              ), 
              actions: <Widget>[
                FlatButton(
                  child: Text('HIALA'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          default:
            return AlertDialog(
              content: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Text('Eo ampamarana...'),
                  )
                ],
              ), 
            );
        }
      },
    );
  }
}