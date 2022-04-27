import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // Actual banner ad unit id
      // Failed to load a banner ad: Account not approved yet. <https://support.google.com/admob/answer/9905175#1>
      // return 'ca-app-pub-6529167501915416/8038981358';

      // Test banner ad unit id
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // static String get interstitialAdUnitId {
  //   if (Platform.isAndroid) {
  //     // Test banner ad unit id
  //     return "ca-app-pub-3940256099942544/1033173712";
  //   } else {
  //     throw UnsupportedError("Unsupported platform");
  //   }
  // }
  //
  // static String get rewardedAdUnitId {
  //   if (Platform.isAndroid) {
  //     // Test banner ad unit id
  //     return "ca-app-pub-3940256099942544/5224354917";
  //   } else {
  //     throw UnsupportedError("Unsupported platform");
  //   }
  // }
}
