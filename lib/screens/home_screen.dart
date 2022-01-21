import 'package:flutter/material.dart';
import 'package:voiceboxtts/constants.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  final String title = kAppName;
  final Color headerColor = kHeaderBgColor;
  final Color textColor = kTextColor;
  final Color headerTextColor = kHeaderTextColor;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.headerColor,
        titleTextStyle: TextStyle(
          color: widget.headerTextColor,
          fontFamily: 'RobotoLocal',
          fontSize: 18
        ),
        title: Text(widget.title),
      ),
      backgroundColor: kBodyBgColor,
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
