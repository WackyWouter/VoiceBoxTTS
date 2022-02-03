import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voiceboxtts/constants.dart' as constants;
import 'package:voiceboxtts/widgets/custom_card.dart';
import 'package:voiceboxtts/widgets/custom_icon_btn.dart';
import 'package:voiceboxtts/widgets/custom_slider.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';

  double pitch;
  double rate;
  double volume;

  SettingsScreen({Key? key, this.pitch = 0, this.rate = 0, this.volume = 0})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 20,
        leadingWidth: 45,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Container(
            alignment: Alignment.center,
            child: CustomIconBtn(
              icon: FontAwesomeIcons.arrowLeft,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        backgroundColor: constants.headerBg,
        titleTextStyle: constants.headerStyle,
        title: const Text(constants.appName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              alignment: Alignment.center,
            ),
          )
        ],
      ),
      backgroundColor: constants.bodyBg,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CustomCard(
                  botPadding: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSlider(
                          value: widget.volume,
                          onChanged: (newVolume) {
                            setState(() {
                              widget.volume =
                                  double.parse(newVolume.toStringAsFixed(1));
                            });
                          },
                          label: "Volume",
                        ),
                        CustomSlider(
                          value: widget.pitch,
                          onChanged: (newPitch) {
                            setState(() {
                              widget.pitch =
                                  double.parse(newPitch.toStringAsFixed(1));
                            });
                          },
                          min: 0.5,
                          max: 2.0,
                          divisions: 15,
                          label: "Pitch",
                        ),
                        CustomSlider(
                          value: widget.rate,
                          onChanged: (newRate) {
                            setState(() {
                              widget.rate =
                                  double.parse(newRate.toStringAsFixed(1));
                            });
                          },
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: "Rate",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CustomIconBtn(
                                icon: FontAwesomeIcons.undo,
                                size: 22,
                                onTap: () {
                                  // reset back to default values
                                  setState(() {
                                    widget.volume = 0.5;
                                    widget.rate = 0.5;
                                    widget.pitch = 1.0;
                                  });
                                },
                              ),
                            ),
                            CustomIconBtn(
                              icon: FontAwesomeIcons.solidSave,
                              onTap: () {
                                // Send the changed values back
                                Navigator.pop(context, {
                                  'volume': widget.volume,
                                  'rate': widget.rate,
                                  'pitch': widget.pitch,
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    //  TODO add functionality to remove adds
                  },
                  child: const Text(
                    'Remove Adds',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    primary: constants.primary,
                    // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: constants.headerStyle,
                  ),
                ),
              ],
            ),
            CustomCard(
              botPadding: 10,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      'Made by Wouter Bosch',
                      style: constants.textStyle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Version: 1.0',
                      style: constants.textStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
