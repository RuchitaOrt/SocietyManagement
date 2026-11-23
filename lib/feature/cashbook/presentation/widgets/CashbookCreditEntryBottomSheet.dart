
import 'package:flutter/material.dart';

const Color creditGreen = Color(0xFF159957);
const Color creditNavy = Color(0xFF17243B);
const Color creditMuted = Color(0xFF718096);
const Color creditBorder = Color(0xFFE0E7F0);

void showCreditEntryBottomSheet({
  required BuildContext context,
  required List<String> members,
  required List<String> banks,
  required List<String> categories,
  required Function(Map<String, dynamic>) onSave,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CreditEntryBottomSheet(
      members: members,
      banks: banks,
      categories: categories,
      onSave: onSave,
    ),
  );
}

class CreditEntryBottomSheet extends StatefulWidget {
  final List<String> members;
  final List<String> banks;
  final List<String> categories;
  final Function(Map<String, dynamic>) onSave;

  const CreditEntryBottomSheet({
    super.key,
    required this.members,
    required this.banks,
    required this.categories,
    required this.onSave,
  });

  @override
  State<CreditEntryBottomSheet> createState() =>
      _CreditEntryBottomSheetState();
}

class _CreditEntryBottomSheetState
    extends State<CreditEntryBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;

  String? _selectedMember;
  String? _selectedBank;
  String? _selectedCategory;
  String _paymentMode = 'Cash';
  String _referenceType = 'None';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}, $hour:$minute $period';
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (time == null || !mounted) return;

    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _saveEntry() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      _showError('Please select an income category');
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    final data = <String, dynamic>{
      'amount': amount,
      'dateTime': _selectedDate.toIso8601String(),
      'receivedFrom': _selectedMember ?? '',
      'paidFromBank': _selectedBank ?? '',
      'category': _selectedCategory ?? '',
      'paymentMode': _paymentMode,
      'chequeReferenceNumber': _referenceController.text.trim(),
      'referenceType': _referenceType,
      'referenceId': '',
      'description': _descriptionController.text.trim(),
    };

    widget.onSave(data);

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .90,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _fieldLabel(
                              'Amount',
                              required: true,
                              child: TextFormField(
                                controller: _amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return 'Enter amount';
                                  }

                                  final amount =
                                      double.tryParse(value.trim());

                                  if (amount == null || amount <= 0) {
                                    return 'Invalid amount';
                                  }

                                  return null;
                                },
                                decoration: _inputDecoration(
                                  hint: '0.00',
                                  prefix: const Text('₹ '),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _fieldLabel(
                              'Date & Time',
                              required: true,
                              child: InkWell(
                                onTap: _pickDateTime,
                                child: InputDecorator(
                                  decoration: _inputDecoration(),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _formatDate(_selectedDate),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: creditNavy,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _fieldLabel(
                              'Received From (Member)',
                              child: _dropdown(
                                value: _selectedMember,
                                items: widget.members,
                                hint: 'Select Member',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMember = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _fieldLabel(
                              'Received In Bank',
                              child: _dropdown(
                                value: _selectedBank,
                                items: widget.banks,
                                hint: 'Select Bank (optional)',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBank = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _fieldLabel(
                              'Category (Income Head)',
                              required: true,
                              child: _dropdown(
                                value: _selectedCategory,
                                items: widget.categories,
                                hint: 'Select Category',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _fieldLabel(
                              'Payment Mode',
                              child: _simpleDropdown(
                                value: _paymentMode,
                                items: const [
                                  'Cash',
                                  'Bank Transfer',
                                  'Cheque',
                                  'UPI',
                                  'Card',
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _paymentMode = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _fieldLabel(
                              'Cheque / Ref No.',
                              child: TextFormField(
                                controller: _referenceController,
                                decoration: _inputDecoration(
                                  hint: 'Optional',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _fieldLabel(
                              'Reference Type',
                              child: _simpleDropdown(
                                value: _referenceType,
                                items: const [
                                  'None',
                                  'Bill',
                                  'Receipt',
                                  'Invoice',
                                  'Other',
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _referenceType = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      _fieldLabel(
                        'Description',
                        required: true,
                        child: TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Enter transaction description';
                            }
                            return null;
                          },
                          decoration: _inputDecoration(
                            hint: 'Enter transaction description...',
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: creditNavy,
                              side: const BorderSide(
                                color: creditBorder,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _saveEntry,
                            icon: const Icon(
                              Icons.check,
                              size: 16,
                            ),
                            label: const Text('Save Entry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: creditGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 17,
                                vertical: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 15,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFE6FAED),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: creditGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_upward_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Add Credit Entry',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: creditNavy,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
              color: creditMuted,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(
    String label, {
    bool required = false,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF475569),
              ),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration({
    String? hint,
    Widget? prefix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefix: prefix,
      hintStyle: const TextStyle(
        color: Color(0xFFB6C2D3),
        fontSize: 11,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 12,
      ),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: creditBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: creditBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: creditGreen),
      ),
      errorStyle: const TextStyle(fontSize: 10),
    );
  }

  Widget _dropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: _inputDecoration(),
      hint: Text(
        hint,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 11,
          color: creditNavy,
        ),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 18,
        color: Color(0xFF94A3B8),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _simpleDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: _inputDecoration(),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 18,
        color: Color(0xFF94A3B8),
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
    );
  }
}
