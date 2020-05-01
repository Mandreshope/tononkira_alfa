import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/lyricsBloc.dart';
import 'package:tononkira_alfa/bloc/settings.dart';
import 'package:tononkira_alfa/tools/carouselSlider.dart';
import 'package:zefyr/zefyr.dart';

class LyricsDetailPage extends StatefulWidget {
  LyricsDetailPage({Key key}) : super(key: key);

  @override
  _LyricsDetailPageState createState() => _LyricsDetailPageState();
}

class _LyricsDetailPageState extends State<LyricsDetailPage> {
  PageController pageController = PageController();
  @override
  void initState() {
    Provider.of<SettingsBloc>(context, listen: false).init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final lyricsBloc = Provider.of<LyricsBloc>(context, listen: false);
    final settingsBloc = Provider.of<SettingsBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_){
      //write or call your logic
      //code will run when widget rendering complete
      pageController.jumpToPage(lyricsBloc.index);
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back), 
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        elevation: 0,
        title: Text("Tononkira"),
        actions: <Widget>[
          IconButton(
            icon: Consumer<LyricsBloc>(builder: (__, lyrixBloc, ___) {
              return lyrixBloc.lyricsList[lyrixBloc.index].favoris == 1 
              ? FaIcon(FontAwesomeIcons.heartbeat, color: Colors.red,)
              : FaIcon(FontAwesomeIcons.heart,);
            }),
            onPressed: (){
              if(lyricsBloc.lyricsList[lyricsBloc.index].favoris == 1) {
                lyricsBloc.lyricsList[lyricsBloc.index].favoris = 0;
              }else {
                lyricsBloc.lyricsList[lyricsBloc.index].favoris = 1;
              }
              lyricsBloc.setFavoris(lyricsBloc.index, lyricsBloc.lyricsList[lyricsBloc.index]);
            }
          )
        ],
      ),
      body: CarouselSlider(
        scrollPhysics: BouncingScrollPhysics(),
        onPageChanged: (index) {
          lyricsBloc.setIndex = index;
        },
        pageController: pageController,
        enableInfiniteScroll: false,
        height: MediaQuery.of(context).size.height,
        items: lyricsBloc.lyricsList.map((lyrics) {
          int index = lyricsBloc.lyricsList.indexOf(lyrics);
          return Card(
            elevation: 0,
            margin: EdgeInsets.all(0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(lyrics.title.toString(), 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    trailing: CircleAvatar(child: Text(index.toString()),),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: settingsBloc.zefyr
                    ? ZefyrView(document: NotusDocument.fromJson(jsonDecode(lyrics.content)),)
                    : Text(NotusDocument.fromJson(jsonDecode(lyrics.content)).toPlainText(), style: TextStyle(fontSize: settingsBloc.fontSize.toDouble()),),
                    
                  )
                ],
              ),
            ),
          );
        }).toList()
      )
    );
  }
}