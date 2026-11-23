
import 'package:flutter/material.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/FinancialYearModel.dart';

class FinancialYearSection extends StatelessWidget {
  final List<FinancialYearModel> financialYears;
  final ValueChanged<int> onRemove;

  const FinancialYearSection({
    super.key,
    required this.financialYears,
    required this.onRemove,
  });

  static const Color primaryColor = Color(0xFFE93691);
  static const Color textColor = Color(0xFF202B43);
  static const Color hintColor = Color(0xFF91A0B8);

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
          // Header
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
                    'Financial Years Added',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFFFFEDF5),
                  child: Text(
                    '${financialYears.length}',
                    style: TextStyle(
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

          // Empty state
          if (financialYears.isEmpty)
            SizedBox(
              height: 185,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 38,
                      color: Color(0xFFE0E7F0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No Financial Year Added Yet',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: hintColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Tap Add Financial Year to add your society financial year.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB8C6D9),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              itemCount: financialYears.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 20),
              itemBuilder: (context, index) {
                final financialYear = financialYears[index];

                return Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_month_outlined,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  financialYear.financialYearName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              if (financialYear.isCurrent) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE5F7EA),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Current Year',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF008942),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Start: ${financialYear.startDate}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: hintColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'End: ${financialYear.endDate}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: hintColor,
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
