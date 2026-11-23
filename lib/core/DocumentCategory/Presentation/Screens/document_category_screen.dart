
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/core/DocumentCategory/Presentation/Bloc/DocumentCategoryModel.dart';
import 'package:society_management/core/DocumentCategory/Presentation/Bloc/document_category_bloc.dart';
import 'package:society_management/core/DocumentCategory/Presentation/Widgets/add_document_category_bottom_sheet.dart';

import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);

class DocumentCategoryScreen extends StatelessWidget {
  const DocumentCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocumentCategoryBloc(),
      child: const _DocumentCategoryView(),
    );
  }
}

class _DocumentCategoryView extends StatefulWidget {
  const _DocumentCategoryView();

  @override
  State<_DocumentCategoryView> createState() =>
      _DocumentCategoryViewState();
}

class _DocumentCategoryViewState
    extends State<_DocumentCategoryView> {

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ADD CATEGORY

  Future<void> _openAddCategory() async {
    final category = await showAddDocumentCategoryBottomSheet(
      context,
    );

    if (!mounted || category == null) return;

    context.read<DocumentCategoryBloc>().add(
      DocumentCategoryCreated(category),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document category added successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // SEARCH

  List<DocumentCategoryModel> _filterCategories(
    List<DocumentCategoryModel> categories,
  ) {
    if (_searchQuery.trim().isEmpty) return categories;

    final query = _searchQuery.toLowerCase().trim();

    return categories.where((category) {
      return category.categoryName
              .toLowerCase()
              .contains(query) ||
          category.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.page,

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addDocumentCategory',
        onPressed: _openAddCategory,
        backgroundColor: _primaryColor,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          'Add Category',
          style: TextStyle(color: Colors.white),
        ),
      ),

      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  const LinearGradient(
                colors: [
                  Color(0xFFEC4899),
                  Color(0xFFF97316),
                ],
              ).createShader(bounds),
              child: const Text(
                'Document Category Master',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Manage document categories',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        backgroundColor: AdminColors.page,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFFEC4899),
              size: 25,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: BlocBuilder<DocumentCategoryBloc,
          DocumentCategoryState>(
        builder: (context, state) {

          final filteredCategories =
              _filterCategories(state.categories);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 18),

                // SUMMARY

                _buildSummary(state),

                const SizedBox(height: 16),

                // SEARCH

                _buildSearch(),

                const SizedBox(height: 16),

                // CATEGORY LIST

                _buildCategoryList(
                  filteredCategories,
                  state.categories,
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  // SUMMARY CARD

  Widget _buildSummary(DocumentCategoryState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.folder_copy_outlined,
              color: _primaryColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${state.totalCategories}',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                ),
              ),
              Text(
                'Total Categories',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // SEARCH FIELD

  Widget _buildSearch() {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: 'Search document categories...',
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xFF91A0B8),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 19,
            color: Color(0xFF91A0B8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFDCE3EF),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFDCE3EF),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: _primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  // CATEGORY CARD LIST

  Widget _buildCategoryList(
    List<DocumentCategoryModel> filteredCategories,
    List<DocumentCategoryModel> allCategories,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // HEADER

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFE8F1),
                  Color(0xFFFFEBD8),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: const Text(
              'Document Category List',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _textColor,
              ),
            ),
          ),

          if (filteredCategories.isEmpty)
            _buildEmptyState(allCategories.isEmpty)
          else
            ...List.generate(
              filteredCategories.length,
              (index) {
                final category = filteredCategories[index];

                return Column(
                  children: [
                    _buildCategoryCard(
                      category,
                      index + 1,
                    ),

                    if (index != filteredCategories.length - 1)
                      Divider(
                        height: 1,
                        color: Colors.grey.shade100,
                        indent: 14,
                        endIndent: 14,
                      ),
                  ],
                );
              },
            ),

          // FOOTER

          if (filteredCategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                'Showing ${filteredCategories.length} of ${allCategories.length} categories',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // INDIVIDUAL CATEGORY CARD

  Widget _buildCategoryCard(
    DocumentCategoryModel category,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.folder_outlined,
              color: _primaryColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  category.categoryName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                  ),
                ),

                if (category.description.isNotEmpty) ...[
                  const SizedBox(height: 5),

                  Text(
                    category.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],

                const SizedBox(height: 7),

                Text(
                  'Category $index',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF91A0B8),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () => _confirmDelete(category),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
            tooltip: 'Delete Category',
          ),
        ],
      ),
    );
  }

  // EMPTY STATE

  Widget _buildEmptyState(bool isCompletelyEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Icon(
            isCompletelyEmpty
                ? Icons.folder_off_outlined
                : Icons.search_off,
            size: 42,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          Text(
            isCompletelyEmpty
                ? 'No Document Categories Added'
                : 'No Matching Categories Found',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            isCompletelyEmpty
                ? 'Click Add Category to create your first document category.'
                : 'Try searching with another keyword.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // DELETE CONFIRMATION

  void _confirmDelete(DocumentCategoryModel category) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Document Category'),
          content: Text(
            'Are you sure you want to delete ${category.categoryName}?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<DocumentCategoryBloc>().add(
                  DocumentCategoryDeleted(category),
                );

                Navigator.pop(dialogContext);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
