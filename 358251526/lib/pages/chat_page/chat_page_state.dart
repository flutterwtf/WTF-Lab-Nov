part of 'chat_page_cubit.dart';

class ChatPageState {
  final List<Category> categotiesList;
  final Category category;
  final bool eventSelected;
  final bool isEditing;
  final bool isSending;
  final int indexOfSelectedEvent;

  ChatPageState({
    required this.isSending,
    required this.categotiesList,
    required this.isEditing,
    required this.category,
    required this.eventSelected,
    required this.indexOfSelectedEvent,
  });

  ChatPageState copyWith({
    final bool? isSending,
    final List<Category>? categoriesList,
    final Category? category,
    final bool? eventSelected,
    final bool? isEditing,
    final int? indexOfSelectedEvent,
  }) {
    return ChatPageState(
      isSending: isSending?? this.isSending,
      categotiesList: categotiesList,
      isEditing: isEditing ?? this.isEditing,
      category: category ?? this.category,
      eventSelected: eventSelected ?? this.eventSelected,
      indexOfSelectedEvent: indexOfSelectedEvent ?? this.indexOfSelectedEvent,
    );
  }
}
