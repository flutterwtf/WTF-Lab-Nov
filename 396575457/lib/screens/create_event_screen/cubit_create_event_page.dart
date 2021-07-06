import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../home_screen/event.dart';
import 'message.dart';
import 'states_event_page.dart';

class CubitCreateEventPage extends Cubit<StatesEventPage> {
  CubitCreateEventPage(state) : super(state);

  void init() {
    isWritingChange(false);
    setEditingPhoto(false);
    isFavoriteMessagesButtonEnableChange(false);
    isMessageSelectedSet(false);
    isEditing(false);
    isSearchButtonEnable(false);
    emit(state.copyWith(
        messagesList: state.event.messages, numberOfSelectedElements: 0));
  }

  void isWritingChange(bool isWriting) => emit(state.copyWith(
      isWriting: isWriting,
      indexOfSelectedCategoryIcon: state.indexOfSelectedCategoryIcon));

  void isEditing(bool isEditing) => emit(state.copyWith(isEditing: isEditing));

  void setEditingPhoto(bool isEditingPhoto) =>
      emit(state.copyWith(isEditingPhoto: isEditingPhoto));

  void sendMessage(
      TextEditingController textController, int indexOfCategoryIcon) {
    final message =
        Message(textController.text, indexOfCategoryIcon: indexOfCategoryIcon);

    if (state.isEditing) {
      var index = state.messagesList.indexOf(state.selectedMessage);
      state.messagesList[index].sendNewMessage = textController.text;
      state.messagesList[index].setIndexOfCategoryCircleAvatar = indexOfCategoryIcon;
      emit(state.copyWith(messagesList: state.messagesList, isEditing: false));
      isWritingChange(false);
      textController.clear();
    } else {
      state.messagesList.insert(0, message);
      emit(state.copyWith(messagesList: state.messagesList));
      isWritingChange(false);
      textController.clear();
    }
  }

  List<Event> transferMessage(Message selectedMessage, List<Event> eventList) {
    eventList[state.indexOfSelectedElement]
        .newMessageAdd(selectedMessage.message);
    return eventList;
  }

  void addImageEvent(PickedFile image) {
    final newMessage = Message('', imagePath: image.path);
    state.messagesList.insert(0, newMessage);
    emit(state.copyWith(messagesList: state.messagesList));
    isWritingChange(false);
    setEditingPhoto(false);
  }

  void isSearchButtonEnable(bool isSearch) =>
      emit(state.copyWith(isSearchButtonEnable: isSearch));

  void clearCounterOfSelectedElements() =>
      emit(state.copyWith(numberOfSelectedElements: 0));

  void incrementNumberOfSelectedElements() {
    var currentNumberOfSelectedElements = state.numberOfSelectedElements;
    currentNumberOfSelectedElements++;
    emit(state.copyWith(
        numberOfSelectedElements: currentNumberOfSelectedElements));
  }

  void decrementNumberOfSelectedElements() {
    var currentNumberOfSelectedElements = state.numberOfSelectedElements;
    currentNumberOfSelectedElements--;
    emit(state.copyWith(
        numberOfSelectedElements: currentNumberOfSelectedElements));
  }

  void deleteMessage(Message message) {
    state.messagesList.remove(message);
    emit(state.copyWith(messagesList: state.messagesList));
  }

  void deleteMessageByIndex(int index) {
    state.messagesList.removeAt(index);
    emit(state.copyWith(messagesList: state.messagesList));
  }

  void isMessageSelectedSet(bool isMessageSelected) =>
      emit(state.copyWith(isMessageSelected: isMessageSelected));

  void selectedMessageSet(Message selectedMessage) =>
      emit(state.copyWith(selectedMessage: selectedMessage));

  void editMessage(
      TextEditingController textController, Message editedMessage) {
    textController.text = editedMessage.message;
    setIndexOfSelectedCategoryIcon(editedMessage.indexOfCategoryIcon);
    isWritingChange(true);
  }

  void setIndexOfSelectedElement(int indexOfSelectedElement) =>
      emit(state.copyWith(indexOfSelectedElement: indexOfSelectedElement));

  void isFavoriteMessagesButtonEnableChange(bool isFavoriteButtonEnable) =>
      emit(state.copyWith(
          isFavoriteMessageButtonEnable: isFavoriteButtonEnable));

  void setIndexOfSelectedCategoryIcon(int index) =>
      emit(state.copyWith(indexOfSelectedCategoryIcon: index));

  void clearChosenCategoryButtonIcon() {
    int indexOfSelectedCategoryIcon;
    emit(state.copyWith(
        indexOfSelectedCategoryIcon: indexOfSelectedCategoryIcon));
  }

  void setMessagesList(List<Message> messagesList) =>
      emit(state.copyWith(messagesList: messagesList));

  void undoDeleteMessage(Message message, int index) {
    state.messagesList.insert(index, message);
    emit(state.copyWith(messagesList: state.messagesList));
  }

  void isFavoriteMessagesButtonEnableInverse() => emit(state.copyWith(
      isFavoriteMessageButtonEnable: !state.isFavoriteMessageButtonEnable));
}
