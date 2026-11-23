import 'package:flutter/material.dart';
import 'admin_main_screen.dart';
import '../widgets/dashboard_widgets.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const Text('Finance',
              style: TextStyle(
                  color: AdminColors.text,
                  fontSize: 23,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Track income, expenses and society dues',
              style: TextStyle(color: AdminColors.muted, fontSize: 12)),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: _FinanceMetric(
                    title: 'Income this month',
                    amount: '₹1.85 L',
                    icon: Icons.trending_up_rounded,
                    color: AdminColors.green),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _FinanceMetric(
                    title: 'Expenses',
                    amount: '₹62,500',
                    icon: Icons.trending_down_rounded,
                    color: AdminColors.red),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _FinanceMetric(
              title: 'Outstanding dues',
              amount: '₹48,500',
              icon: Icons.pending_actions_rounded,
              color: AdminColors.orange,
              fullWidth: true),
          const SizedBox(height: 18),
          SectionCard(
            title: 'Finance Modules',
            child: Column(
              children: const [
                _FinanceMenuTile(
                    icon: Icons.receipt_long_rounded,
                    title: 'Maintenance Bills',
                    subtitle: 'Create and manage monthly bills',
                    color: AdminColors.blue),
                _FinanceMenuTile(
                    icon: Icons.payments_rounded,
                    title: 'Payment Collection',
                    subtitle: 'Record and view member payments',
                    color: AdminColors.green),
                _FinanceMenuTile(
                    icon: Icons.money_off_csred_rounded,
                    title: 'Expense Management',
                    subtitle: 'Add and track society expenses',
                    color: AdminColors.primary),
                _FinanceMenuTile(
                    icon: Icons.account_balance_rounded,
                    title: 'Bank Accounts',
                    subtitle: 'Manage society bank details',
                    color: AdminColors.orange),
                _FinanceMenuTile(
                    icon: Icons.receipt_rounded,
                    title: 'Receipts',
                    subtitle: 'View and share payment receipts',
                    color: Color(0xFF8B5CF6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceMetric extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final bool fullWidth;

  const _FinanceMetric({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AdminColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(.12),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(amount,
                      style: const TextStyle(
                          color: AdminColors.text,
                          fontSize: 19,
                          fontWeight: FontWeight.w800)),
                  Text(title,
                      style: const TextStyle(
                          color: AdminColors.muted, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _FinanceMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _FinanceMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 3),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.11),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                color: AdminColors.text,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AdminColors.muted, fontSize: 10)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AdminColors.muted),
        onTap: () {},
      );
}
