import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/LedgerManagement/presentation/bloc/LedgerManagementBloc/ledger_bloc.dart';
import 'package:society_management/feature/LedgerManagement/presentation/bloc/LedgerManagementBloc/ledger_event.dart';
import 'package:society_management/feature/LedgerManagement/presentation/bloc/LedgerManagementBloc/ledger_model.dart';
import 'package:society_management/feature/LedgerManagement/presentation/bloc/LedgerManagementBloc/ledger_state.dart';
import 'package:society_management/feature/LedgerManagement/presentation/widget/add_ledger_bottom_sheet.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  static const pink = Color(0xFFE72D87);
  static const navy = Color(0xFF24334D);

  Future<void> _openAddLedger(
    BuildContext context,
  ) async {
    // Replace with the society name from your existing
    // SocietySetupBloc / logged-in society data.
    const societyName = 'Jainam';

    final ledger = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddLedgerBottomSheet(
        societyName: societyName,
      ),
    );

    if (ledger != null && context.mounted) {
      context.read<LedgerBloc>().add(
            LedgerCreated(ledger),
          );
    }
  }

  Widget _summaryCard({
    required IconData icon,
    required String count,
    required String title,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF71819A),
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

  Widget _statusBadge(bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFD9F8E9)
            : const Color(0xFFFFE5E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? 'ACTIVE' : 'INACTIVE',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: active
              ? const Color(0xFF0BA968)
              : Colors.red,
        ),
      ),
    );
  }
Widget _buildLedgerCard(
  LedgerModel ledger,
  int index,
  BuildContext context,
) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFE8EDF4),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // NAME + STATUS
        Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                color: pink,
                size: 19,
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ledger.ledgerName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),
                  if (ledger.ledgerCode.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        'Code: ${ledger.ledgerCode}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8796AB),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            _statusBadge(ledger.isActive),
          ],
        ),

        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFEAF0F7)),
        const SizedBox(height: 12),

        // ACCOUNT GROUP
        _ledgerInfoRow(
          icon: Icons.account_tree_outlined,
          label: 'Account Group',
          value: ledger.accountGroup,
        ),

        const SizedBox(height: 10),

        // LEDGER TYPE
        _ledgerInfoRow(
          icon: Icons.category_outlined,
          label: 'Ledger Type',
          value: ledger.ledgerType,
        ),

        const SizedBox(height: 10),

        // OPENING BALANCE
        _ledgerInfoRow(
          icon: Icons.currency_rupee_rounded,
          label: 'Opening Balance',
          value:
              '₹ ${ledger.openingBalance.toStringAsFixed(2)} ${ledger.balanceType}',
          valueColor: pink,
          isBold: true,
        ),

        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFEAF0F7)),
        const SizedBox(height: 8),

        // ACTIONS
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                context.read<LedgerBloc>().add(
                      LedgerStatusChanged(
                        id: ledger.id,
                        isActive: !ledger.isActive,
                      ),
                    );
              },
              icon: Icon(
                ledger.isActive
                    ? Icons.toggle_on_outlined
                    : Icons.toggle_off_outlined,
                size: 18,
              ),
              label: Text(
                ledger.isActive ? 'Deactivate' : 'Activate',
                style: const TextStyle(fontSize: 11),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
              ),
            ),

            const SizedBox(width: 6),

            IconButton(
              tooltip: 'Delete Ledger',
              visualDensity: VisualDensity.compact,
              onPressed: () {
                _confirmDeleteLedger(context, ledger);
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 19,
                color: Color(0xFF8796AB),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
Widget _ledgerInfoRow({
  required IconData icon,
  required String label,
  required String value,
  Color? valueColor,
  bool isBold = false,
}) {
  return Row(
    children: [
      Icon(
        icon,
        size: 15,
        color: const Color(0xFF8796AB),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF71819A),
          ),
        ),
      ),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? navy,
          ),
        ),
      ),
    ],
  );
}
Widget _buildLedgerEmptyState(bool isCompletelyEmpty) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 35),
    child: Center(
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 40,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          Text(
            isCompletelyEmpty
                ? 'No Ledger Found'
                : 'No Matching Ledger Found',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: navy,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Ledger details will appear here.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF8796AB),
            ),
          ),
        ],
      ),
    ),
  );
}
void _confirmDeleteLedger(
  BuildContext context,
  LedgerModel ledger,
) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete Ledger'),
        content: Text(
          'Are you sure you want to delete "${ledger.ledgerName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<LedgerBloc>().add(
                    LedgerDeleted(ledger.id),
                  );
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pink,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
Widget _buildLedgerCards(
  List<LedgerModel> filteredLedgers,
  List<LedgerModel> allLedgers,
  BuildContext context,
) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION HEADER
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFE8F1),
                Color(0xFFFFEBD8),
              ],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(14),
            ),
          ),
          child: const Text(
            'Ledger List',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: navy,
            ),
          ),
        ),

        // EMPTY STATE
        if (filteredLedgers.isEmpty)
          _buildLedgerEmptyState(allLedgers.isEmpty)

        // LEDGER CARDS
        else
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: List.generate(
                filteredLedgers.length,
                (index) {
                  final ledger = filteredLedgers[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildLedgerCard(
                      ledger,
                      index,
                      context,
                    ),
                  );
                },
              ),
            ),
          ),

        // FOOTER
        if (filteredLedgers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Text(
              'Showing 1-${filteredLedgers.length} of ${allLedgers.length}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
            ),
          ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LedgerBloc, LedgerState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor:  AdminColors.page,
       floatingActionButton: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton.extended(
      heroTag: 'addCategory',
      onPressed: ()
      {_openAddLedger(context);}
      ,
      backgroundColor: const Color(0xFFE93691),
      icon: const Icon(Icons.category_outlined, color: Colors.white),
      label: const Text(
        'Add Ledger',
        style: TextStyle(color: Colors.white),
      ),
    ),
    
  ],
),
     appBar: AppBar(
  title: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            Color(0xFFEC4899),
            Color(0xFFF97316),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: const Text(
         'Ledger Master',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
        
 
      const SizedBox(height: 3),
      Text(
        "Manage chart of account ledgers for double-entry society bookkeeping",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade600,
        ),
      ),
    ],
  ),
 
  backgroundColor: AdminColors.page,
  elevation: 0,
  actions: [
    IconButton(
      onPressed: () {
        // TODO: Navigate to Notifications Screen
      },
      icon: const Icon(
        Icons.notifications_none_rounded,
        color: Color(0xFFEC4899),
        size: 25,
      ),
      tooltip: 'Notifications',
    ),
    const SizedBox(width: 6),
  ],
),
          
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                

                  Row(
                    children: [
                      _summaryCard(
                        icon: Icons.receipt_long_outlined,
                        count: '${state.totalLedgers}',
                        title: 'Total Ledgers',
                        iconColor: pink,
                        backgroundColor:
                            const Color(0xFFFFF0F6),
                      ),
                      const SizedBox(width: 12),
                      _summaryCard(
                        icon: Icons.check_circle_outline,
                        count: '${state.activeLedgers}',
                        title: 'Active',
                        iconColor: pink,
                        backgroundColor:
                            const Color(0xFFFFF0F6),
                      ),
                      const SizedBox(width: 12),
                      _summaryCard(
                        icon: Icons.cancel_outlined,
                        count: '${state.inactiveLedgers}',
                        title: 'Inactive',
                        iconColor: Colors.orange,
                        backgroundColor:
                            const Color(0xFFFFF4D5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: 350,
                    child: TextField(
                      onChanged: (value) {
                        context.read<LedgerBloc>().add(
                              LedgerSearchChanged(value),
                            );
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by ledger, group or code...',
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB8C7DC),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 19,
                          color: Color(0xFFB8C7DC),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFDCE4EF),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFDCE4EF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Expanded(
  child: SingleChildScrollView(
    child: _buildLedgerCards(
      state.filteredLedgers,
      state.ledgers,
      context,
    ),
  ),
),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}