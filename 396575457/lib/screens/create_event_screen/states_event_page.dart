import '../home_screen/event.dart';
import 'message.dart';

class StatesEventPage {
  final Event event;
  int numberOfSelectedElements;
  final bool isMessageSelected;
  List<Message> messagesList;
  Message selectedMessage;
  bool isSearchButtonEnable;
  bool isFavoriteMessageButtonEnable;
  bool isEditing;
  bool isWriting;
  int indexOfSelectedElement;
  final int indexOfSelectedCategoryIcon;
  bool isEditingPhoto;

  StatesEventPage({
    this.event,
    this.isMessageSelected,
    this.messagesList,
    this.selectedMessage,
    this.isWriting,
    this.indexOfSelectedElement,
    this.isFavoriteMessageButtonEnable,
    this.isEditing,
    this.indexOfSelectedCategoryIcon,
    this.numberOfSelectedElements,
    this.isSearchButtonEnable,
    this.isEditingPhoto,
  });

  StatesEventPage copyWith({
    Event event,
    bool isMessageSelected,
    List<Message> messagesList,
    Message selectedMessage,
    bool isWriting,
    int indexOfSelectedElement,
    bool isFavoriteMessageButtonEnable,
    bool isEditing,
    int indexOfSelectedCategoryIcon,
    int numberOfSelectedElements,
    bool isSearchButtonEnable,
    bool isEditingPhoto,
  }) {
    return StatesEventPage(
      event: event ?? this.event,
      isMessageSelected: isMessageSelected ?? this.isMessageSelected,
      messagesList: messagesList ?? this.messagesList,
      selectedMessage: selectedMessage ?? this.selectedMessage,
      isWriting: isWriting ?? this.isWriting,
      indexOfSelectedElement:
          indexOfSelectedElement ?? this.indexOfSelectedElement,
      isFavoriteMessageButtonEnable:
          isFavoriteMessageButtonEnable ?? this.isFavoriteMessageButtonEnable,
      isEditing: isEditing ?? this.isEditing,
      indexOfSelectedCategoryIcon: indexOfSelectedCategoryIcon,
      numberOfSelectedElements:
          numberOfSelectedElements ?? this.numberOfSelectedElements,
      isSearchButtonEnable: isSearchButtonEnable ?? this.isSearchButtonEnable,
      isEditingPhoto: isEditingPhoto ?? this.isEditingPhoto,
    );
  }
}
