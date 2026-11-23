
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:society_management/feature/cashbook/domain/transaction_model.dart';
import 'package:society_management/feature/cashbook/presentation/bloc/transaction_bloc.dart';
import 'package:society_management/feature/cashbook/presentation/bloc/transaction_event.dart';

const Color _pink = Color(0xFFE93691);
const Color _red = Color(0xFFEF3535);
const Color _text = Color(0xFF202B43);
const Color _hint = Color(0xFF91A0B8);
const Color _border = Color(0xFFDCE3EF);

Future<void> showBankTransferBottomSheet({
  required BuildContext context,
  required List<String> banks,
  required Function(Map<String, dynamic>) onSave,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => _CashbookEntrySheet(
      isTransfer: true,
      banks: banks,
      onSave: onSave,
    ),
  );
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
Future<void> showDebitEntryBottomSheet({
  required BuildContext context,
  required List<String> banks,
  required List<String> nonMembers,
  required List<String> categories,
  required Function(Map<String, dynamic>) onSave,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => _CashbookEntrySheet(
      isTransfer: false,
      banks: banks,
      nonMembers: nonMembers,
      categories: categories,
      onSave: onSave,
    ),
  );
}
class _CashbookEntrySheet extends StatefulWidget {
  final bool isTransfer;
  final List<String> banks;
  final List<String> nonMembers;
  final List<String> categories;
  final Function(Map<String, dynamic>) onSave;

  const _CashbookEntrySheet({
    required this.isTransfer,
    required this.banks,
    this.nonMembers = const [],
    this.categories = const [],
    required this.onSave,
  });

  @override
  State<_CashbookEntrySheet> createState() =>
      _CashbookEntrySheetState();
}

class _CashbookEntrySheetState extends State<_CashbookEntrySheet> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _chequeController = TextEditingController();
  final _referenceIdController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String? fromBank;
  String? toBank;
  String? paidTo;
  String? category;
  String? paymentMode = 'Cash';
  String? referenceType = 'None';

  Color get primaryColor => widget.isTransfer ? _pink : _red;

  @override
  void initState() {
    super.initState();
    _updateDateText();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _chequeController.dispose();
    _referenceIdController.dispose();
    super.dispose();
  }

  void _updateDateText() {
    _dateController.text =
        DateFormat('dd/MM/yyyy, hh:mm a').format(selectedDate);
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    if (time == null || !mounted) return;

    setState(() {
      selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _updateDateText();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isTransfer
        ? 'Add Bank Transfer Entry'
        : 'Add Debit Entry';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(title),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final columns = width >= 850
                          ? 3
                          : width >= 520
                              ? 2
                              : 1;

                      final spacing = 10.0;
                      final fieldWidth =
                          (width - (spacing * (columns - 1))) / columns;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: 10,
                        children: widget.isTransfer
                            ? _transferFields(fieldWidth, width)
                            : _debitFields(fieldWidth, width),
                      );
                    },
                  ),
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: widget.isTransfer
            ? Colors.white
            : const Color(0xFFFFEEEE),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFF0F1F5)),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: widget.isTransfer
                  ? Colors.transparent
                  : primaryColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              widget.isTransfer
                  ? Icons.swap_horiz
                  : Icons.arrow_downward,
              color: widget.isTransfer ? _text : Colors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _text,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: _hint,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _transferFields(double fieldWidth, double fullWidth) {
    return [
      SizedBox(
        width: fieldWidth,
        child: _textField(
          label: 'Amount',
          controller: _amountController,
          hint: '0.00',
          required: true,
          prefix: '₹',
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          validator: _validateAmount,
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: _dateField(),
      ),
      SizedBox(
        width: fieldWidth,
        child: _dropdown(
          label: 'From Bank',
          hint: 'Select bank to transfer from',
          value: fromBank,
          items: widget.banks,
          required: true,
          onChanged: (value) => setState(() => fromBank = value),
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: _dropdown(
          label: 'To Bank',
          hint: 'Select bank to transfer to',
          value: toBank,
          items: widget.banks,
          required: true,
          onChanged: (value) => setState(() => toBank = value),
        ),
      ),
      SizedBox(
        width: fullWidth,
        child: _textField(
          label: 'Description',
          controller: _descriptionController,
          hint: 'Enter transaction description...',
          required: true,
          maxLines: 2,
        ),
      ),
    ];
  }

  List<Widget> _debitFields(double fieldWidth, double fullWidth) {
    return [
      SizedBox(
        width: fieldWidth,
        child: _textField(
          label: 'Amount',
          controller: _amountController,
          hint: '0.00',
          required: true,
          prefix: '₹',
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          validator: _validateAmount,
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: _dateField(),
      ),
      SizedBox(
        width: fieldWidth,
        child: _dropdown(
          label: 'Paid To (Non-Member)',
          hint: 'Select Non-Member',
          value: paidTo,
          items: widget.nonMembers,
          onChanged: (value) => setState(() => paidTo = value),
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: _dropdown(
          label: 'Paid From Bank',
          hint: 'Select bank to deduct from',
          value: fromBank,
          items: widget.banks,
          required: true,
          onChanged: (value) => setState(() => fromBank = value),
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: _dropdown(
          label: 'Category (Expense Head)',
          hint: 'Select Category',
          value: category,
          items: widget.categories,
          required: true,
          onChanged: (value) => setState(() => category = value),
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: _dropdown(
          label: 'Payment Mode',
          hint: 'Select Payment Mode',
          value: paymentMode,
          items: const ['Cash', 'Bank Transfer', 'Cheque', 'UPI', 'Other'],
          onChanged: (value) => setState(() => paymentMode = value),
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: _textField(
          label: 'Cheque / Ref No.',
          controller: _chequeController,
          hint: 'Optional',
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: _dropdown(
          label: 'Reference Type',
          hint: 'Select Reference Type',
          value: referenceType,
          items: const ['None', 'Bill', 'Invoice', 'Receipt', 'Other'],
          onChanged: (value) => setState(() => referenceType = value),
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: _textField(
          label: 'Reference ID',
          controller: _referenceIdController,
          hint: 'e.g. Bill ID',
        ),
      ),
      SizedBox(
        width: fullWidth,
        child: _textField(
          label: 'Description',
          controller: _descriptionController,
          hint: 'Enter transaction description...',
          required: true,
          maxLines: 2,
        ),
      ),
    ];
  }

  Widget _dateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Date & Time', required: true),
        const SizedBox(height: 6),
        TextFormField(
          controller: _dateController,
          readOnly: true,
          onTap: _selectDateTime,
          style: const TextStyle(fontSize: 12, color: _text),
          decoration: _decoration(
            hint: 'Select date & time',
            suffix: const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: _hint,
            ),
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool required = false,
    String? prefix,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator ??
              (required
                  ? (value) => value == null || value.trim().isEmpty
                      ? 'Required'
                      : null
                  : null),
          style: const TextStyle(fontSize: 12, color: _text),
          decoration: _decoration(
            hint: hint,
            prefix: prefix,
          ),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool required = false,
  }) {
    final validValue =
        value != null && items.contains(value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: validValue,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: _hint,
            size: 18,
          ),
          style: const TextStyle(fontSize: 12, color: _text),
          decoration: _decoration(hint: hint),
          hint: Text(
            hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: _hint),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: _text),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: required
              ? (value) => value == null ? 'Required' : null
              : null,
        ),
      ],
    );
  }

  Widget _label(String label, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF43516B),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        children: [
          if (required)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _decoration({
    required String hint,
    String? prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: _hint,
        fontSize: 11,
      ),
      prefixText: prefix == null ? null : '$prefix  ',
      prefixStyle: const TextStyle(
        fontSize: 12,
        color: _hint,
      ),
      suffixIcon: suffix,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 11,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor),
      ),
      errorStyle: const TextStyle(fontSize: 9),
    );
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value.trim());
    if (amount == null || amount <= 0) {
      return 'Enter valid amount';
    }

    return null;
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF53627D),
              side: const BorderSide(color: _border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 11,
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _saveEntry,
            icon: const Icon(Icons.check, size: 14),
            label: const Text(
              'Save Entry',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveEntry() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.isTransfer && fromBank == toBank) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('From Bank and To Bank cannot be the same'),
        ),
      );
      return;
    }

    final data = <String, dynamic>{
      'amount': double.parse(_amountController.text.trim()),
      'dateTime': selectedDate.toIso8601String(),
      'description': _descriptionController.text.trim(),
    };

    if (widget.isTransfer) {
      data.addAll({
        'fromBank': fromBank,
        'toBank': toBank,
      });
    } else {
      data.addAll({
        'paidTo': paidTo,
        'paidFromBank': fromBank,
        'category': category,
        'paymentMode': paymentMode,
        'chequeReferenceNumber': _chequeController.text.trim(),
        'referenceType': referenceType,
        'referenceId': _referenceIdController.text.trim(),
      });
    }

    widget.onSave(data);
    Navigator.pop(context);
  }
}
