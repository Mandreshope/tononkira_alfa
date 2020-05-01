import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/lyricsBloc.dart';
import 'package:tononkira_alfa/pages/lyrics/lyricsDetail.dart';
import 'package:tononkira_alfa/tools/materialSearch.dart';
import 'package:tononkira_alfa/tools/routeTransition.dart';

class LyricsPage extends StatefulWidget {
  LyricsPage({Key key}) : super(key: key);

  @override
  _LyricsPageState createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {  
  @override
  void initState() {
    Provider.of<LyricsBloc>(context, listen: false)..getAllLyrics();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
            icon: FaIcon(FontAwesomeIcons.search, size: 20,), 
            onPressed: () {
              Navigator.of(context)
                  .push(_buildMaterialSearchPage())
                  .then((dynamic value) {
              });
            }
          )
        ],
      ),
      body: Consumer<LyricsBloc>(builder: (__, lyricsBloc, ___) {
        return Container(
          child: lyricsBloc.lyricsList.length == 0
            ? Center(
                child: FaIcon(FontAwesomeIcons.dove, color: Colors.grey[300], size: 40,),
              )
            : _getLyricsList(lyricsBloc),
        );
      }),
    );
  }

  _buildMaterialSearchPage() {
    final lyricsBloc = Provider.of<LyricsBloc>(context, listen: false);
    return CustomOffsetRoute(
       builder: (BuildContext context) {
      return new Material(
        child: new MaterialSearch<String>(
          leading: IconButton(
            icon: Icon(CupertinoIcons.back), 
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          placeholder: 'Lohanteny...',
          results: lyricsBloc.lyricsList
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
            String id = value.substring(0, value.indexOf('title:'));
            lyricsBloc.setIndex = lyricsBloc.getIndex(id.trim());
            Navigator.of(context).push(
              CustomOffsetRoute(
                builder: (_) => LyricsDetailPage(),
              )
            );
          },
        ),
      );
    });
  }
  
  _getLyricsList(LyricsBloc lyricsBloc) {
    return ListView.builder(physics: BouncingScrollPhysics(), itemCount: lyricsBloc.lyricsList.length, itemBuilder: (context, index) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 1),
        elevation: 0,
        child: ListTile(
          leading: CircleAvatar(child: FaIcon(FontAwesomeIcons.music, size: 20,),),
          title: Text(lyricsBloc.lyricsList[index].title),
          trailing: IconButton(
            icon: lyricsBloc.lyricsList[index].favoris == 1 
            ? FaIcon(FontAwesomeIcons.heartbeat, color: Colors.red,)
            : FaIcon(FontAwesomeIcons.heart,), 
            onPressed: () {
              if(lyricsBloc.lyricsList[index].favoris == 1) {
                lyricsBloc.lyricsList[index].favoris = 0;
              }else {
                lyricsBloc.lyricsList[index].favoris = 1;
              }
              lyricsBloc.setFavoris(index, lyricsBloc.lyricsList[index]);
            }
          ),
          onTap: (){
            lyricsBloc.setIndex = index;
            Navigator.of(context).push(
              CustomOffsetRoute(
                builder: (_) => LyricsDetailPage(),
              )
            );
          },
        ),
      );
    });
  }
}