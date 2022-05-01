import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // Actual banner ad unit id
      return 'ca-app-pub-6529167501915416/8038981358';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // Actual interstitial ad unit id
      return 'ca-app-pub-6529167501915416/4791809408';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
  //
  // static String get rewardedAdUnitId {
  //   if (Platform.isAndroid) {
  //     // Test rewarded ad unit id
  //     return "ca-app-pub-3940256099942544/5224354917";
  //   } else {
  //     throw UnsupportedError("Unsupported platform");
  //   }
  // }
}
