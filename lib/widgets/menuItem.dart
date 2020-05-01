import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({Key key, this.title, this.icon, this.iconBackground, @required this.onPressed}) : super(key: key);

  final Text title;
  final FaIcon icon;
  final Color iconBackground;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 120,
      margin: EdgeInsets.all(10),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(50)
              ),
              child: Center(
                child: icon,
              ),
            ),
            title
          ],
        ),
        onPressed: onPressed
      ),
    );
  }
}