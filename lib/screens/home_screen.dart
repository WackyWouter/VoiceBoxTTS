import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voiceboxtts/constants.dart' as constants;
import 'package:voiceboxtts/models/fav_list_item.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  final double radius = 5.0;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum TtsState { playing, stopped, paused, continued }

class _HomeScreenState extends State<HomeScreen> {
  // TODO make the list be remembered between app startups
  // https://stackoverflow.com/questions/61316208/how-to-save-listobject-to-sharedpreferences-in-flutter
  // https://stackoverflow.com/questions/63280237/flutter-how-to-save-list-data-locally

  // TODO add settings for changing pitch, rate and volume

  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(child: Text("Albanian"), value: "sq"),
    const DropdownMenuItem(child: Text("Catalan"), value: "ca"),
    const DropdownMenuItem(child: Text("Chinese (PRC)"), value: "zh-CN"),
    const DropdownMenuItem(child: Text("Chinese (Taiwan)"), value: "zh-TW"),
    const DropdownMenuItem(child: Text("Croatian"), value: "hr"),
    const DropdownMenuItem(child: Text("Czech"), value: "cs-CZ"),
    const DropdownMenuItem(child: Text("Danish"), value: "da-DK"),
    const DropdownMenuItem(child: Text("Dutch"), value: "nl-NL"),
    const DropdownMenuItem(child: Text("English (Australia)"), value: "en-AU"),
    const DropdownMenuItem(
        child: Text("English (United Kingdom)"), value: "en-GB"),
    const DropdownMenuItem(
        child: Text("English (United States)"), value: "en-US"),
    const DropdownMenuItem(child: Text("Estonian"), value: "et-EE"),
    const DropdownMenuItem(child: Text("Filipino"), value: "fil-PH"),
    const DropdownMenuItem(child: Text("Finnish"), value: "fi-FI"),
    const DropdownMenuItem(child: Text("French (Canada)"), value: "fr-CA"),
    const DropdownMenuItem(child: Text("French (France)"), value: "fr-FR"),
    const DropdownMenuItem(child: Text("German"), value: "de-DE"),
    const DropdownMenuItem(child: Text("Greek"), value: "el-GR"),
    const DropdownMenuItem(child: Text("Hindi"), value: "hi-IN"),
    const DropdownMenuItem(child: Text("Hungarian"), value: "hu-HU"),
    const DropdownMenuItem(child: Text("Indonesian"), value: "id-ID"),
    const DropdownMenuItem(child: Text("Italian"), value: "it-IT"),
    const DropdownMenuItem(child: Text("Japanese"), value: "ja-JP"),
    const DropdownMenuItem(child: Text("Korean"), value: "ko-KR"),
    const DropdownMenuItem(child: Text("Norwegian"), value: "nb-NO"),
    const DropdownMenuItem(child: Text("Polish"), value: "pl-PL"),
    const DropdownMenuItem(child: Text("Portuguese (Brazil)"), value: "pt-BR"),
    const DropdownMenuItem(child: Text("Romanian"), value: "ro-RO"),
    const DropdownMenuItem(child: Text("Russian"), value: "ru-RU"),
    const DropdownMenuItem(child: Text("Slovak"), value: "sk"),
    const DropdownMenuItem(child: Text("Slovak (Slovakia)"), value: "sk-SK"),
    const DropdownMenuItem(child: Text("Spanish (Spain)"), value: "es-ES"),
    const DropdownMenuItem(
        child: Text("Spanish (United States)"), value: "es-US"),
    const DropdownMenuItem(child: Text("Swahili"), value: "sw"),
    const DropdownMenuItem(child: Text("Swedish"), value: "sv-SE"),
    const DropdownMenuItem(child: Text("Tamil"), value: "ta"),
    const DropdownMenuItem(child: Text("Thai"), value: "th-TH"),
    const DropdownMenuItem(child: Text("Turkish"), value: "tr-TR"),
    const DropdownMenuItem(child: Text("Ukrainian"), value: "Ukraine"),
    const DropdownMenuItem(child: Text("Vietnamese"), value: "vi-VN"),
    const DropdownMenuItem(child: Text("Welsh"), value: "cy"),
    const DropdownMenuItem(
        child: Text("Yue Chinese (Hong Kong)"), value: "yue-HK"),
  ];

  String activeSection = "history";
  List<FavListItem> historyList = [];
  List<FavListItem> savedList = [];
  final textFieldCont = TextEditingController();

  late FlutterTts flutterTts;
  String? language = 'en-GB';
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  String? _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  @override
  initState() {
    initTts();
    super.initState();
  }

  //TODO make a class for this
  initTts() {
    flutterTts = FlutterTts();

    // Set default language
    changedLanguageDropDownItem(language);

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        debugPrint("error: $msg ");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    textFieldCont.dispose();
    super.dispose();
    flutterTts.stop();
  }

  Future<bool> changedLanguageDropDownItem(String? selectedType) async {
    bool isLanguageSupported =
        await flutterTts.isLanguageAvailable(selectedType!);

    if (isLanguageSupported) {
      setState(() {
        language = selectedType;
        flutterTts.setLanguage(language!);
      });
      return true;
    } else {
      return false;
    }
  }

  void _onChange(String text) {
    setState(() {
      // if text is not being cleared add it to history list
      if (text != '' && _newVoiceText != text) {
        historyList.insert(0, FavListItem(text, false));
      }

      if (_newVoiceText != text) {
        _newVoiceText = text;
      }
    });
  }

  void _clearText() {
    textFieldCont.text = '';
    _onChange('');
  }

  void _speakOrStop() {
    //tell the user to type something first if the input is empty
    if (textFieldCont.text != '') {
      _onChange(textFieldCont.text);

      if (ttsState == TtsState.stopped) {
        _speak();
      } else {
        _stop();
      }
    } else {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: const Text('Please enter text into the textfield first.'),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      // first try to hide one in case the previous one is still open
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _changeActiveSection(String section) {
    setState(() {
      activeSection = section;
    });
  }

  void _toggleFavourite(FavListItem item) {
    setState(() {
      // Toggle favourite on the current list item if clicked on star
      item.toggleFav();

      // if it is being favoured add to saved list otherwise remove from saved list
      if (item.isFavorite) {
        savedList.insert(0, item);
      } else {
        savedList.remove(item);
      }
    });
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('The current Language is not supported.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Change Language',
                style: TextStyle(color: constants.primary),
              ),
              onPressed: () {
                changedLanguageDropDownItem('en-GB');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<FavListItem> listShown =
        activeSection == 'history' ? historyList : savedList;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: constants.headerBg,
        titleTextStyle: const TextStyle(
            color: constants.headerText,
            fontFamily: 'RobotoLocal',
            fontSize: 18),
        title: const Text(constants.appName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () {},
                  child: const FaIcon(
                    FontAwesomeIcons.cog,
                    color: constants.primary,
                    size: 25,
                  )),
            ),
          )
        ],
      ),
      backgroundColor: constants.bodyBg,
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
                    borderRadius: BorderRadius.circular(constants.borderRadius),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      dropdownOverButton: false,
                      value: language,
                      style: const TextStyle(
                          fontFamily: 'RobotoLocal',
                          fontSize: 18,
                          color: constants.text),
                      icon: const FaIcon(FontAwesomeIcons.caretDown,
                          color: constants.primary, size: 30),
                      onChanged: (String? value) async {
                        bool success = await changedLanguageDropDownItem(value);

                        //If it failed show dialog that language is not supported
                        if (true) {
                          _showDialog();
                        }
                      },
                      items: menuItems,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 10),
                      buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(constants.borderRadius),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1000),
                          ],
                          controller: textFieldCont,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type here...'),
                          maxLines: 10,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                            child: GestureDetector(
                                onTap: _clearText,
                                child: const FaIcon(
                                  FontAwesomeIcons.eraser,
                                  color: constants.primary,
                                  size: 27,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                            child: GestureDetector(
                                onTap: _speakOrStop,
                                child: const FaIcon(
                                  FontAwesomeIcons.play,
                                  color: constants.primary,
                                  size: 25,
                                )),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(constants.borderRadius),
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
                                    topLeft: Radius.circular(
                                        constants.borderRadius)),
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: activeSection == 'history'
                                        ? constants.primaryDark
                                        : constants.primary,
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      primary: constants.buttonText,
                                      textStyle: const TextStyle(fontSize: 18),
                                    ),
                                    onPressed: () {
                                      _changeActiveSection('history');
                                    },
                                    child: const Text('History'),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(
                                        constants.borderRadius)),
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: activeSection == 'saved'
                                        ? constants.primaryDark
                                        : constants.primary,
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      primary: constants.buttonText,
                                      textStyle: const TextStyle(fontSize: 18),
                                    ),
                                    onPressed: () {
                                      _changeActiveSection('saved');
                                    },
                                    child: const Text('Saved'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // https://stackoverflow.com/questions/49927200/how-do-i-create-a-list-view-of-buttons-in-flutter/53775014
                        Expanded(
                          child: ListView.builder(
                            itemCount: listShown.length,
                            itemBuilder: (BuildContext context, int index) {
                              //Determine which icon should be shown
                              IconData iconShown;
                              if (listShown[index].isFavorite) {
                                iconShown = FontAwesomeIcons.solidStar;
                              } else {
                                iconShown = FontAwesomeIcons.star;
                              }

                              return GestureDetector(
                                onTap: () {},
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              listShown[index].text,
                                              textAlign: TextAlign.left,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _toggleFavourite(
                                                  listShown[index]);
                                            },
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: FaIcon(
                                                  iconShown,
                                                  color: constants.primary,
                                                  size: 30.0,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    showDivider(index, listShown.length)
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 50,
                width: double.maxFinite,
                color: Colors.white,
                alignment: Alignment.center,
                child: const Text('Advertisement'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showDivider(int index, int listLength) {
    if (index != (listLength - 1)) {
      return const Divider(
        thickness: 1.5,
        color: constants.divider,
        height: 1.5,
      );
    } else {
      return const SizedBox();
    }
  }
}
