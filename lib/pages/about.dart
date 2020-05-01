import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/lyricsBloc.dart';
import 'package:tononkira_alfa/widgets/logo.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

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
        title: Text("Mikasika ny fitaovana"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            ListTile(
              leading: Logo(),
              title: Text("Tononkira ALFA"),
              subtitle: Text("navoaka ny 27 aprily 2020"),
              trailing: Text("0.0.1(3)"),
            ),
            SizedBox(height: 20,),
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
                        leading: FaIcon(FontAwesomeIcons.music),
                        title: Text("Isan'ny tononkira"),
                        trailing: Text(Provider.of<LyricsBloc>(context, listen: false).lyricsList.length.toString()),
                      ),
                      Divider(height: 1,),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        leading: FaIcon(FontAwesomeIcons.code),
                        title: Text("nykantorandria")
                      ),
                      Divider(height: 1,),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        leading: FaIcon(FontAwesomeIcons.dev),
                        title: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 18),
                            children: [
                              TextSpan(text: "mandres", style: TextStyle(color: Color(0xFFFFB799))),
                              TextSpan(text: "hope", style: TextStyle(color: Color(0xFFFF7B4E), fontWeight: FontWeight.bold)),
                            ]
                        )),
                      ),
                    ],
                  ),
                )
              )
            )
          ],
        ),
      )
    );
  }
}