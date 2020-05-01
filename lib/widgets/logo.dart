import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFFFFB799),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: FaIcon(FontAwesomeIcons.dove),
      ),
    );
  }
}