import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/lyricsBloc.dart';
import 'package:tononkira_alfa/pages/lyrics/lyricsDetail.dart';
import 'package:tononkira_alfa/tools/routeTransition.dart';

class FavorisPage extends StatefulWidget {
  const FavorisPage({Key key}) : super(key: key);

  @override
  _FavorisPageState createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  @override
  void initState() {
    Provider.of<LyricsBloc>(context, listen: false)..getAllFavoris();
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
        title: Text("Hira tiana"),
      ),
      body: Consumer<LyricsBloc>(builder: (__, lyricsBloc, ___) {
        return Container(
          child: lyricsBloc.favorisList.length == 0
            ? Center(
                child: FaIcon(FontAwesomeIcons.heartbeat, color: Colors.grey[300], size: 40,),
              )
            : _getFavorisList(lyricsBloc),
        );
      }),
    );
  }

  _getFavorisList(LyricsBloc lyricsBloc) {
    return ListView.builder(physics: BouncingScrollPhysics(), itemCount: lyricsBloc.favorisList.length, itemBuilder: (context, index) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 1),
        elevation: 0,
        child: ListTile(
          leading: CircleAvatar(child: FaIcon(FontAwesomeIcons.heartbeat, color: Colors.red,),),
          title: Text(lyricsBloc.favorisList[index].title),
          onTap: (){
            lyricsBloc.setIndex = lyricsBloc.getIndex(lyricsBloc.favorisList[index].id);
            Navigator.of(context).push(
              CustomOffsetRoute(
                builder: (_) => LyricsDetailPage(),
              )
            ).then((onValue){
              lyricsBloc.getAllFavoris();
            });
          },
        ),
      );
    });
  }
}