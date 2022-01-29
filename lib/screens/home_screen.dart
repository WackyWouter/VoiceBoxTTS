import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voiceboxtts/constants.dart' as constants;
import 'package:voiceboxtts/models/fav_list_item.dart';
import 'package:voiceboxtts/widgets/custom_card.dart';
import 'package:voiceboxtts/widgets/custom_icon_btn.dart';
import 'package:voiceboxtts/widgets/section_btn.dart';
import 'package:voiceboxtts/widgets/show_divider.dart';

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

  ////////////////////////// START HISTORY/SAVED LISTS //////////////////////////////
  String activeSection = "history";
  List<FavListItem> historyList = [];
  List<FavListItem> savedList = [];
  final textFieldCont = TextEditingController();

  // Save the input as the new text
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

  // clear input and text
  void _clearText() {
    textFieldCont.text = '';
    _onChange('');
  }

  // Toggle between sections
  void _changeActiveSection(String section) {
    setState(() {
      activeSection = section;
    });
  }

  // set or unset text as favourite
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
  ////////////////////////// END HISTORY/SAVED LISTS //////////////////////////////

  ////////////////////////// START FLUTTER TTS //////////////////////////////
  // Declare variables
  late FlutterTts flutterTts;
  String? language = 'en-GB';
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? _newVoiceText;

  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  // Do initial setup
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

  // Speak or stop speaking based on current tts state.
  Future _speakOrStop() async {
    //tell the user to type something first if the input is empty
    if (textFieldCont.text != '') {
      _onChange(textFieldCont.text);

      if (ttsState == TtsState.stopped) {
        await flutterTts.setVolume(volume);
        await flutterTts.setSpeechRate(rate);
        await flutterTts.setPitch(pitch);

        // Check that text is not null
        if (_newVoiceText != null) {
          if (_newVoiceText!.isNotEmpty) {
            await flutterTts.speak(_newVoiceText!);
          }
        }
      } else {
        var result = await flutterTts.stop();
        if (result == 1) setState(() => ttsState = TtsState.stopped);
      }
    } else {
      // Show Snackbar to tell that you need to type something first
      final SnackBar snackBar = _createSnackBar();
      // first try to hide one in case the previous one is still open
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Update the selected language
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
  ////////////////////////// END FLUTTER TTS //////////////////////////////

  ////////////////////////// START ERROR POPUPS //////////////////////////////
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: constants.textStyle,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('The current Language is not supported.',
                    style: constants.textStyle),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Change Language',
                style: constants.textButtonStyle,
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

  SnackBar _createSnackBar() {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: const Text(
        'Please enter text into the text field first.',
        style: constants.textStyle,
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
  ////////////////////////// END ERROR POPUPS //////////////////////////////

  ////////////////////////// START STATE FUNCTIONS //////////////////////////////
  @override
  initState() {
    initTts();
    super.initState();
  }

  @override
  void dispose() {
    textFieldCont.dispose();
    super.dispose();
    flutterTts.stop();
  }
  ////////////////////////// END STATE FUNCTIONS //////////////////////////////

  @override
  Widget build(BuildContext context) {
    List<FavListItem> listShown =
        activeSection == 'history' ? historyList : savedList;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: constants.headerBg,
        titleTextStyle: constants.headerStyle,
        title: const Text(constants.appName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              alignment: Alignment.center,
              child: CustomIconBtn(
                icon: FontAwesomeIcons.cog,
                onTap: () {},
              ),
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
            CustomCard(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  dropdownOverButton: false,
                  value: language,
                  style: constants.textStyle,
                  icon: const FaIcon(FontAwesomeIcons.caretDown,
                      color: constants.primary, size: 30),
                  onChanged: (String? value) async {
                    bool success = await changedLanguageDropDownItem(value);

                    //If it failed show dialog that language is not supported
                    if (!success) {
                      _showDialog();
                    }
                  },
                  items: constants.languageList,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 10),
                  buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            CustomCard(
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
                          border: InputBorder.none, hintText: 'Type here...'),
                      maxLines: 10,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                          child: CustomIconBtn(
                              icon: FontAwesomeIcons.eraser,
                              onTap: _clearText,
                              size: 27)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                        child: CustomIconBtn(
                          icon: FontAwesomeIcons.play,
                          onTap: _speakOrStop,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: CustomCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionBtn(
                            name: 'History',
                            activeSection: activeSection == 'history',
                            onPressed: () {
                              _changeActiveSection('history');
                            }),
                        SectionBtn(
                            name: 'Saved',
                            activeSection: activeSection == 'saved',
                            onPressed: () {
                              _changeActiveSection('saved');
                            }),
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
                            onTap: () {
                              textFieldCont.text = listShown[index].text;
                            },
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
                                          style: constants.textStyle,
                                        ),
                                      ),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: CustomIconBtn(
                                            icon: iconShown,
                                            onTap: () {
                                              _toggleFavourite(
                                                  listShown[index]);
                                            },
                                            size: 30,
                                          )),
                                    ],
                                  ),
                                ),
                                // showDivider(index, listShown.length)
                                ShowDivider(
                                    show: index != (listShown.length - 1))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
}
