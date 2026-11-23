
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/SoceityStaff/staff_category_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/staff_category_model.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

Future<void> showAddStaffCategoryBottomSheet({
  required BuildContext context,
}) {
  final categoryBloc = context.read<StaffCategoryBloc>();

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: categoryBloc,
      child: const AddStaffCategoryBottomSheet(),
    ),
  );
}

class AddStaffCategoryBottomSheet extends StatefulWidget {
  final List<String> existingCategories;

  const AddStaffCategoryBottomSheet({
    super.key,
    this.existingCategories = const [],
  });

  @override
  State<AddStaffCategoryBottomSheet> createState() =>
      _AddStaffCategoryBottomSheetState();
}

class _AddStaffCategoryBottomSheetState
    extends State<AddStaffCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  // late List<String> _categories;

  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    // _categories = List<String>.from(widget.existingCategories);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
void _saveCategory() {
  if (!_formKey.currentState!.validate()) return;

  final name = _categoryController.text.trim();

  final bloc = context.read<StaffCategoryBloc>();

  final exists = bloc.state.categories.any(
    (category) =>
        category.name.toLowerCase() == name.toLowerCase(),
  );

  if (exists) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Category already exists'),
      ),
    );
    return;
  }

  bloc.add(
    AddStaffCategoryEvent(
      StaffCategoryModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        description: _descriptionController.text.trim(),
      ),
    ),
  );

  _categoryController.clear();
  _descriptionController.clear();

  FocusScope.of(context).unfocus();
}
 

void _updateCategory() {
  if (!_formKey.currentState!.validate()) return;

  if (_editingIndex == null) return;

  final bloc = context.read<StaffCategoryBloc>();
  final existingCategory = bloc.state.categories[_editingIndex!];

  final updatedCategory = StaffCategoryModel(
    id: existingCategory.id,
    name: _categoryController.text.trim(),
    description: _descriptionController.text.trim(),
  );

  bloc.add(UpdateStaffCategoryEvent(updatedCategory));

  setState(() {
    _editingIndex = null;
    _categoryController.clear();
    _descriptionController.clear();
  });
}

  Widget _categoryField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool requiredField = false,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF44516A),
            ),
            if (requiredField)
              const CommonText(
                text: ' *',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _primaryColor,
              ),
          ],
        ),
        const SizedBox(height: 8),

        if (maxLines == 1)
          CommonTextField(
            controller: controller,
            hintText: hint,
            textInputAction: TextInputAction.next,
            validator: requiredField
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter $label';
                    }
                    return null;
                  }
                : null,
          )
        else
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: _hintColor,
              ),
              prefixIcon: icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 38),
                      child: Icon(
                        icon,
                        color: _primaryColor,
                        size: 19,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: _primaryColor,
                  width: 1.3,
                ),
              ),
            ),
          ),
      ],
    );
  }
Widget _buildExistingCategories() {
  return BlocBuilder<StaffCategoryBloc, StaffCategoryState>(
    builder: (context, state) {
      final categories = state.categories;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
              text: 'EXISTING CATEGORIES',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _primaryColor,
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            if (state.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (categories.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: CommonText(
                    text: 'No categories added yet',
                    fontSize: 12,
                    color: _hintColor,
                  ),
                ),
              )
            else
              ...categories.map((category) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFEDF0F5),
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_rounded,
                        color: _primaryColor,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: CommonText(
                          text: category.name,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Edit using UpdateStaffCategoryEvent
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 19,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<StaffCategoryBloc>().add(
                            DeleteStaffCategoryEvent(category.id),
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 17, 12, 17),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFCE7F0),
                    Color(0xFFFFEBD9),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: 'Add Staff Category',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _primaryColor,
                        ),
                        SizedBox(height: 3),
                        CommonText(
                          text: 'e.g., Maid, Driver, Plumber, Security',
                          fontSize: 11,
                          color: Color(0xFF71829F),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Form and existing categories
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: const Color(0xFFE8EDF5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.025),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _categoryField(
                              label: 'Category Name',
                              hint: 'e.g. Security Guard, Housekeeping',
                              controller: _categoryController,
                              requiredField: true,
                            ),

                            const SizedBox(height: 15),

                            _categoryField(
                              label: 'Description',
                              hint: 'Enter category description',
                              controller: _descriptionController,
                              maxLines: 3,
                              icon: Icons.description_outlined,
                            ),

                            const SizedBox(height: 16),

                            if (_editingIndex == null)
                              SizedBox(
                                width: double.infinity,
                                child: CommonButton(
                                  text: 'Save Category',
                                  icon: Icons.check_circle_outline,
                                  onPressed: _saveCategory,
                                ),
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _editingIndex = null;
                                          _categoryController.clear();
                                          _descriptionController.clear();
                                        });
                                      },
                                      child: const Text('Cancel Edit'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: CommonButton(
                                      text: 'Update',
                                      icon: Icons.check_rounded,
                                      onPressed: _updateCategory,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 17),

                      // Existing category list
                      _buildExistingCategories(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
