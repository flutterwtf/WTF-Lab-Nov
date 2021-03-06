import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/constants/constants.dart';
import '../data/model/search_item_data.dart';
import '../data/repository/category_repository.dart';
import '../data/repository/messages_repository.dart';
import '../data/repository/pages_repository.dart';

part 'filter_screen_state.dart';

class FilterScreenCubit extends Cubit<FilterScreenState> {
  final CategoryRepository categoryRepository;
  final MessagesRepository messagesRepository;
  final PagesRepository pagesRepository;

  FilterScreenCubit({
    this.pagesRepository,
    this.messagesRepository,
    this.categoryRepository,
  }) : super(
          FilterScreenState(
            modeFilter: ModeFilter.wait,
            modeFilterScreen: ModeFilterScreen.timelineFilter,
            pages: <SearchItemData>[],
            tags: <SearchItemData>[],
            labels: <SearchItemData>[],
          ),
        );

  void updatePages() async {
    final pages = await pagesRepository.pages();
    emit(
      state.copyWith(
        pages: List.generate(
          pages.length,
          (index) => SearchItemData(
            id: pages[index].id,
            indexIcon: pages[index].iconIndex,
            name: pages[index].title,
            isSelected: false,
          ),
        ),
        modeFilter: ModeFilter.complete,
        modeFilterScreen: ModeFilterScreen.statisticFilter,
      ),
    );
  }

  void updateDate() async {
    final pages = await pagesRepository.pages();
    final tags = await messagesRepository.tags();
    final labels = categoryRepository.categories;
    emit(
      state.copyWith(
        pages: List.generate(
          pages.length,
          (index) => SearchItemData(
            id: pages[index].id,
            indexIcon: pages[index].iconIndex,
            name: pages[index].title,
            isSelected: false,
          ),
        ),
        tags: List.generate(
          tags.length,
          (index) => SearchItemData(
            id: tags[index].id,
            indexIcon: -1,
            name: tags[index].name,
            isSelected: false,
          ),
        ),
        labels: List.generate(
          labels.length,
          (index) => SearchItemData(
            id: index,
            indexIcon: index,
            name: labels[index].label,
            isSelected: false,
          ),
        ),
        modeFilter: ModeFilter.complete,
        modeFilterScreen: ModeFilterScreen.timelineFilter,
      ),
    );
  }

  bool isSelectedItem(TypeTab typeTab) {
    switch (typeTab) {
      case TypeTab.pages:
        return state.pages
            .where((element) => element.isSelected)
            .toList()
            .isNotEmpty;
      case TypeTab.tags:
        return state.tags
            .where((element) => element.isSelected)
            .toList()
            .isNotEmpty;
      case TypeTab.labels:
        return state.labels
            .where((element) => element.isSelected)
            .toList()
            .isNotEmpty;
      case TypeTab.other:
        return false;
      default:
        assert(false, 'Need to implement $typeTab');
        return false;
    }
  }

  void selectedItem(TypeTab typeTab, int index) {
    switch (typeTab) {
      case TypeTab.pages:
        emit(
          state.copyWith(
            pages: List.generate(
              state.pages.length,
              (i) => SearchItemData(
                id: state.pages[i].id,
                name: state.pages[i].name,
                indexIcon: state.pages[i].indexIcon,
                isSelected: i == index
                    ? !state.pages[i].isSelected
                    : state.pages[i].isSelected,
              ),
            ),
          ),
        );
        break;
      case TypeTab.tags:
        emit(
          state.copyWith(
            tags: List.generate(
              state.tags.length,
              (i) => SearchItemData(
                id: state.tags[i].id,
                name: state.tags[i].name,
                indexIcon: state.tags[i].indexIcon,
                isSelected: i == index
                    ? !state.tags[i].isSelected
                    : state.tags[i].isSelected,
              ),
            ),
          ),
        );
        break;
      case TypeTab.labels:
        emit(
          state.copyWith(
            labels: List.generate(
              state.labels.length,
              (i) => SearchItemData(
                id: state.labels[i].id,
                name: state.labels[i].name,
                indexIcon: state.labels[i].indexIcon,
                isSelected: i == index
                    ? !state.labels[i].isSelected
                    : state.labels[i].isSelected,
              ),
            ),
          ),
        );
        break;
      case TypeTab.other:
        break;
    }
  }
}
