import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/staff_category_model.dart';

import '../../bloc/SoceityStaff/staff_category_bloc.dart';

const Color categoryPrimary = Color(0xFFE93691);
const Color categoryText = Color(0xFF25324A);
const Color categoryMuted = Color(0xFF71829F);
const Color categoryBorder = Color(0xFFDCE4EF);

Future<void> showManageStaffCategorySheet({
  required BuildContext context,
}) async {
  final bloc = context.read<StaffCategoryBloc>();
  final isDesktop = MediaQuery.of(context).size.width >= 600;

  if (isDesktop) {
    await showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: ManageStaffCategorySheet(isDialog: true),
        ),
      ),
    );
  } else {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const ManageStaffCategorySheet(isDialog: false),
      ),
    );
  }
}

class ManageStaffCategorySheet extends StatefulWidget {
  final bool isDialog;

  const ManageStaffCategorySheet({
    super.key,
    required this.isDialog,
  });

  @override
  State<ManageStaffCategorySheet> createState() =>
      _ManageStaffCategorySheetState();
}

class _ManageStaffCategorySheetState
    extends State<ManageStaffCategorySheet> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String? editingId;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();

    setState(() {
      editingId = null;
    });
  }

  void _editCategory(StaffCategoryModel category) {
    setState(() {
      editingId = category.id;
      nameController.text = category.name;
      descriptionController.text = category.description;
    });
  }

  void _saveCategory() {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<StaffCategoryBloc>();
    final name = nameController.text.trim();

    final duplicate = bloc.state.categories.any(
      (category) =>
          category.id != editingId &&
          category.name.toLowerCase() == name.toLowerCase(),
    );

    if (duplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This category already exists'),
        ),
      );
      return;
    }

    if (editingId == null) {
      bloc.add(
        AddStaffCategoryEvent(
          StaffCategoryModel(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: name,
            description: descriptionController.text.trim(),
          ),
        ),
      );
    } else {
      bloc.add(
        UpdateStaffCategoryEvent(
          StaffCategoryModel(
            id: editingId!,
            name: name,
            description: descriptionController.text.trim(),
          ),
        ),
      );
    }

    _clearForm();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          editingId == null
              ? 'Category added successfully'
              : 'Category updated successfully',
        ),
      ),
    );
  }

  Future<void> _deleteCategory(
    StaffCategoryModel category,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Delete "${category.name}" category?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<StaffCategoryBloc>().add(
            DeleteStaffCategoryEvent(category.id),
          );

      if (editingId == category.id) {
        _clearForm();
      }
    }
  }

  Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF53647C),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 12,
              color: categoryMuted,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: categoryBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: categoryBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: categoryPrimary),
            ),
          ),
          validator: (value) {
            if (label == 'Category Name' &&
                (value == null || value.trim().isEmpty)) {
              return 'Please enter category name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _categoryForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDF1F6)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textField(
              label: 'Category Name',
              hint: 'e.g., Maid, Driver, Plumber, Security',
              controller: nameController,
            ),
            const SizedBox(height: 4),
            _textField(
              label: 'Description',
              hint: 'Enter description',
              controller: descriptionController,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: categoryPrimary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: Text(
                    editingId == null ? 'Add Category' : 'Update Category',
                  ),
                ),
                if (editingId != null) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _clearForm,
                    child: const Text('Cancel Edit'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _existingCategories(List<StaffCategoryModel> categories) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: categoryBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EXISTING CATEGORIES',
            style: TextStyle(
              color: categoryPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: .3,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: categoryBorder),
          const SizedBox(height: 12),
          if (categories.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No categories added yet',
                  style: TextStyle(color: categoryMuted),
                ),
              ),
            )
          else
            ...categories.map(
              (category) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFEDF1F6),
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: categoryMuted,
                      size: 19,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              color: categoryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (category.description.isNotEmpty)
                            Text(
                              category.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: categoryMuted,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () => _editCategory(category),
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: categoryMuted,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () => _deleteCategory(category),
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: categoryMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        width: 460,
        constraints: BoxConstraints(
          maxWidth: 460,
          maxHeight: height * .90,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFCE8F1),
                    Color(0xFFFFEFDC),
                  ],
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage Staff Categories',
                          style: TextStyle(
                            color: categoryPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Add and manage staff categories',
                          style: TextStyle(
                            color: categoryMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<StaffCategoryBloc, StaffCategoryState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _categoryForm(),
                        const SizedBox(height: 16),
                        _existingCategories(state.categories),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFEDF1F6)),
                ),
              ),
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}