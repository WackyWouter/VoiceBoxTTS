import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voiceboxtts/constants.dart' as constants;
import 'package:voiceboxtts/models/fav_list_item.dart';
import 'package:voiceboxtts/screens/settings_screen.dart';
import 'package:voiceboxtts/widgets/custom_card.dart';
import 'package:voiceboxtts/widgets/custom_icon_btn.dart';
import 'package:voiceboxtts/widgets/section_btn.dart';
import 'package:voiceboxtts/widgets/show_divider.dart';

import '../ad_helper.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum TtsState { playing, stopped, paused, continued }

class _HomeScreenState extends State<HomeScreen> {
  // Obtain shared preferences.
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ///////////////////////// GOOGLE ADS ///////////////////////////////////
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _moveToSettings();
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  ////////////////////////// HISTORY/SAVED LISTS //////////////////////////////
  String activeSection = "history";
  List<FavListItem> historyList = [];
  List<FavListItem> savedList = [];
  final textFieldCont = TextEditingController();

  Future<void> _saveList(List<FavListItem> list, String listName) async {
    final SharedPreferences prefs = await _prefs;
    final String encodedList = FavListItem.encode(list);

    await prefs.setString(listName, encodedList);
  }

  void _getLists() async {
    final SharedPreferences prefs = await _prefs;
    final String historyJson = prefs.getString('historyJson') ?? '[]';
    historyList = FavListItem.decode(historyJson);

    final String savedJson = prefs.getString('savedJson') ?? '[]';
    savedList = FavListItem.decode(savedJson);
  }

  // Save the input as the new text
  void _onChange(String text) {
    setState(() {
      // Check if the text already exists in the history list
      List<FavListItem> oldItemsList =
          historyList.where((favListItem) => favListItem.text == text).toList();

      // Theoretically oldItemsList should never contain more then one item but if there is more than one, we only want the first
      if (oldItemsList.isNotEmpty) {
        for (var oldItem in oldItemsList) {
          historyList.remove(oldItem);
        }
        // Add it back into at the top
        historyList.insert(0, oldItemsList[0]);
      } else if (text != '' && _newVoiceText != text) {
        // Add it to the list at the top as a new FavListItem
        historyList.insert(0, FavListItem(text, false));
      }

      // Check if the list exceeds 30 with the new addition
      if (historyList.length > 5) {
        historyList.removeRange(5, historyList.length);
      }

      //Save the list
      _saveList(historyList, 'historyJson');

      // update the _newVoiceText if its not already set to that text
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
      bool oldFavouriteVal = item.isFavourite;
      // Toggle favourite on the current list item if clicked on star

      // Update the history list item as well since the items in both lists are not linked anymore after reading from sharedpreferences
      List<FavListItem> savedItemsList = savedList
          .where((favListItem) => favListItem.text == item.text)
          .toList();

      // Theoretically historyItemsList should never contain more then one item but can contain none
      if (savedItemsList.isNotEmpty) {
        for (var savedItem in savedItemsList) {
          savedItem.setFav(!oldFavouriteVal);

          // If saved item is set to un favourite now then remove it from the list
          if (!savedItem.isFavourite) {
            savedList.remove(savedItem);
          }
        }
      } else {
        // If the saved item list is empty that means that this is an addition to the save list so set it to favourite and add it to the saved list
        item.setFav(true);
        savedList.insert(0, item);
      }

      // Update the history list item as well since the items in both lists are not linked anymore after reading from sharedpreferences
      List<FavListItem> historyItemsList = historyList
          .where((favListItem) => favListItem.text == item.text)
          .toList();

      // Theoretically historyItemsList should never contain more then one item but can contain none
      if (historyItemsList.isNotEmpty) {
        for (var historyItem in historyItemsList) {
          historyItem.setFav(!oldFavouriteVal);
        }
      }

      _saveList(savedList, 'savedJson');
      _saveList(historyList, 'historyJson');
    });
  }

  ////////////////////////// FLUTTER TTS //////////////////////////////
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

  void _getSettings() async {
    final SharedPreferences prefs = await _prefs;
    volume = prefs.getDouble('volume') ?? 0.5;
    pitch = prefs.getDouble('pitch') ?? 1.0;
    rate = prefs.getDouble('rate') ?? 0.5;
  }

  void _saveSettings(double volume, double pitch, double rate) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setDouble('volume', volume);
    await prefs.setDouble('pitch', pitch);
    await prefs.setDouble('rate', rate);
  }

  void _moveToSettings() async {
    dynamic values = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          volume: volume,
          rate: rate,
          pitch: pitch,
          interstitialAd: _isInterstitialAdReady ? _interstitialAd : null,
          isInterstitialAdReady: _isInterstitialAdReady,
        ),
      ),
    );

    if (values != null) {
      setState(() {
        volume = values['volume'];
        rate = values['rate'];
        pitch = values['pitch'];
        _isInterstitialAdReady = values['isInterstitialAdReady'];
      });

      _saveSettings(values['volume'], values['rate'], values['pitch']);
    } else {
      setState(() {
        _isInterstitialAdReady = false;
      });
    }
    _loadInterstitialAd();
  }

  // Do initial setup
  initTts() {
    flutterTts = FlutterTts();

    // Set default language
    _changedLanguageDropDownItem(language);

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
  Future<bool> _changedLanguageDropDownItem(String? selectedType) async {
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

  ////////////////////////// ERROR POPUPS //////////////////////////////
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
                _changedLanguageDropDownItem('en-GB');
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

  //////////////////////////  STATE FUNCTIONS //////////////////////////////
  @override
  initState() {
    initTts();
    super.initState();
    _getLists();
    _getSettings();

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();

    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    textFieldCont.dispose();
    super.dispose();
    flutterTts.stop();
  }

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
                onTap: _moveToSettings,
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
                    bool success = await _changedLanguageDropDownItem(value);

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
                      maxLines: 9,
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: listShown.length,
                        itemBuilder: (BuildContext context, int index) {
                          //Determine which icon should be shown
                          IconData iconShown;
                          if (listShown[index].isFavourite) {
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
                width: 320,
                color: Colors.white,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    const Center(child: Text('Advertisement')),
                    if (_isBannerAdReady)
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: _bannerAd.size.width.toDouble(),
                          height: _bannerAd.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
