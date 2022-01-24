class FavListItem {
  final String text;
  bool isFavorite = false;

  FavListItem(this.text, this.isFavorite);

  void toggleFav() {
    isFavorite = !isFavorite;
  }
}
