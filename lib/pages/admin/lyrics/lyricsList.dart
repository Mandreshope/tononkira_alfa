import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/lyricsBloc.dart';
import 'package:tononkira_alfa/pages/admin/lyrics/LyricsEditor.dart';
import 'package:tononkira_alfa/tools/routeTransition.dart';

class LyricsListPage extends StatefulWidget {
  LyricsListPage({Key key}) : super(key: key);

  @override
  _LyricsListPageState createState() => _LyricsListPageState();
}

class _LyricsListPageState extends State<LyricsListPage> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<LyricsBloc>(context, listen: false)..getAllLyricsFromFirebase();
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back), 
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Lisitra tononkira"),
      ),
      body: Consumer<LyricsBloc>(builder: (__, lyricsBloc, ___) {
        return Container(
          child: lyricsBloc.allLyricsFromFirebaseSate == LoadingState.progress
            ? Center(
                child: CircularProgressIndicator(),
              )
            : lyricsBloc.lyricsListFromFirebase.isEmpty
              ? Center(child: FaIcon(FontAwesomeIcons.dove, color: Colors.grey[300], size: 40,),)
              : _getLyricsList(lyricsBloc)
        );
      }),
    );
  }

  _getLyricsList(LyricsBloc lyricsBloc) {
    return ListView.builder(physics: BouncingScrollPhysics(), itemCount: lyricsBloc.lyricsListFromFirebase.length, itemBuilder: (context, index) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 1),
        elevation: 0,
        child: ListTile(
          leading: CircleAvatar(child: FaIcon(FontAwesomeIcons.music, size: 20,),),
          title: Text(lyricsBloc.lyricsListFromFirebase[index].title),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              lyricsBloc.delete(lyricsBloc.lyricsListFromFirebase[index], index);
            }
          ),
          onTap: (){
            // lyricsBloc.setIndex = index;
            Navigator.of(context).push(
              CustomOffsetRoute(
                builder: (_) => LyricsEditorPage(index: index, update: Provider.of<LyricsBloc>(context).update, lyrics: lyricsBloc.lyricsListFromFirebase[index]),
              )
            );
          },
        ),
      );
    });
  }
}