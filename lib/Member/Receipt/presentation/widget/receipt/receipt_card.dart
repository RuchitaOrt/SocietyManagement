
import 'package:flutter/material.dart';
import 'package:society_management/Member/Receipt/presentation/bloc/ReceiptModel.dart';


class ReceiptCard extends StatelessWidget {
  final ReceiptModel receipt;
  final VoidCallback onTap;

  const ReceiptCard({
    super.key,
    required this.receipt,
    required this.onTap,
  });

  static const primary = Color(0xFFEF1685);
  static const navy = Color(0xFF18264B);
  static const muted = Color(0xFF8793AA);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFECEBF3),
        ),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8F3),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: primary,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Receipt Number',
                      style: TextStyle(
                        fontSize: 11,
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      receipt.receiptNumber,
                      style: const TextStyle(
                        fontSize: 13,
                        color: navy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(receipt.status),
            ],
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              Expanded(
                child: _detail(
                  'Bill Number',
                  receipt.billNumber,
                  Icons.description_outlined,
                ),
              ),
              Expanded(
                child: _detail(
                  'Payment Date',
                  receipt.date,
                  Icons.calendar_month_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              Expanded(
                child: _detail(
                  'Payment Mode',
                  receipt.paymentMode,
                  Icons.account_balance_wallet_outlined,
                ),
              ),
              Expanded(
                child: _detail(
                  'Amount Paid',
                  '₹${receipt.amount.toStringAsFixed(2)}',
                  Icons.currency_rupee_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Divider(
            color: Colors.grey.shade200,
            height: 1,
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                color: Color(0xFF26A269),
                size: 17,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Payment successful',
                  style: TextStyle(
                    color: Color(0xFF26A269),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: const [
                    Text(
                      'View details',
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: primary,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detail(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: muted),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: muted,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    final paid = status.toLowerCase() == 'paid';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: paid
            ? const Color(0xFFE8F8EF)
            : const Color(0xFFFFF1E7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: paid
              ? const Color(0xFF269B61)
              : const Color(0xFFE58A35),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
