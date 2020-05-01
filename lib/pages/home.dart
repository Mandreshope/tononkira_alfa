import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/lyricsBloc.dart';
import 'package:tononkira_alfa/bloc/settings.dart';
import 'package:tononkira_alfa/widgets/logo.dart';
import 'package:tononkira_alfa/widgets/roundedTopClipper.dart';
import 'package:tononkira_alfa/widgets/menuItem.dart';
import 'package:tononkira_alfa/tools/constant.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<LyricsBloc>(context, listen: false)..init();
    Provider.of<SettingsBloc>(context, listen: false)..init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            //head
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFB799),
                    Color(0xFFFF7B4E),
                  ]
                ),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height*.25,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipPath(
                      child: Container(
                        height: MediaQuery.of(context).size.height*.11,
                        width: double.infinity,
                        color: Theme.of(context).scaffoldBackgroundColor
                      ),
                      clipper: RoundedTopClipPath(),
                    ),
                  ),
                  Center(
                    child: Logo()
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text("Tononkira ALFA", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text("Tongasoa", style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      MenuItem(
                        title: Text(
                          'Tononkira', 
                          style: TextStyle(color: Color(0xFFFFB799), fontSize: 12, fontWeight: FontWeight.bold)
                        ),
                        icon: FaIcon(FontAwesomeIcons.dove, color: Color(0xFFFFB799),),
                        iconBackground: Color(0xFFFFB799).withOpacity(0.2),
                        onPressed: () {
                          Navigator.of(context).pushNamed(LYRICS_PAGE);
                        }
                      ),
                      MenuItem(
                        title: Text(
                          'Tononkira tiana', 
                          style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)
                        ),
                        icon: FaIcon(FontAwesomeIcons.heartbeat, color: Colors.red),
                        iconBackground: Colors.red.withOpacity(0.2),
                        onPressed: () {
                          Navigator.of(context).pushNamed(FAVORIS_PAGE);
                        }
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      MenuItem(
                        title: Text(
                          'Fikirana', 
                          style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)
                        ),
                        icon: FaIcon(FontAwesomeIcons.cogs, color: Colors.blue,),
                        iconBackground: Colors.blue.withOpacity(0.2),
                        onPressed: () {
                          Navigator.of(context).pushNamed(SETTINGS_PAGE);
                        }
                      ),
                      MenuItem(
                        title: Text(
                          'Mikasika ny fitaovana', 
                          style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)
                        ),
                        icon: FaIcon(FontAwesomeIcons.exclamationCircle, color: Colors.green),
                        iconBackground: Colors.green.withOpacity(0.2),
                        onPressed: () {
                          Navigator.of(context).pushNamed(ABOUT_PAGE);
                        }
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}