import 'package:flutter/material.dart';

// Colors
const Color headerBg = Color(0xFF2C2C2C);
const Color bodyBg = Color(0xFF3E3E3E);
const Color cardBg = Color(0xFFFFFFFF);
const Color primary = Color(0xFF9747FF);
const Color primaryDark = Color(0xFF612AA8);
const Color buttonText = Color(0xFFFFFFFF);
const Color divider = Color(0xFFE7E7E7);

// Strings
const String appName = 'VoiceBoxTTS';

// Integers, doubles and floats
const double borderRadius = 5.0;

// Text styles
const TextStyle textStyle = TextStyle(
  fontFamily: 'RobotoLocal',
  fontSize: 18,
  color: Color(0xFF000000),
);

const TextStyle headerStyle = TextStyle(
  fontFamily: 'RobotoLocal',
  fontSize: 18,
  color: Color(0xFFFFFFFF),
);

const TextStyle textButtonStyle = TextStyle(
  fontFamily: 'RobotoLocal',
  fontSize: 18,
  color: primary,
);

// Languages
List<DropdownMenuItem<String>> languageList = [
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
