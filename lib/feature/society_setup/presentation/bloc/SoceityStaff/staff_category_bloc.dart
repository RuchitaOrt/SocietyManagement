import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/staff_category_model.dart';



class StaffCategoryRepository {
  static const String _storageKey = 'society_staff_categories';

  static const List<StaffCategoryModel> defaultCategories = [
    StaffCategoryModel(
      id: '1',
      name: 'Security Guard',
      description: 'Society security staff',
    ),
    StaffCategoryModel(
      id: '2',
      name: 'Housekeeping',
      description: 'Cleaning and housekeeping staff',
    ),
    StaffCategoryModel(
      id: '3',
      name: 'Electrician',
      description: 'Electrical maintenance',
    ),
    StaffCategoryModel(
      id: '4',
      name: 'Plumber',
      description: 'Plumbing maintenance',
    ),

  ];

Future<List<StaffCategoryModel>> loadCategories() async {
  final prefs = await SharedPreferences.getInstance();
  final savedData = prefs.getString(_storageKey);

  if (savedData == null || savedData.isEmpty) {
    return [];
  }

  try {
    final decoded = jsonDecode(savedData) as List;

    return decoded
        .map(
          (item) => StaffCategoryModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  } catch (_) {
    return [];
  }
}
  Future<void> saveCategories(
    List<StaffCategoryModel> categories,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      categories.map((category) => category.toJson()).toList(),
    );

    await prefs.setString(_storageKey, encoded);
  }
}

// EVENTS

abstract class StaffCategoryEvent {}

class LoadStaffCategoriesEvent extends StaffCategoryEvent {}

class AddStaffCategoryEvent extends StaffCategoryEvent {
  final StaffCategoryModel category;

  AddStaffCategoryEvent(this.category);
}

class UpdateStaffCategoryEvent extends StaffCategoryEvent {
  final StaffCategoryModel category;

  UpdateStaffCategoryEvent(this.category);
}

class DeleteStaffCategoryEvent extends StaffCategoryEvent {
  final String id;

  DeleteStaffCategoryEvent(this.id);
}

// STATE

class StaffCategoryState {
  final List<StaffCategoryModel> categories;
  final bool isLoading;

  const StaffCategoryState({
    this.categories = const [],
    this.isLoading = false,
  });

  StaffCategoryState copyWith({
    List<StaffCategoryModel>? categories,
    bool? isLoading,
  }) {
    return StaffCategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// BLOC

class StaffCategoryBloc
    extends Bloc<StaffCategoryEvent, StaffCategoryState> {
  final StaffCategoryRepository repository;

  StaffCategoryBloc({
    StaffCategoryRepository? repository,
  })  : repository = repository ?? StaffCategoryRepository(),
        super(
          const StaffCategoryState(
            isLoading: true,
          ),
        ) {
    on<LoadStaffCategoriesEvent>(_loadCategories);
    on<AddStaffCategoryEvent>(_addCategory);
    on<UpdateStaffCategoryEvent>(_updateCategory);
    on<DeleteStaffCategoryEvent>(_deleteCategory);

    add(LoadStaffCategoriesEvent());
  }

  Future<void> _loadCategories(
    LoadStaffCategoriesEvent event,
    Emitter<StaffCategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final categories = await repository.loadCategories();

    emit(
      state.copyWith(
        categories: categories,
        isLoading: false,
      ),
    );
  }

  Future<void> _addCategory(
    AddStaffCategoryEvent event,
    Emitter<StaffCategoryState> emit,
  ) async {
    final name = event.category.name.trim();

    final alreadyExists = state.categories.any(
      (category) =>
          category.name.toLowerCase() == name.toLowerCase(),
    );

    if (alreadyExists) return;

    final updated = [
      ...state.categories,
      event.category.copyWith(name: name),
    ];

    await repository.saveCategories(updated);

    emit(state.copyWith(categories: updated));
  }

  Future<void> _updateCategory(
    UpdateStaffCategoryEvent event,
    Emitter<StaffCategoryState> emit,
  ) async {
    final name = event.category.name.trim();

    final alreadyExists = state.categories.any(
      (category) =>
          category.id != event.category.id &&
          category.name.toLowerCase() == name.toLowerCase(),
    );

    if (alreadyExists) return;

    final updated = state.categories.map((category) {
      return category.id == event.category.id
          ? event.category.copyWith(name: name)
          : category;
    }).toList();

    await repository.saveCategories(updated);

    emit(state.copyWith(categories: updated));
  }

  Future<void> _deleteCategory(
    DeleteStaffCategoryEvent event,
    Emitter<StaffCategoryState> emit,
  ) async {
    final updated = state.categories
        .where((category) => category.id != event.id)
        .toList();

    await repository.saveCategories(updated);

    emit(state.copyWith(categories: updated));
  }
}