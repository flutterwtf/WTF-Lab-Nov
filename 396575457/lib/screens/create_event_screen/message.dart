class Message {
  String _message;
  String imagePath;

  bool _isSelected = false;
  bool _isEdited = false;
  bool _isFavorite = false;
  int indexOfCategoryIcon;

  Message(this._message, {this.indexOfCategoryIcon, this.imagePath});

  String get message {
    return _message;
  }

  int get indexOfCategoryCircleAvatar {
    return indexOfCategoryIcon;
  }

  bool get isMessageFavorite {
    return _isFavorite;
  }

  bool get isMessageEdit {
    return _isEdited;
  }

  bool get isMessageSelected {
    return _isSelected;
  }

  set setIndexOfCategoryCircleAvatar(int index) => indexOfCategoryIcon = index;

  set sendNewMessage(String message) => _message = message;

  set favoriteMessage(bool favorite) => _isFavorite = favorite;

  set selectMessage(bool select) => _isSelected = select;

  set editMessage(bool edit) => _isEdited = edit;

  void inverseChosen() => _isFavorite = !_isFavorite;

  void inverseSelected() => _isSelected = !_isSelected;
}
