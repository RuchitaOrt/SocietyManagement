
import 'package:flutter/material.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

class MemberBillsScreen extends StatefulWidget {
  const MemberBillsScreen({super.key});

  @override
  State<MemberBillsScreen> createState() => _MemberBillsScreenState();
}

class _MemberBillsScreenState extends State<MemberBillsScreen> {
  static const Color primaryPink = Color(0xFFEC268F);
  static const Color backgroundColor = Color(0xFFF6F6FC);
  static const Color darkText = Color(0xFF17264B);
  static const Color lightText = Color(0xFF7885A5);

  final TextEditingController _searchController = TextEditingController();
String? expandedBillMonth;
  String selectedFilter = 'All';
  String searchQuery = '';

  final List<String> filters = [
    'All',
    'Pending Verification',
    'Unpaid',
    'Partial',
    'Paid',
    'Cancelled',
  ];

  final List<BillModel> bills = [
    BillModel(
      title: 'Maintenance Charges',
      month: 'November 2026',
      billDate: '21 Nov 2026',
      dueDate: '20 Dec 2026',
      totalAmount: 1000,
      paidAmount: 0,
      status: 'Unpaid',
    ),
    BillModel(
      title: 'Parking Fee',
      month: 'October 2026',
      billDate: '21 Oct 2026',
      dueDate: '20 Nov 2026',
      totalAmount: 1000,
      paidAmount: 500,
      status: 'Partial',
    ),
    BillModel(
      title: 'Maintenance Charges',
      month: 'September 2026',
      billDate: '21 Sep 2026',
      dueDate: '20 Oct 2026',
      totalAmount: 1000,
      paidAmount: 1000,
      status: 'Paid',
    ),
    BillModel(
      title: 'Club Membership',
      month: 'August 2026',
      billDate: '21 Aug 2026',
      dueDate: '20 Sep 2026',
      totalAmount: 1000,
      paidAmount: 0,
      status: 'Pending Verification',
    ),
    BillModel(
      title: 'Maintenance Charges',
      month: 'July 2026',
      billDate: '21 Jul 2026',
      dueDate: '20 Aug 2026',
      totalAmount: 1000,
      paidAmount: 0,
      status: 'Cancelled',
    ),
  ];

  List<BillModel> get filteredBills {
    return bills.where((bill) {
      final matchesFilter =
          selectedFilter == 'All' || bill.status == selectedFilter;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          bill.title.toLowerCase().contains(query) ||
          bill.month.toLowerCase().contains(query) ||
          bill.status.toLowerCase().contains(query) ||
          bill.totalAmount.toString().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Unpaid':
        return const Color(0xFFE91E63);
      case 'Partial':
        return const Color(0xFFFF9800);
      case 'Paid':
        return const Color(0xFF16A36A);
      case 'Pending Verification':
        return const Color(0xFFF08A00);
      case 'Cancelled':
        return const Color(0xFF858585);
      default:
        return primaryPink;
    }
  }

  Color getStatusBackground(String status) {
    return getStatusColor(status).withValues(alpha: 0.10);
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Unpaid':
        return Icons.error_outline_rounded;
      case 'Partial':
        return Icons.pie_chart_outline_rounded;
      case 'Paid':
        return Icons.check_circle_outline_rounded;
      case 'Pending Verification':
        return Icons.access_time_rounded;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  String formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  void refreshBills() {
    setState(() {
      selectedFilter = 'All';
      searchQuery = '';
      _searchController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bills refreshed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredBills;

    return Scaffold(
    backgroundColor: AdminColors.page,
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
                'My Bills',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'View your maintenance bills and dues | Ruchita | Flat 201 | A',
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
         
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 22),
                  _buildFilters(),
                  const SizedBox(height: 22),
                  _buildBillList(filtered),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header
  // Widget _buildHeader() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(16, 16, 20, 8),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           onPressed: () => Navigator.pop(context),
  //           icon: const Icon(
  //             Icons.arrow_back_rounded,
  //             color: darkText,
  //             size: 26,
  //           ),
  //         ),
  //         const SizedBox(width: 6),
  //         const Expanded(
  //           child: Text(
  //             'My Bills',
  //             style: TextStyle(
  //               fontSize: 23,
  //               fontWeight: FontWeight.w800,
  //               color: darkText,
  //             ),
  //           ),
  //         ),
  //         // Material(
  //         //   color: primaryPink,
  //         //   borderRadius: BorderRadius.circular(12),
  //         //   child: InkWell(
  //         //     borderRadius: BorderRadius.circular(12),
  //         //     onTap: refreshBills,
  //         //     child: const Padding(
  //         //       padding: EdgeInsets.symmetric(
  //         //         horizontal: 14,
  //         //         vertical: 11,
  //         //       ),
  //         //       child: Row(
  //         //         children: [
  //         //           Icon(
  //         //             Icons.refresh_rounded,
  //         //             color: Colors.white,
  //         //             size: 19,
  //         //           ),
  //         //           SizedBox(width: 6),
  //         //           Text(
  //         //             'Refresh',
  //         //             style: TextStyle(
  //         //               color: Colors.white,
  //         //               fontSize: 13,
  //         //               fontWeight: FontWeight.w700,
  //         //             ),
  //         //           ),
  //         //         ],
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  // Search
  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EAF3)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        style: const TextStyle(
          color: darkText,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Search bills...',
          hintStyle: const TextStyle(
            color: lightText,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: lightText,
            size: 23,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.close, size: 19),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 14,
          ),
        ),
      ),
    );
  }

  // Status filters
  Widget _buildFilters() {
    return SizedBox(
      height: 43,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? primaryPink : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? primaryPink
                      : const Color(0xFFE7E8F0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filter != 'All') ...[
                    Icon(
                      getStatusIcon(filter),
                      color: isSelected
                          ? Colors.white
                          : getStatusColor(filter),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : darkText,
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Bill list
  Widget _buildBillList(List<BillModel> filtered) {
    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 55,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 14),
            const Text(
              'No Bills Found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try changing your search or filter.',
              style: TextStyle(
                fontSize: 13,
                color: lightText,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...filtered.map(
          (bill) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _buildBillCard(bill),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Showing ${filtered.length} of ${bills.length} bills',
          style: const TextStyle(
            fontSize: 12,
            color: lightText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Individual bill card
Widget _buildBillCard(BillModel bill) {
  final statusColor = getStatusColor(bill.status);
  final balance = bill.totalAmount - bill.paidAmount;

  final isExpanded = expandedBillMonth == bill.month;

  final canPay =
      bill.status == 'Unpaid' || bill.status == 'Partial';

  return Card(
    elevation: 1,
    shadowColor: Colors.black.withValues(alpha: 0.04),
    color: Colors.white,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(
        color: isExpanded
            ? primaryPink.withValues(alpha: 0.45)
            : const Color(0xFFE9EAF2),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bill summary
        InkWell(
          onTap: () {
            setState(() {
              expandedBillMonth =
                  isExpanded ? null : bill.month;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: statusColor,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: lightText,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              bill.month,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: lightText,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusBackground(bill.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              getStatusIcon(bill.status),
                              color: statusColor,
                              size: 13,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              bill.status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatAmount(bill.totalAmount),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (canPay)
                      Text(
                        'Due ${formatAmount(balance)}',
                        style: const TextStyle(
                          color: lightText,
                          fontSize: 10,
                        ),
                      ),
                    const SizedBox(height: 5),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: lightText,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Expandable bill details
        AnimatedCrossFade(
          firstChild: const SizedBox(
            width: double.infinity,
          ),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Color(0xFFE9EAF2),
                  height: 1,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Bill Details',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 12),

                _detailRow('Bill Date', bill.billDate),
                _detailRow('Due Date', bill.dueDate),

                const SizedBox(height: 5),

                _detailRow(
                  'Total Amount',
                  formatAmount(bill.totalAmount),
                ),
                _detailRow(
                  'Paid Amount',
                  formatAmount(bill.paidAmount),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Remaining Balance',
                          style: TextStyle(
                            fontSize: 13,
                            color: darkText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          formatAmount(balance),
                          style: TextStyle(
                            fontSize: 16,
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (canPay) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Payment flow will be connected here.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.payment_rounded,
                        size: 19,
                      ),
                      label: const Text('Pay Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPink,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    ),
  );
}

 

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: lightText,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy bill model
class BillModel {
  final String title;
  final String month;
  final String billDate;
  final String dueDate;
  final double totalAmount;
  final double paidAmount;
  final String status;

  BillModel({
    required this.title,
    required this.month,
    required this.billDate,
    required this.dueDate,
    required this.totalAmount,
    required this.paidAmount,
    required this.status,
  });
}
