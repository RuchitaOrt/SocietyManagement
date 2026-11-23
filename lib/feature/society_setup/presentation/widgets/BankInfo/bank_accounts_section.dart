
import 'package:flutter/material.dart';

import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/bank_account_model.dart';

class BankAccountsSection extends StatelessWidget {
  final List<BankAccountModel> accounts;
  final ValueChanged<int> onRemove;

  const BankAccountsSection({
    super.key,
    required this.accounts,
    required this.onRemove,
  });

  static const Color primaryColor = Color(0xFFE93691);
  static const Color textColor = Color(0xFF202B43);
  static const Color hintColor = Color(0xFF91A0B8);

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 35,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EDF4)),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.account_balance_rounded,
              size: 42,
              color: primaryColor,
            ),
            SizedBox(height: 12),
            CommonText(
              text: 'No Bank Account Added',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            SizedBox(height: 6),
            CommonText(
              text: 'Tap Add Bank to add your society bank account.',
              fontSize: 12,
              color: hintColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(accounts.length, (index) {
        final account = accounts[index];

        final number = account.accountNumber;
        final maskedNumber = number.length > 4
            ? '•••• ${number.substring(number.length - 4)}'
            : number;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: account.isDefault
                  ? primaryColor.withOpacity(0.4)
                  : const Color(0xFFE8EDF4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEDF5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: account.bankName,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        CommonText(
                          text: account.branchName,
                          fontSize: 11,
                          color: hintColor,
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
              ),
              const Divider(height: 24),
              _infoRow('Account Holder', account.accountHolderName),
              _infoRow('Account Number', maskedNumber),
              _infoRow('IFSC Code', account.ifscCode),
              _infoRow('UPI ID', account.upiId),
              _infoRow(
                'Opening Balance',
                '₹${account.openingBalance.toStringAsFixed(2)}',
              ),
              if (account.isDefault) ...[
                const SizedBox(height: 12),
                const CommonText(
                  text: '✓ Default Collection Bank',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF219653),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              text: label,
              fontSize: 11,
              color: hintColor,
            ),
          ),
          Expanded(
            child: CommonText(
              text: value,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
