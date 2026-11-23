import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../bloc/BillingManagement/bill_model.dart';

const Color billPrimary = Color(0xFFE93691);

Future<List<BillModel>?> showGenerateBillsBottomSheet({
  required BuildContext context,
  required String societyName,
}) {
  return showModalBottomSheet<List<BillModel>>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => GenerateBillsBottomSheet(
      societyName: societyName,
    ),
  );
}

class GenerateBillsBottomSheet extends StatefulWidget {
  final String societyName;

  const GenerateBillsBottomSheet({
    super.key,
    required this.societyName,
  });

  @override
  State<GenerateBillsBottomSheet> createState() =>
      _GenerateBillsBottomSheetState();
}

class _GenerateBillsBottomSheetState
    extends State<GenerateBillsBottomSheet> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController societyController;
  late TextEditingController dueDaysController;
  late TextEditingController arrearsController;
  late TextEditingController discountController;
  late TextEditingController remarkController;

  String financialYear = '2026-2027';
  String financialMonth = 'November';

  DateTime billDate = DateTime.now();

  final List<_HeadRow> rows = [];

  static const Color textColor = Color(0xFF202B43);
  static const Color hintColor = Color(0xFF91A0B8);
  static const Color borderColor = Color(0xFFDCE4EF);

  @override
  void initState() {
    super.initState();

    societyController = TextEditingController(
      text: widget.societyName,
    );

    dueDaysController = TextEditingController(text: '2');
    arrearsController = TextEditingController(text: '0');
    discountController = TextEditingController(text: '0');
    remarkController = TextEditingController();

    rows.add(_HeadRow());
  }

  InputDecoration decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFFBCC9DA),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: billPrimary),
      ),
    );
  }

  Widget label(String title, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Color(0xFF53647C),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(text: title),
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget field({
    required String title,
    required TextEditingController controller,
    String hint = '',
    bool required = false,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label(title, required: required),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          decoration: decoration(hint),
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter $title';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget dropdown({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label(title, required: true),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: decoration('Select $title'),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: hintColor,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 12,
                  color: textColor,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  double get subtotal {
    return rows.fold(
      0,
      (sum, row) => sum + (double.tryParse(row.amount.text) ?? 0),
    );
  }

  double get arrears =>
      double.tryParse(arrearsController.text) ?? 0;

  double get discount =>
      double.tryParse(discountController.text) ?? 0;

  double get total => subtotal + arrears - discount;

  String get dateText =>
      '${billDate.day.toString().padLeft(2, '0')}/'
      '${billDate.month.toString().padLeft(2, '0')}/'
      '${billDate.year}';

  Future<void> pickBillDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: billDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: billPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (result != null && mounted) {
      setState(() => billDate = result);
    }
  }

  void addRow() {
    setState(() => rows.add(_HeadRow()));
  }

  void removeRow(int index) {
    if (rows.length == 1) return;

    setState(() {
      rows[index].dispose();
      rows.removeAt(index);
    });
  }

  Widget _maintenanceRows() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFF7F9FC),
            border: Border(
              top: BorderSide(color: borderColor),
              left: BorderSide(color: borderColor),
              right: BorderSide(color: borderColor),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  'MAINTENANCE HEAD',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF617792),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'CHARGE TYPE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF617792),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'BASE AMOUNT (₹)',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF617792),
                  ),
                ),
              ),
            ],
          ),
        ),
        ...rows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;

          return Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: borderColor),
                left: BorderSide(color: borderColor),
                right: BorderSide(color: borderColor),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: DropdownButtonFormField<String>(
                    value: row.head,
                    isExpanded: true,
                    decoration: decoration('Select Head'),
                    items: [
                      'Maintenance',
                      'Parking',
                      'Tenant',
                      'Amenity',
                      'Water',
                      'Electricity',
                      'Other',
                    ].map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => row.head = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: row.chargeType,
                    isExpanded: true,
                    decoration: decoration(''),
                    items: ['Fixed', 'Per Sq Ft', 'Per Vehicle']
                        .map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => row.chargeType = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: row.amount,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*'),
                      ),
                    ],
                    onChanged: (_) => setState(() {}),
                    decoration: decoration('0'),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => removeRow(index),
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 17,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          );
        }),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFF7F9FC),
            border: Border(
              top: BorderSide(color: borderColor),
              bottom: BorderSide(color: borderColor),
              left: BorderSide(color: borderColor),
              right: BorderSide(color: borderColor),
            ),
          ),
          child: OutlinedButton.icon(
            onPressed: addRow,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Row'),
            style: OutlinedButton.styleFrom(
              foregroundColor: billPrimary,
              side: const BorderSide(
                color: Color(0xFFF5C6DE),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _periodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PERIOD & DATES',
          style: TextStyle(
            color: billPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 700;
            final itemWidth = wide
                ? (constraints.maxWidth - 30) / 4
                : constraints.maxWidth;

            return Wrap(
              spacing: 10,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: itemWidth,
                  child: dropdown(
                    title: 'Financial Year',
                    value: financialYear,
                    items: [
                      '2025-2026',
                      '2026-2027',
                      '2027-2028',
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => financialYear = value);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: dropdown(
                    title: 'Financial Month',
                    value: financialMonth,
                    items: [
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
                      if (value != null) {
                        setState(() => financialMonth = value);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label('Bill Date', required: true),
                      InkWell(
                        onTap: pickBillDate,
                        child: InputDecorator(
                          decoration: decoration(''),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  dateText,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: field(
                    title: 'Due In (Days)',
                    controller: dueDaysController,
                    required: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _totalsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _amountField(
                title: 'Arrears (₹)',
                controller: arrearsController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _amountField(
                title: 'Discount (₹)',
                controller: discountController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _totalRow('Subtotal', subtotal),
              const SizedBox(height: 8),
              _totalRow('Arrears', arrears),
              const SizedBox(height: 8),
              _totalRow('Discount', discount),
              const Divider(height: 20),
              _totalRow(
                'Total Amount',
                total,
                bold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _amountField({
    required String title,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label(title),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d*\.?\d*'),
            ),
          ],
          onChanged: (_) => setState(() {}),
          decoration: decoration('0'),
        ),
      ],
    );
  }

  Widget _totalRow(
    String title,
    double amount, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: textColor,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: bold ? 15 : 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _remarkField() {
    return field(
      title: 'Remark',
      controller: remarkController,
      hint: 'Enter billing remark (optional)',
      maxLines: 3,
    );
  }

  Widget _configurationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        field(
          title: 'Society',
          controller: societyController,
          readOnly: true,
        ),
        const SizedBox(height: 20),
        _periodSection(),
        const SizedBox(height: 20),
        const Text(
          'MAINTENANCE CHARGES',
          style: TextStyle(
            color: billPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFBFDBFE),
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFF2563EB),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Standard heads loaded from Head Master. '
                  'Parking applied only to flats with vehicles. '
                  'Tenant charges applied only to tenant members. '
                  'Amenity/facility charges are automatically '
                  'added only for members with approved bookings.',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _maintenanceRows(),
        const SizedBox(height: 18),
        _totalsSection(),
        const SizedBox(height: 18),

        // REMARK AT THE END OF FORM
        _remarkField(),
      ],
    );
  }

  List<BillModel> _createBills() {
    return [
      BillModel(
        society: widget.societyName,
        financialYear: financialYear,
        financialMonth: financialMonth,
        billDate: billDate,
        dueDays: int.tryParse(dueDaysController.text) ?? 0,
        maintenanceHeads: rows.map((row) {
          return MaintenanceHeadModel(
            head: row.head,
            chargeType: row.chargeType,
            baseAmount: double.tryParse(row.amount.text) ?? 0,
          );
        }).toList(),
        arrears: arrears,
        discount: discount,
        remark: remarkController.text.trim(),
      ),
    ];
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (dueDaysController.text.trim().isEmpty) {
      return;
    }

    if (total < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Discount cannot exceed total charges'),
        ),
      );
      return;
    }

    Navigator.pop(context, _createBills());
  }

  void preview() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bill Preview'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Society: ${widget.societyName}'),
              Text('Year: $financialYear'),
              Text('Month: $financialMonth'),
              Text('Bill Date: $dateText'),
              const Divider(),
              ...rows.map((row) {
                return Text(
                  '${row.head} (${row.chargeType}): '
                  '₹${double.tryParse(row.amount.text) ?? 0}',
                );
              }),
              const Divider(),
              Text('Subtotal: ₹${subtotal.toStringAsFixed(2)}'),
              Text('Arrears: ₹${arrears.toStringAsFixed(2)}'),
              Text('Discount: ₹${discount.toStringAsFixed(2)}'),
              Text('Total: ₹${total.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              Text('Remark: ${remarkController.text}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    societyController.dispose();
    dueDaysController.dispose();
    arrearsController.dispose();
    discountController.dispose();
    remarkController.dispose();

    for (final row in rows) {
      row.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isWide = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(18),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 15,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFCE8F1),
                      Color(0xFFFFEFDC),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Row(
                        children: [
                          Text(
                            'Generate Bills',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 10),
                          _BulkBadge(),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: _configurationContent(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(
                  16, 12, 16, 14,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 2,
                  runSpacing: 4,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    OutlinedButton(
                      onPressed: preview,
                      child: const Text('Preview'),
                    ),
                    ElevatedButton.icon(
                      onPressed: submit,
                      icon: const Icon(
                        Icons.download_rounded,
                        size: 16,
                      ),
                      label: const Text('Generate Bulk Bills'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: billPrimary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulkBadge extends StatelessWidget {
  const _BulkBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE7F3),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFFF9A8D4),
        ),
      ),
      child: const Text(
        'Bulk — All Flats',
        style: TextStyle(
          fontSize: 10,
          color: billPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HeadRow {
  String head = 'Maintenance';
  String chargeType = 'Fixed';
  final TextEditingController amount =
      TextEditingController(text: '0');

  void dispose() => amount.dispose();
}