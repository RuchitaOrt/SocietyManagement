import 'package:flutter/material.dart';
import 'package:society_management/feature/LedgerManagement/presentation/bloc/LedgerManagementBloc/ledger_model.dart';

class AddLedgerBottomSheet extends StatefulWidget {
  final String societyName;

  const AddLedgerBottomSheet({
    super.key,
    required this.societyName,
  });

  @override
  State<AddLedgerBottomSheet> createState() =>
      _AddLedgerBottomSheetState();
}

class _AddLedgerBottomSheetState
    extends State<AddLedgerBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _ledgerNameController = TextEditingController();
  final _ledgerCodeController = TextEditingController();
  final _openingBalanceController =
      TextEditingController(text: '0');

  String? _accountGroup;
  String? _ledgerType = 'General Ledger';
  String? _balanceType = 'DR (Debit - Asset / Expense)';

  static const pink = Color(0xFFE72D87);
  static const navy = Color(0xFF24334D);
  static const borderColor = Color(0xFFDCE4EF);

  final List<String> _accountGroups = [
    'Bank Accounts (Asset)',
    'Cash Accounts (Asset)',
    'Current Assets',
    'Fixed Assets',
    'Current Liabilities',
    'Capital Account',
    'Income',
    'Expenses',
  ];

  final List<String> _ledgerTypes = [
    'General Ledger',
    'Cash',
    'Bank',
    'Customer',
    'Vendor',
  ];

  final List<String> _balanceTypes = [
    'DR (Debit - Asset / Expense)',
    'CR (Credit - Liability / Income)',
  ];

  @override
  void dispose() {
    _ledgerNameController.dispose();
    _ledgerCodeController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFB8C7DC),
        fontSize: 12,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
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
        borderSide: const BorderSide(color: pink),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _label(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Color(0xFF52627C),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          children: [
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: pink),
              ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13, color: navy),
          decoration: _decoration(hint),
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: true),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: _decoration('Select $label'),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Color(0xFF8796AB),
          ),
          style: const TextStyle(
            fontSize: 12,
            color: navy,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) =>
              value == null ? 'Please select $label' : null,
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: pink,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(color: Color(0xFFEAF0F7)),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final balance = double.tryParse(
      _openingBalanceController.text.trim(),
    );

    if (balance == null || balance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid opening balance'),
        ),
      );
      return;
    }

    final ledger = LedgerModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      society: widget.societyName,
      accountGroup: _accountGroup!,
      ledgerName: _ledgerNameController.text.trim(),
      ledgerCode: _ledgerCodeController.text.trim(),
      ledgerType: _ledgerType!,
      openingBalance: balance,
      balanceType: _balanceType!.startsWith('DR') ? 'DR' : 'CR',
    );

    Navigator.pop(context, ledger);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
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
                    Color(0xFFFFE8F1),
                    Color(0xFFFFEAD8),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Add Ledger',
                      style: TextStyle(
                        color: navy,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF9AA5B5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('SOCIETY'),
                      const SizedBox(height: 12),
                      _textField(
                        label: 'SOCIETY',
                        controller: TextEditingController(
                          text: widget.societyName,
                        ),
                        hint: 'Society name',
                        required: true,
                      ),
                      const SizedBox(height: 18),
                      _sectionTitle('LEDGER DETAILS'),
                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _dropdown(
                              label: 'ACCOUNT GROUP',
                              value: _accountGroup,
                              items: _accountGroups,
                              onChanged: (v) =>
                                  setState(() => _accountGroup = v),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _textField(
                              label: 'LEDGER NAME',
                              controller: _ledgerNameController,
                              hint: 'e.g. HDFC Current Account',
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _textField(
                              label: 'LEDGER CODE (OPTIONAL)',
                              controller: _ledgerCodeController,
                              hint: 'e.g. BANK-01',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _dropdown(
                              label: 'LEDGER TYPE',
                              value: _ledgerType,
                              items: _ledgerTypes,
                              onChanged: (v) =>
                                  setState(() => _ledgerType = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _textField(
                              label: 'OPENING BALANCE',
                              controller: _openingBalanceController,
                              hint: '0',
                              required: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _dropdown(
                              label: 'BALANCE TYPE (DR / CR)',
                              value: _balanceType,
                              items: _balanceTypes,
                              onChanged: (v) =>
                                  setState(() => _balanceType = v),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF52627C),
                      side: const BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Text(
                      'Create Ledger',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
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
}