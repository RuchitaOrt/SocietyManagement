
import 'package:flutter/material.dart';

const Color cashbookPink = Color(0xFFEC3E91);
const Color cashbookNavy = Color(0xFF17243B);
const Color cashbookMuted = Color(0xFF718096);
const Color cashbookBorder = Color(0xFFE4EAF2);
const Color cashbookGreen = Color(0xFF159957);
const Color cashbookRed = Color(0xFFE34B4B);
const Color cashbookBlue = Color(0xFF3478D4);

const Color _textColor = Color(0xFF202B43);

class CashbookSummaryData {
  final String title;
  final String amount;
  final String subtitle;
  final IconData icon;
  final Color color;

  const CashbookSummaryData({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

Widget buildSummaryCards({
  required String totalCredit,
  required String totalDebit,
  required String netBalance,
  required int creditCount,
  required int debitCount,
}) {
  final cards = [
    CashbookSummaryData(
      title: 'Total Credit',
      amount: totalCredit,
      subtitle: '$creditCount entries',
      icon: Icons.trending_up_rounded,
      color: cashbookGreen,
    ),
    CashbookSummaryData(
      title: 'Total Debit',
      amount: totalDebit,
      subtitle: '$debitCount entries',
      icon: Icons.trending_down_rounded,
      color: cashbookRed,
    ),
    CashbookSummaryData(
      title: 'Net Balance',
      amount: netBalance,
      subtitle: 'Current balance',
      icon: Icons.account_balance_wallet_outlined,
      color: cashbookBlue,
    ),
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: cards.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.3,
    ),
    itemBuilder: (context, index) {
      final item = cards[index];

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                item.icon,
                color: item.color,
                size: 19,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.amount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _textColor,
                    ),
                  ),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}


class CashbookSection extends StatelessWidget {
  final String title;
  final Widget child;

  const CashbookSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cashbookBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF20334D).withOpacity(.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: cashbookNavy,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}
