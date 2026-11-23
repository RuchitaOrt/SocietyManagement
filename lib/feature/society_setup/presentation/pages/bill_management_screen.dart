import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/BillingManagement/bill_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/BillingManagement/bill_event.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/BillingManagement/bill_model.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/BillingManagement/bill_state.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/BillingManagement/generate_bills_bottom_sheet.dart';



const Color billScreenPrimary = Color(0xFFE93691);

class BillManagementScreen extends StatefulWidget {
  const BillManagementScreen({super.key});

  @override
  State<BillManagementScreen> createState() =>
      _BillManagementScreenState();
}

class _BillManagementScreenState extends State<BillManagementScreen> {
  Future<void> _generateBills() async {
    final result = await showGenerateBillsBottomSheet(
      context: context,
      societyName: 'Jainam',
    );

    if (!mounted || result == null) return;

    context.read<BillBloc>().add(BillCreated(result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: AdminColors.page,
     appBar: AppBar(
  title: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            Color(0xFFEC4899),
            Color(0xFFF97316),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: const Text(
          'Bill Master',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 3),
      Text(
        'Generate & manage maintenance bills',
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
      onPressed: () {
        // TODO: Navigate to Notifications Screen
      },
      icon: const Icon(
        Icons.notifications_none_rounded,
        color: Color(0xFFEC4899),
        size: 25,
      ),
      tooltip: 'Notifications',
    ),
    const SizedBox(width: 6),
  ],
),
  body: SafeArea(
    child: BlocBuilder<BillBloc, BillState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                _filters(state, isMobile),
                _summary(state, isMobile),
                Expanded(
                  child: _billTable(state),
                ),
              ],
            );
          },
        );
      },
    ),
  ),
  floatingActionButton: _buildFloatingButtons(),
);;
  }
Widget _buildFloatingButtons() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      FloatingActionButton.extended(
        heroTag: 'regenerateBills',
        onPressed: _generateBills,
        backgroundColor: Colors.white,
        foregroundColor: billScreenPrimary,
        elevation: 3,
        icon: const Icon(Icons.refresh_rounded, size: 19),
        label: const Text(
          'Regenerate',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      const SizedBox(width: 10),
      FloatingActionButton.extended(
        heroTag: 'generateBills',
        onPressed: _generateBills,
        backgroundColor: billScreenPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text(
          'Generate Bills',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}
  Widget _header(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                
              ],
            )
          : Row(
              children: [
                Expanded(child: _title()),
                _generateButton(),
                const SizedBox(width: 12),
                _regenerateButton(),
              ],
            ),
    );
  }

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bill Master',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: billScreenPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Generate & manage maintenance bills',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _generateButton() {
    return ElevatedButton.icon(
      onPressed: _generateBills,
      icon: const Icon(Icons.add, size: 17),
      label: const Text('Generate Bills'),
      style: ElevatedButton.styleFrom(
        backgroundColor: billScreenPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size(145, 42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _regenerateButton() {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Regenerate Bills action'),
          ),
        );
      },
      icon: const Icon(Icons.refresh_rounded, size: 17),
      label: const Text('Regenerate Bills'),
      style: ElevatedButton.styleFrom(
        backgroundColor: billScreenPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size(155, 42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        elevation: 2,
      ),
    );
  }
bool _showFilters = false;
Widget _filters(BillState state, bool isMobile) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search + Filter button
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: TextField(
                  onChanged: (value) {
                    context.read<BillBloc>().add(
                          BillSearchChanged(value),
                        );
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by flat, owner, bill ID...',
                    hintStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 19,
                      color: Color(0xFF91A0B8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(
                        color: Color(0xFFDCE4EF),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(
                        color: Color(0xFFDCE4EF),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Filter icon button
            InkWell(
              onTap: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
              borderRadius: BorderRadius.circular(11),
              child: Container(
                height: 44,
                width: 46,
                decoration: BoxDecoration(
                  color: _showFilters
                      ? billScreenPrimary
                      : Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: _showFilters
                        ? billScreenPrimary
                        : const Color(0xFFDCE4EF),
                  ),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: _showFilters
                      ? Colors.white
                      : const Color(0xFF53647C),
                  size: 21,
                ),
              ),
            ),
          ],
        ),

        // Expandable filters
        if (_showFilters) ...[
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _filterDropdown(
                value: state.selectedWing,
                items: [
                  'All Wings',
                  'A',
                  'B',
                  'C',
                ],
                onChanged: (value) {
                  context.read<BillBloc>().add(
                        BillFilterChanged(
                          wing: value!,
                          month: state.selectedMonth,
                          status: state.selectedStatus,
                        ),
                      );
                },
              ),

              _filterDropdown(
                value: state.selectedMonth,
                items: [
                  'All Months',
                  'April',
                  'May',
                  'June',
                  'July',
                  'August',
                  'September',
                  'October',
                  'November',
                  'December',
                  'January',
                  'February',
                  'March',
                ],
                onChanged: (value) {
                  context.read<BillBloc>().add(
                        BillFilterChanged(
                          wing: state.selectedWing,
                          month: value!,
                          status: state.selectedStatus,
                        ),
                      );
                },
              ),

              _filterDropdown(
                value: state.selectedStatus,
                items: [
                  'All Status',
                  'Unpaid',
                  'Partial',
                  'Paid',
                ],
                onChanged: (value) {
                  context.read<BillBloc>().add(
                        BillFilterChanged(
                          wing: state.selectedWing,
                          month: state.selectedMonth,
                          status: value!,
                        ),
                      );
                },
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

  Widget _filterDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 42,
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDCE4EF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _summary(BillState state, bool isMobile) {
    final items = [
      _Summary(
        'Total Bills',
        '${state.totalBills}',
        Icons.receipt_long_outlined,
        const Color(0xFF6366F1),
      ),
      _Summary(
        'Unpaid',
        '${state.unpaidBills}',
        Icons.error_outline,
        Colors.red,
      ),
      _Summary(
        'Partial',
        '${state.partialBills}',
        Icons.payments_outlined,
        Colors.orange,
      ),
      _Summary(
        'Paid',
        '${state.paidBills}',
        Icons.check_circle_outline,
        Colors.green,
      ),
      _Summary(
        'Total Billed',
        '₹${state.totalBilled.toStringAsFixed(2)}',
        Icons.account_balance_wallet_outlined,
        billScreenPrimary,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1100
              ? 5
              : constraints.maxWidth >= 700
                  ? 3
                  : 2;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: isMobile ? 2.1 : 2.5,
            ),
            itemBuilder: (context, index) {
              return _summaryCard(items[index]);
            },
          );
        },
      ),
    );
  }

  Widget _summaryCard(_Summary item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: Color(0xFF202B43),
                  ),
                ),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _billTable(BillState state) {
    final bills = state.filteredBills;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: bills.isEmpty
          ? _emptyState()
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: constraints.maxWidth < 1200
                        ? 1200
                        : constraints.maxWidth,
                    child: Column(
                      children: [
                        _tableHeader(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: bills.length,
                            itemBuilder: (context, index) {
                              return _billRow(
                                bills[index],
                                index,
                              );
                            },
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

  Widget _tableHeader() {
    const headers = [
      'S.No',
      'Flat',
      'Wing',
      'Owner',
      'Month / Year',
      'Bill Date',
      'Due Date',
      'Interest',
      'Amount',
      'Status',
      'Actions',
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFCE8F1),
            Color(0xFFFFEFDC),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: billScreenPrimary,
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: headers.map((header) {
          return _tableCell(
            header,
            header: true,
          );
        }).toList(),
      ),
    );
  }

  Widget _billRow(BillModel bill, int index) {
    final dueDate = bill.billDate.add(
      Duration(days: bill.dueDays),
    );

    final monthYear =
        '${bill.financialMonth} ${bill.financialYear}';

    final cells = [
      '${index + 1}',
      bill.flat,
      bill.wing,
      bill.owner,
      monthYear,
      _date(bill.billDate),
      _date(dueDate),
      '₹0.00',
      '₹${bill.totalAmount.toStringAsFixed(2)}',
      bill.status,
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
          ),
        ),
      ),
      child: Row(
        children: [
          ...cells.map(
            (cell) => _tableCell(
              cell,
              status: cell == bill.status,
            ),
          ),
          SizedBox(
            width: 100,
            child: PopupMenuButton<String>(
              onSelected: (action) {
                if (action == 'delete') {
                  context.read<BillBloc>().add(
                        BillDeleted(bill),
                      );
                } else {
                  context.read<BillBloc>().add(
                        BillStatusUpdated(bill, action),
                      );
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'Paid',
                  child: Text('Mark Paid'),
                ),
                const PopupMenuItem(
                  value: 'Partial',
                  child: Text('Mark Partial'),
                ),
                const PopupMenuItem(
                  value: 'Unpaid',
                  child: Text('Mark Unpaid'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
              child: const Icon(
                Icons.more_horiz,
                color: Color(0xFF617792),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCell(
    String value, {
    bool header = false,
    bool status = false,
  }) {
    return SizedBox(
      width: header && value == 'Actions' || value == 'Actions'
          ? 100
          : 110,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        child: status
            ? _statusBadge(value)
            : Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: header ? 11 : 12,
                  fontWeight: header
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: header
                      ? const Color(0xFF34435A)
                      : const Color(0xFF53647C),
                ),
              ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case 'Paid':
        color = Colors.green;
        break;
      case 'Partial':
        color = Colors.orange;
        break;
      default:
        color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 50,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Bills Found',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF53647C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate your first bill or adjust filters',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  String _date(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _Summary {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _Summary(
    this.title,
    this.value,
    this.icon,
    this.color,
  );
}