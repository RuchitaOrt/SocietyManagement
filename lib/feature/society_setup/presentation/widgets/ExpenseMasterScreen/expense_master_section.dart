
import 'package:flutter/material.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/ExpenseCategoryModel.dart';



class ExpenseMasterSection extends StatelessWidget {
  final List<ExpenseCategoryModel> categories;
  final Function(int) onRemove;

  const ExpenseMasterSection({
    super.key,
    required this.categories,
    required this.onRemove,
  });

  static const Color primaryColor = Color(0xFFE93691);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 17,
            ),
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 3,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Expense Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFFFFEDF5),
                  child: Text(
                    '${categories.length}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: Color(0xFFE8EDF4),
          ),

          // EMPTY STATE
          if (categories.isEmpty)
            const SizedBox(
              height: 185,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.content_paste_outlined,
                      size: 38,
                      color: Color(0xFFE0E7F0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No Expense Categories Yet',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF91A0B8),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Add expense categories below',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB8C6D9),
                      ),
                    ),
                  ],
                ),
              ),
            )

          // CATEGORY LIST
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              itemCount: categories.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 20),
              itemBuilder: (context, index) {
                final category = categories[index];

                return Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFFFEDF5),
                      child: Icon(
                        Icons.receipt_long_outlined,
                        color: primaryColor,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.expenseName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Code: ${category.expenseCode}'
                            '${category.accountGroup != null ? ' • ${category.accountGroup}' : ''}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF91A0B8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () => onRemove(index),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
