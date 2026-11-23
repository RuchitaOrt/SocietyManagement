
import 'package:flutter/material.dart';

import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';

import 'package:society_management/feature/society_setup/presentation/bloc/bank_account_model.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

Future<BankAccountModel?> showAddBankBottomSheet(
  BuildContext context,
) {
  return showModalBottomSheet<BankAccountModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddBankBottomSheet(),
  );
}

class _AddBankBottomSheet extends StatefulWidget {
  const _AddBankBottomSheet();

  @override
  State<_AddBankBottomSheet> createState() =>
      _AddBankBottomSheetState();
}

class _AddBankBottomSheetState extends State<_AddBankBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _bankNameController =
      TextEditingController(text: 'HDFC Bank');
  final _branchNameController =
      TextEditingController(text: 'Andheri West');
  final _accountHolderController =
      TextEditingController(text: 'Jainam Heights CHS Ltd');
  final _accountNumberController =
      TextEditingController(text: '123456789012');
  final _ifscController =
      TextEditingController(text: 'HDFC0001234');
  final _upiController =
      TextEditingController(text: 'jainam.society@okhdfcbank');
  final _openingBalanceController =
      TextEditingController(text: '0');

  bool _isDefaultBank = true;

  @override
  void dispose() {
    _bankNameController.dispose();
    _branchNameController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _upiController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  Widget _bankField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF44516A),
            ),
            const CommonText(
              text: ' *',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 7),
        CommonTextField(
          controller: controller,
          hintText: hint,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          maxLength: maxLength,
          validator: validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
        ),
      ],
    );
  }

  void _saveBank() {
    if (!_formKey.currentState!.validate()) return;

    final bank = BankAccountModel(
      bankName: _bankNameController.text.trim(),
      branchName: _branchNameController.text.trim(),
      accountHolderName: _accountHolderController.text.trim(),
      accountNumber: _accountNumberController.text.trim(),
      ifscCode: _ifscController.text.trim().toUpperCase(),
      upiId: _upiController.text.trim(),
      openingBalance: double.parse(
        _openingBalanceController.text.trim(),
      ),
      isDefault: _isDefaultBank,
    );

    Navigator.pop(context, bank);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFCE7F0),
                    Color(0xFFFFEBD9),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: CommonText(
                      text: 'Add Bank Account',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bankField(
                        label: 'Bank Name',
                        hint: 'e.g. State Bank of India',
                        controller: _bankNameController,
                      ),
                      const SizedBox(height: 16),

                      _bankField(
                        label: 'Branch Name',
                        hint: 'e.g. Andheri West',
                        controller: _branchNameController,
                      ),
                      const SizedBox(height: 16),

                      _bankField(
                        label: 'Account Holder Name',
                        hint: 'Name as per bank records',
                        controller: _accountHolderController,
                      ),
                      const SizedBox(height: 16),

                      _bankField(
                        label: 'Account Number',
                        hint: '9–18 digit account number',
                        controller: _accountNumberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter account number';
                          }
                          if (!RegExp(r'^[0-9]{9,18}$')
                              .hasMatch(value)) {
                            return 'Enter a valid account number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _bankField(
                        label: 'IFSC Code',
                        hint: 'e.g. SBIN0001234',
                        controller: _ifscController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter IFSC code';
                          }
                          if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
                              .hasMatch(value.toUpperCase())) {
                            return 'Enter a valid IFSC code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _bankField(
                        label: 'UPI ID',
                        hint: 'e.g. name@bank',
                        controller: _upiController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter UPI ID';
                          }
                          if (!RegExp(r'^[\w.\-]+@[\w.\-]+$')
                              .hasMatch(value)) {
                            return 'Enter a valid UPI ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _bankField(
                        label: 'Opening Balance (₹)',
                        hint: '0',
                        controller: _openingBalanceController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter opening balance';
                          }

                          final balance = double.tryParse(value);
                          if (balance == null || balance < 0) {
                            return 'Enter a valid balance';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity:
                            ListTileControlAffinity.leading,
                        activeColor: _primaryColor,
                        title: const CommonText(
                          text: 'Set as Default Collection Bank',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                        value: _isDefaultBank,
                        onChanged: (value) {
                          setState(() {
                            _isDefaultBank = value ?? false;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      CommonButton(
                        text: 'Save Bank Account',
                        icon: Icons.check_rounded,
                        onPressed: _saveBank,
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
}
