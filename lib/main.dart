import 'package:flutter/material.dart';
import 'package:voiceboxtts/screens/home_screen.dart';

void main() {
  runApp(const VoiceBoxTTS());
}

class VoiceBoxTTS extends StatelessWidget {
  const VoiceBoxTTS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoiceBoxTTS',
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
      },
    );

  }
}
