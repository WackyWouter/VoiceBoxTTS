import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voiceboxtts/constants.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  final String title = kAppName;
  final Color headerColor = kHeaderBgColor;
  final Color textColor = kTextColor;
  final Color primaryColor = kPrimaryColor;
  final Color cardColor = kCardBgColor;
  final Color primaryDarkColor = kPrimaryDarkColor;
  final Color headerTextColor = kHeaderTextColor;

  final double radius = 5.0;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(child: Text("USA"), value: "USA"),
    const DropdownMenuItem(child: Text("Canada"), value: "Canada"),
    const DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
    const DropdownMenuItem(child: Text("England"), value: "England"),
  ];
  String selectedValue = "USA";

  String activeSection = "history";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kHeaderBgColor,
        titleTextStyle: const TextStyle(
            color: kHeaderTextColor, fontFamily: 'RobotoLocal', fontSize: 18),
        title: const Text(kAppName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () {},
                  child: const FaIcon(
                    FontAwesomeIcons.cog,
                    color: kPrimaryColor,
                    size: 25,
                  )),
            ),
          )
        ],
      ),
      backgroundColor: kBodyBgColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SizedBox(
                width: double.maxFinite,
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kRadius),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        value: selectedValue,
                        style: const TextStyle(
                            fontFamily: 'RobotoLocal',
                            fontSize: 18,
                            color: kTextColor),
                        icon: const FaIcon(FontAwesomeIcons.caretDown,
                            color: kPrimaryColor, size: 30),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        items: menuItems,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 10),
                        buttonPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadius),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type here...'),
                          maxLines: 5,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                            child: GestureDetector(
                                onTap: () {},
                                child: const FaIcon(
                                  FontAwesomeIcons.eraser,
                                  color: kPrimaryColor,
                                  size: 27,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                            child: GestureDetector(
                                onTap: () {},
                                child: const FaIcon(
                                  FontAwesomeIcons.play,
                                  color: kPrimaryColor,
                                  size: 25,
                                )),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(kRadius)),
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: activeSection == 'history'
                                      ? kPrimaryDarkColor
                                      : kPrimaryColor,
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: widget.headerTextColor,
                                    textStyle: const TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      activeSection = 'history';
                                    });
                                  },
                                  child: const Text('History'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(kRadius)),
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: activeSection == 'saved'
                                      ? kPrimaryDarkColor
                                      : kPrimaryColor,
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: widget.headerTextColor,
                                    textStyle: const TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      activeSection = 'saved';
                                    });
                                  },
                                  child: const Text('Saved'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 100,
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
