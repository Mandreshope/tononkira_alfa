import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/authBloc.dart';
import 'package:tononkira_alfa/bloc/lyricsBloc.dart';
import 'package:tononkira_alfa/models/lyrics.dart';
import 'package:tononkira_alfa/pages/admin/lyrics/LyricsEditor.dart';
import 'package:tononkira_alfa/pages/admin/lyrics/lyricsList.dart';
import 'package:tononkira_alfa/services/firebaseService.dart';
import 'package:tononkira_alfa/tools/materialSearch.dart';
import 'package:tononkira_alfa/tools/routeTransition.dart';
import 'package:tononkira_alfa/widgets/logo.dart';
import 'package:tononkira_alfa/widgets/menuItem.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back), 
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          backgroundColor: Colors.transparent,
        ), 
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.all(15),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 80.0),
              Container(
                width: double.infinity,
                child: Center(
                    child: Logo()
                )
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text("Tononkira ALFA", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ))),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  MenuItem(
                    title: Text(
                      'Hampiditra', 
                      style: TextStyle(color: Color(0xFFFFB799), fontSize: 12, fontWeight: FontWeight.bold)
                    ),
                    icon: FaIcon(FontAwesomeIcons.edit, color: Color(0xFFFFB799),),
                    iconBackground: Color(0xFFFFB799).withOpacity(0.2),
                    onPressed: () {
                      Navigator.of(context).push(CustomOffsetRoute(
                        builder: (_) => LyricsEditorPage(add: Provider.of<LyricsBloc>(context).add),
                      ));
                    }
                  ),
                  MenuItem(
                    title: Text(
                      'Lisitra', 
                      style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)
                    ),
                    icon: FaIcon(FontAwesomeIcons.list, color: Colors.red),
                    iconBackground: Colors.red.withOpacity(0.2),
                    onPressed: () {
                      Navigator.of(context).push(CustomOffsetRoute(
                        builder: (_) => LyricsListPage()
                      ));
                    }
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  MenuItem(
                    title: Text(
                      'Hitady', 
                      style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)
                    ),
                    icon: FaIcon(FontAwesomeIcons.search, color: Colors.blue,),
                    iconBackground: Colors.blue.withOpacity(0.2),
                    onPressed: () {
                      Navigator.of(context)
                          .push(_buildMaterialSearchPage())
                          .then((dynamic value) {
                      });
                    }
                  ),
                  MenuItem(
                    title: Text(
                      'Hivoaka', 
                      style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)
                    ),
                    icon: FaIcon(FontAwesomeIcons.signOutAlt, color: Colors.green),
                    iconBackground: Colors.green.withOpacity(0.2),
                    onPressed: () {
                      Provider.of<AuthBloc>(context, listen: false).signOut();
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildMaterialSearchPage() {
    return CustomOffsetRoute(
       builder: (BuildContext context) {
      return new Material(
        child: FutureBuilder(
          future: FirebaseService().getLyrics(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List lyricsListFromFirebase = snapshot.data.documents.map((doc) => LyricsModel.fromJson(doc)).toList();
              Widget widget;
              if(lyricsListFromFirebase.isNotEmpty) {
                widget = MaterialSearch<String>(
                  leading: IconButton(
                    icon: Icon(CupertinoIcons.back), 
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                  ),
                  placeholder: 'Lohanteny...',
                  results: lyricsListFromFirebase
                      .map((dynamic v) => new MaterialSearchResult<String>(
                            icon: CircleAvatar(child: FaIcon(FontAwesomeIcons.music, size: 20,),),
                            value: "${v.id} title:${v.title}",
                            text: v.title,
                          ))
                      .toList(),
                  filter: (dynamic value, String criteria) {
                    return value.toLowerCase().contains(
                        criteria.replaceAll(new RegExp(r"[^\w\s',`´‚‘’ôœóòöõ!-àéèêëçíìîïùñýÿñ]+"),'').toLowerCase());
                    
                  },
                  onSelect: (dynamic value) {
                    Navigator.of(context).pop();
                    String id = value.substring(0, value.indexOf('title:'));
                    LyricsModel lyrics = lyricsListFromFirebase.elementAt(Provider.of<LyricsBloc>(context, listen: false).getIndexlyricsListFromFirebase(id.trim()));
                    Navigator.of(context).push(
                      CustomOffsetRoute(
                        builder: (_) => LyricsEditorPage(update: Provider.of<LyricsBloc>(context).update, lyrics: lyrics, index: Provider.of<LyricsBloc>(context, listen: false).getIndexlyricsListFromFirebase(id.trim()),),
                      )
                    );
                    
                  },
                );
              }else {
                widget = Scaffold(
                  appBar: new AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    leading: IconButton(
                    icon: Icon(CupertinoIcons.back), 
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                    ),
                    title: new TextField(
                      enabled: false,
                      autofocus: false,
                      decoration: new InputDecoration.collapsed(hintText: "Lohanteny..."),
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  body: Center(child: FaIcon(FontAwesomeIcons.dove, color: Colors.grey[300], size: 40,),)
                );
              }
              return widget;
            }else{
              return Scaffold(
                appBar: new AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  leading: IconButton(
                  icon: Icon(CupertinoIcons.back), 
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                  ),
                  title: new TextField(
                    enabled: false,
                    autofocus: false,
                    decoration: new InputDecoration.collapsed(hintText: "Lohanteny..."),
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                body: Center(child: CircularProgressIndicator(),),
              );
            }
            
          
        })
      );
    });
  }
}