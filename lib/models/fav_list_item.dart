import 'dart:convert';

class FavListItem {
  final String text;
  bool isFavourite = false;

  FavListItem(this.text, this.isFavourite);

  factory FavListItem.fromJson(Map<String, dynamic> jsonData) {
    return FavListItem(jsonData['text'], jsonData['isFavourite']);
  }

  static Map<String, dynamic> toMap(FavListItem favListItem) =>
      {'text': favListItem.text, 'isFavourite': favListItem.isFavourite};

  static String encode(List<FavListItem> favListItem) => json.encode(
        favListItem
            .map<Map<String, dynamic>>(
                (favListItem) => FavListItem.toMap(favListItem))
            .toList(),
      );

  static List<FavListItem> decode(String favListItem) =>
      (json.decode(favListItem) as List<dynamic>)
          .map<FavListItem>((item) => FavListItem.fromJson(item))
          .toList();

  void setFav(bool favourite) {
    isFavourite = favourite;
  }
}
