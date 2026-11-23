
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';
import 'package:society_management/feature/cashbook/presentation/widgets/CashbookCreditEntryBottomSheet.dart';
import 'package:society_management/feature/cashbook/presentation/widgets/CashbookEntryBottomSheet.dart';

import '../../domain/transaction_model.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../widgets/cashbook_widgets.dart';
import 'create_transaction_screen.dart';

class CashbookScreen extends StatefulWidget {
  const CashbookScreen({super.key});

  @override
  State<CashbookScreen> createState() => _CashbookScreenState();
}

class _CashbookScreenState extends State<CashbookScreen> {
  
  TransactionType? selectedType;
DateTime? selectedDate;
  final TextEditingController _searchController =
      TextEditingController();
String? selectedBank;
String? selectedCategory;
  bool _menuOpen = false;


  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(
          const TransactionsRequested(),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
Widget _buildStringFilter({
  required String? value,
  required String hint,
  required List<String> items,
  required ValueChanged<String?> onChanged,
  String Function(String)? itemLabel,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    isExpanded: true,
    decoration: InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 13,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: cashbookBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: cashbookBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: cashbookPink),
      ),
    ),
    icon: const Icon(
      Icons.keyboard_arrow_down_rounded,
      size: 18,
    ),
    items: [
      DropdownMenuItem<String>(
        value: null,
        child: Text(
          hint,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            color: cashbookNavy,
          ),
        ),
      ),
      ...items.map(
        (item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            itemLabel?.call(item) ?? item,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: cashbookNavy,
            ),
          ),
        ),
      ),
    ],
    onChanged: onChanged,
  );
}
Widget _buildFilterSection({
  required List<CashbookTransaction> transactions,
}) {
  final banks = transactions
      .map((e) => e.bank.trim())
      .where((e) => e.isNotEmpty)
      .toSet()
      .toList()
    ..sort();

  final categories = transactions
      .map((e) => e.category.trim())
      .where((e) => e.isNotEmpty)
      .toSet()
      .toList()
    ..sort();

  return _sectionContainer(
    title: 'Filters & Summary',
    subtitle: 'Search and filter cashbook transactions',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SEARCH
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Search member, description, bank...',
            prefixIcon: const Icon(
              Icons.search,
              color: cashbookMuted,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: cashbookBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: cashbookBorder),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // TYPE, BANK, CATEGORY
        LayoutBuilder(
          builder: (context, constraints) {
            final width = (constraints.maxWidth - 20) / 3;

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: width,
                  child: _buildStringFilter(
                    value: selectedType?.name,
                    hint: 'All Types',
                    items: const [
                      'credit',
                      'debit',
                      'transfer',
                    ],
                    itemLabel: (value) =>
                        value[0].toUpperCase() + value.substring(1),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value == null
                            ? null
                            : TransactionType.values.firstWhere(
                                (e) => e.name == value,
                              );
                      });
                    },
                  ),
                ),

                SizedBox(
                  width: width,
                  child: _buildStringFilter(
                    value: selectedBank,
                    hint: 'All Banks',
                    items: banks,
                    onChanged: (value) {
                      setState(() {
                        selectedBank = value;
                      });
                    },
                  ),
                ),

                SizedBox(
                  width: width,
                  child: _buildStringFilter(
                    value: selectedCategory,
                    hint: 'All Categories',
                    items: categories,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 12),

        // DATE RANGE + RESET
        LayoutBuilder(
          builder: (context, constraints) {
            final dateWidth = (constraints.maxWidth - 10) / 2;

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: dateWidth,
                  child: _dateFilterButton(
                    label: 'From Date',
                    value: _fromDate == null
                        ? 'dd/mm/yyyy'
                        : _formatDate(_fromDate!),
                    onTap: _selectFromDate,
                  ),
                ),

                SizedBox(
                  width: dateWidth,
                  child: _dateFilterButton(
                    label: 'To Date',
                    value: _toDate == null
                        ? 'dd/mm/yyyy'
                        : _formatDate(_toDate!),
                    onTap: _selectToDate,
                  ),
                ),

                TextButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 17,
                  ),
                  label: const Text('Reset'),
                  style: TextButton.styleFrom(
                    foregroundColor: cashbookPink,
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

Future<void> _selectTransactionDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (picked != null && mounted) {
    setState(() {
      selectedDate = DateUtils.dateOnly(picked);
    });
  }
}

List<CashbookTransaction> getFilteredTransactions(
  List<CashbookTransaction> transactions,
) {
  return transactions.where((transaction) {

    // TYPE FILTER
    final matchesType = selectedType == null ||
        transaction.type == selectedType;

    // BANK FILTER
    final matchesBank = selectedBank == null ||
        transaction.bank.trim() == selectedBank;

    // CATEGORY FILTER
    final matchesCategory = selectedCategory == null ||
        transaction.category.trim() == selectedCategory;

    // FROM DATE FILTER
    final matchesFromDate = _fromDate == null ||
        !DateUtils.dateOnly(transaction.date).isBefore(
          DateUtils.dateOnly(_fromDate!),
        );

    // TO DATE FILTER
    final matchesToDate = _toDate == null ||
        !DateUtils.dateOnly(transaction.date).isAfter(
          DateUtils.dateOnly(_toDate!),
        );

    // SEARCH FILTER
    final query = _searchController.text.trim().toLowerCase();

    final matchesSearch = query.isEmpty ||
        transaction.description.toLowerCase().contains(query) ||
        transaction.category.toLowerCase().contains(query) ||
        transaction.memberOrParty.toLowerCase().contains(query) ||
        transaction.bank.toLowerCase().contains(query);

    return matchesType &&
        matchesBank &&
        matchesCategory &&
        matchesFromDate &&
        matchesToDate &&
        matchesSearch;
  }).toList();
}
void _resetFilters() {
  _searchController.clear();

  setState(() {
    selectedType = null;
    selectedBank = null;
    selectedCategory = null;
    selectedDate = null;
    _fromDate = null;
    _toDate = null;
  });

  context.read<TransactionBloc>().add(
    const TransactionFiltersReset(),
  );
}

  String _money(double value) =>
      '₹${value.toStringAsFixed(2)}';

  String _month(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_month(date.month)} ${date.year}';
  }

  Future<void> _openCreate(TransactionType type) async {
    setState(() => _menuOpen = false);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TransactionBloc>(),
          child: CreateTransactionScreen(initialType: type),
        ),
      ),
    );
  }

  void _actionMessage(String action) {
    setState(() => _menuOpen = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$action integration can be connected to your file/API workflow.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }



  Future<void> _selectFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && mounted) {
      setState(() {
        _fromDate = picked;

        if (_toDate != null && _toDate!.isBefore(picked)) {
          _toDate = null;
        }
      });
    }
  }

  Future<void> _selectToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? _fromDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && mounted) {
      setState(() => _toDate = picked);
    }
  }

  List<CashbookTransaction> _applyDateFilters(
    List<CashbookTransaction> transactions,
  ) {
    return transactions.where((item) {
      final date = item.date;

      if (_fromDate != null) {
        final from = DateUtils.dateOnly(_fromDate!);

        if (DateUtils.dateOnly(date).isBefore(from)) {
          return false;
        }
      }

      if (_toDate != null) {
        final to = DateUtils.dateOnly(_toDate!);

        if (DateUtils.dateOnly(date).isAfter(to)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  Widget _filterDropdown(
    String label,
    TransactionType? value,
    ValueChanged<TransactionType?> onChanged,
  ) {
    return DropdownButtonFormField<TransactionType?>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: cashbookBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: cashbookBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: cashbookPink),
        ),
      ),
      items: const [
        DropdownMenuItem<TransactionType?>(
          value: null,
          child: Text('All Types'),
        ),
        DropdownMenuItem<TransactionType?>(
          value: TransactionType.credit,
          child: Text('Credit'),
        ),
        DropdownMenuItem<TransactionType?>(
          value: TransactionType.debit,
          child: Text('Debit'),
        ),
      ],
      onChanged: onChanged,
    );
  }
  
void _saveCreditCashbookEntry(
  Map<String, dynamic> data, {
  required bool isTransfer,
  TransactionType? type,
}) {
  final transaction = CashbookTransaction(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    date: DateTime.parse(data['dateTime'].toString()),

    type: isTransfer
        ? TransactionType.transfer
        : type ?? TransactionType.debit,

    description: data['description']?.toString() ?? '',

    category: isTransfer
        ? 'Bank Transfer'
        : data['category']?.toString() ?? '',

    memberOrParty: isTransfer
        ? '${data['fromBank']} → ${data['toBank']}'
        : data['receivedFrom']?.toString() ??
            data['paidTo']?.toString() ?? '',

    bank: isTransfer
        ? '${data['fromBank']} → ${data['toBank']}'
        : data['paidFromBank']?.toString() ?? '',

    mode: isTransfer
        ? PaymentMode.bankTransfer
        : _getPaymentMode(data['paymentMode']?.toString()),

    amount: (data['amount'] as num).toDouble(),

    referenceNumber:
        data['chequeReferenceNumber']?.toString(),
  );

  context.read<TransactionBloc>().add(
    TransactionAdded(transaction),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '${isTransfer ? 'Transfer' : type == TransactionType.credit ? 'Credit' : 'Debit'} entry saved successfully',
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: cashbookGreen,
    ),
  );
}

void _saveCashbookEntry(
  Map<String, dynamic> data, {
  required bool isTransfer,
}) {
  debugPrint('========== SAVE CASHBOOK ENTRY ==========');
  debugPrint('Received Data: $data');
  debugPrint('Is Transfer: $isTransfer');

  final transaction = CashbookTransaction(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    date: DateTime.parse(data['dateTime'].toString()),
    type: isTransfer
        ? TransactionType.transfer
        : TransactionType.debit,
    description: data['description']?.toString() ?? '',
    category: isTransfer
        ? 'Bank Transfer'
        : data['category']?.toString() ?? '',
    memberOrParty: isTransfer
        ? '${data['fromBank']} → ${data['toBank']}'
        : data['paidTo']?.toString() ?? '',
    bank: isTransfer
        ? '${data['fromBank']} → ${data['toBank']}'
        : data['paidFromBank']?.toString() ?? '',
    mode: isTransfer
        ? PaymentMode.bankTransfer
        : _getPaymentMode(data['paymentMode']?.toString()),
    amount: (data['amount'] as num).toDouble(),
    referenceNumber: isTransfer
        ? null
        : data['chequeReferenceNumber']?.toString(),
  );

  debugPrint('Created Transaction: ${transaction.toString()}');

  context.read<TransactionBloc>().add(
    TransactionAdded(transaction),
  );

  debugPrint('TransactionAdded event dispatched');
}

PaymentMode _getPaymentMode(String? value) {
  switch (value?.toLowerCase()) {
    case 'bank transfer':
      return PaymentMode.bankTransfer;
    case 'cheque':
      return PaymentMode.cheque;
    case 'upi':
      return PaymentMode.upi;
    case 'card':
      return PaymentMode.card;
    default:
      return PaymentMode.cash;
  }
}

@override
Widget build(BuildContext context) {
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
              'CashBook',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Society financial ledger — credits & debits',
            style: TextStyle(
              fontSize: 11,
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
          ),
        ),
      ],
    ),

    body: BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },

      builder: (context, state) {
        final filteredTransactions =
            getFilteredTransactions(state.transactions);

        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(
                16, 18, 16, 110,
              ),
              children: [
                // SUMMARY CARDS
                buildSummaryCards(
                  totalCredit: _money(state.totalCredit),
                  totalDebit: _money(state.totalDebit),
                  netBalance: _money(state.netBalance),
                  creditCount: state.creditCount,
                  debitCount: state.debitCount,
                ),

                const SizedBox(height: 18),

                // SEARCH SECTION
                _sectionContainer(
                  title: 'Search Transactions',
                  subtitle: 'Find your financial records',
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Search description, member...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: cashbookMuted,
                      ),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.close),
                            ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: cashbookBorder,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // FILTER SECTION
              // FILTERS & SEARCH
_buildFilterSection(
  transactions: state.transactions,
),

const SizedBox(height: 20),

                // TRANSACTION LIST BELOW FILTER
                _sectionContainer(
                  title: 'Transaction List',
                  subtitle: 'All recorded society transactions',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${filteredTransactions.length} Records',
                      style: const TextStyle(
                        color: cashbookPink,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  child: state.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(35),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : filteredTransactions.isEmpty
                          ? _buildEmptyState()
                          : Column(
                              children: [
                                for (int i = 0;
                                    i < filteredTransactions.length;
                                    i++)
                                  _transactionTile(
                                    filteredTransactions[i],
                                    i,
                                  ),
                              ],
                            ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Showing ${filteredTransactions.length} of '
                  '${state.transactions.length} transactions',
                  style: const TextStyle(
                    color: cashbookMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            // FLOATING ACTION MENU
            if (_menuOpen)
              Positioned(
                right: 16,
                bottom: 86,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 205,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: cashbookBorder,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _actionTile(
                          Icons.file_upload_outlined,
                          'Import',
                          () => _actionMessage('Import'),
                        ),
                        _actionTile(
                          Icons.description_outlined,
                          'Template',
                          () => _actionMessage('Template'),
                        ),
                        _actionTile(
                          Icons.file_download_outlined,
                          'Export',
                          () => _actionMessage('Export'),
                        ),

                        // ADD CREDIT
                        _actionTile(
                          Icons.add_circle_outline,
                          'Add Credit',
                          () {
                            setState(() => _menuOpen = false);

                            showCreditEntryBottomSheet(
                              context: context,
                              members: const [
                                'Member 1',
                                'Member 2',
                                'Member 3',
                              ],
                              banks: const [
                                'HDFC Bank',
                                'ICICI Bank',
                                'SBI Bank',
                              ],
                              categories: const [
                                'Maintenance',
                                'Interest Income',
                                'Parking Charges',
                                'Other Income',
                              ],
                              onSave: (data) {
                                _saveCreditCashbookEntry(
                                  data,
                                  isTransfer: false,
                                  type: TransactionType.credit,
                                );
                              },
                            );
                          },
                        ),

                        // ADD DEBIT
                        _actionTile(
                          Icons.remove_circle_outline,
                          'Add Debit',
                          () {
                            setState(() => _menuOpen = false);

                            showDebitEntryBottomSheet(
                              context: context,
                              banks: const [
                                'HDFC Bank',
                                'ICICI Bank',
                                'SBI Bank',
                              ],
                              nonMembers: const [
                                'Vendor 1',
                                'Vendor 2',
                              ],
                              categories: const [
                                'Maintenance',
                                'Electricity',
                                'Water',
                                'Repairs',
                              ],
                              onSave: (data) {
                                _saveCreditCashbookEntry(
                                  data,
                                  isTransfer: false,
                                  type: TransactionType.debit,
                                );
                              },
                            );
                          },
                        ),

                        // ADD TRANSFER
                        _actionTile(
                          Icons.swap_horiz,
                          'Add Transfer',
                          () {
                            setState(() => _menuOpen = false);

                            showBankTransferBottomSheet(
                              context: context,
                              banks: const [
                                'HDFC Bank',
                                'ICICI Bank',
                                'SBI Bank',
                              ],
                              onSave: (data) {
                                _saveCashbookEntry(
                                  data,
                                  isTransfer: true,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    ),

    floatingActionButton: FloatingActionButton(
      onPressed: () {
        setState(() {
          _menuOpen = !_menuOpen;
        });
      },
      backgroundColor: cashbookPink,
      foregroundColor: Colors.white,
      child: AnimatedRotation(
        turns: _menuOpen ? .125 : 0,
        duration: const Duration(milliseconds: 180),
        child: const Icon(Icons.add, size: 30),
      ),
    ),
  );
}


  // SECTION CONTAINER
  Widget _sectionContainer({
    required String title,
    required String subtitle,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EDF4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: cashbookNavy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: cashbookMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: child,
          ),
        ],
      ),
    );
  }

  // DATE FILTER BUTTON
  Widget _dateFilterButton({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cashbookBorder),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: cashbookMuted,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: cashbookMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: cashbookNavy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TRANSACTION CARD LIST
  Widget _transactionTile(
    CashbookTransaction item,
    int index,
  ) {
 final isCredit = item.type == TransactionType.credit;
final isDebit = item.type == TransactionType.debit;
final isTransfer = item.type == TransactionType.transfer;

final color = isCredit
    ? cashbookGreen
    : isTransfer
        ? cashbookPink
        : cashbookRed;

final typeLabel = item.type.label;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE8EDF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
               isTransfer
    ? Icons.swap_horiz_rounded
    : isCredit
        ? Icons.south_west_rounded
        : Icons.north_east_rounded,
                  color: color,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: cashbookNavy,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Transaction ${index + 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: cashbookMuted,
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
                  '${isTransfer ? '' : isCredit ? '+' : '-'}${_money(item.amount)}',
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                    typeLabel.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: cashbookBorder),
          const SizedBox(height: 14),

          // DETAILS ROW
          Row(
            children: [
              Expanded(
                child: _transactionDetail(
                  Icons.calendar_today_outlined,
                  'Date',
                  _formatDate(item.date),
                ),
              ),
              Expanded(
                child: _transactionDetail(
                  Icons.category_outlined,
                  'Category',
                  item.category,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _transactionDetail(
                  Icons.person_outline_rounded,
                  'Member / Party',
                  item.memberOrParty.isEmpty
                      ? 'Not specified'
                      : item.memberOrParty,
                ),
              ),
              Expanded(
                child: _transactionDetail(
                  Icons.payment_rounded,
                  'Payment Mode',
                  item.mode.label,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: cashbookBorder),

          // BOTTOM ACTIONS
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 15,
                color: cashbookMuted,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Transaction record',
                  style: TextStyle(
                    fontSize: 10,
                    color: cashbookMuted,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Delete transaction',
                visualDensity: VisualDensity.compact,
                onPressed: () => _confirmDelete(item),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  size: 21,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _transactionDetail(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF91A0B8),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: cashbookMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cashbookNavy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 15,
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 45,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'No Transactions Found',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: cashbookNavy,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add a credit or debit to create your first transaction.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: cashbookMuted,
            ),
          ),
        ],
      ),
    );
  }

  // FAB ACTION ITEM
  Widget _actionTile(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        color: cashbookPink,
        size: 21,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: cashbookNavy,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  // DELETE CONFIRMATION
  Future<void> _confirmDelete(CashbookTransaction item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text(
          'Are you sure you want to delete "${item.description}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: cashbookRed),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<TransactionBloc>().add(
            TransactionDeleted(item.id),
          );
    }
  }
}
