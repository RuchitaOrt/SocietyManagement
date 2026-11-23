
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../bloc/ExpenseCategoryModel.dart';

const Color primaryColor = Color(0xFFE93691);

Future<ExpenseCategoryModel?> showAddExpenseCategoryBottomSheet({
  required BuildContext context,
  List<String> accountGroups = const [],
}) {
  return showModalBottomSheet<ExpenseCategoryModel>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return AddExpenseCategoryBottomSheet(
        accountGroups: accountGroups,
      );
    },
  );
}

class AddExpenseCategoryBottomSheet extends StatefulWidget {
  final List<String> accountGroups;

  const AddExpenseCategoryBottomSheet({
    super.key,
    this.accountGroups = const [],
  });

  @override
  State<AddExpenseCategoryBottomSheet> createState() =>
      _AddExpenseCategoryBottomSheetState();
}

class _AddExpenseCategoryBottomSheetState
    extends State<AddExpenseCategoryBottomSheet> {

  final _formKey = GlobalKey<FormState>();

  final expenseNameController = TextEditingController();
  final expenseCodeController = TextEditingController();

  String? selectedAccountGroup;

  static const Color textColor = Color(0xFF202B43);
  static const Color hintColor = Color(0xFF91A0B8);
  static const Color borderColor = Color(0xFFDCE4EF);

  Widget _label(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 13,
        color: Color(0xFFBCC9DA),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
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
        borderSide: const BorderSide(color: primaryColor),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Expense Name', required: true),
        const SizedBox(height: 7),

        TextFormField(
          controller: expenseNameController,
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter expense name';
            }
            return null;
          },
          decoration: _decoration('e.g. Electricity'),
        ),
      ],
    );
  }

  Widget _buildCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Expense Code', required: true),
        const SizedBox(height: 7),

        TextFormField(
          controller: expenseCodeController,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp('[a-zA-Z]'),
            ),
            LengthLimitingTextInputFormatter(10),
            _UpperCaseTextFormatter(),
          ],
          validator: (value) {
            final code = value?.trim() ?? '';

            if (code.isEmpty) {
              return 'Please enter expense code';
            }

            if (!RegExp(r'^[A-Z]{2,10}$').hasMatch(code)) {
              return 'Use 2-10 uppercase letters';
            }

            return null;
          },
          decoration: _decoration('e.g. ELEC'),
        ),

        const SizedBox(height: 6),

        const Text(
          '2-10 uppercase letters only',
          style: TextStyle(
            fontSize: 11,
            color: hintColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Account Group (Optional)'),
        const SizedBox(height: 7),

        DropdownButtonFormField<String>(
          value: selectedAccountGroup,
          isExpanded: true,
          hint: const Text(
            '-- Select Account Group --',
            style: TextStyle(
              fontSize: 12,
              color: textColor,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: primaryColor,
          ),
          decoration: _decoration(''),
          items: widget.accountGroups.map((group) {
            return DropdownMenuItem<String>(
              value: group,
              child: Text(
                group,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: widget.accountGroups.isEmpty
              ? null
              : (value) {
                  setState(() {
                    selectedAccountGroup = value;
                  });
                },
        ),
      ],
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.pop(
      context,
      ExpenseCategoryModel(
        expenseName: expenseNameController.text.trim(),
        expenseCode: expenseCodeController.text.trim().toUpperCase(),
        accountGroup: selectedAccountGroup,
      ),
    );
  }

  @override
  void dispose() {
    expenseNameController.dispose();
    expenseCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: screenHeight * 0.85,
          ),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // HEADER
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 13,
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
                        child: Text(
                          'Add Expense Category',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ),

                // FORM
                Flexible(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      16, 16, 16, 12,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildNameField(),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildCodeField(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          _buildAccountGroup(),
                        ],
                      ),
                    ),
                  ),
                ),

                // BOTTOM BUTTONS
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    16, 10, 16, 12,
                  ),
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
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            foregroundColor: primaryColor,
                            side: const BorderSide(
                              color: primaryColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 44),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: const Text(
                            'Add Expense Category',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                  const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
