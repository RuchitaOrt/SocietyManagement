
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/core/DocumentCategory/Presentation/Bloc/DocumentCategoryModel.dart';

// EVENTS

abstract class DocumentCategoryEvent {}

class DocumentCategoryCreated extends DocumentCategoryEvent {
  final DocumentCategoryModel category;

  DocumentCategoryCreated(this.category);
}

class DocumentCategoryDeleted extends DocumentCategoryEvent {
  final DocumentCategoryModel category;

  DocumentCategoryDeleted(this.category);
}

// STATE

class DocumentCategoryState {
  final List<DocumentCategoryModel> categories;

  const DocumentCategoryState({
    this.categories = const [],
  });

  int get totalCategories => categories.length;
}

// BLOC

class DocumentCategoryBloc
    extends Bloc<DocumentCategoryEvent, DocumentCategoryState> {

  DocumentCategoryBloc()
      : super(const DocumentCategoryState()) {

    on<DocumentCategoryCreated>((event, emit) {
      emit(
        DocumentCategoryState(
          categories: [
            ...state.categories,
            event.category,
          ],
        ),
      );
    });

    on<DocumentCategoryDeleted>((event, emit) {
      final updatedCategories = state.categories
          .where((item) => item != event.category)
          .toList();

      emit(
        DocumentCategoryState(
          categories: updatedCategories,
        ),
      );
    });
  }
}
