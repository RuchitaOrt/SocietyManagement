import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/core/DocumentCategory/Presentation/Screens/document_category_screen.dart';
import 'package:society_management/feature/AuditLogManagement/presentation/Screen/audit_log_screen.dart';
import 'package:society_management/feature/AuditLogManagement/presentation/bloc/AuditLogBloc/audit_log_bloc.dart';
import 'package:society_management/feature/Financial/presentation/Screen/FinancialScreen.dart';
import 'package:society_management/feature/LedgerManagement/presentation/Pages/ledger_screen.dart';
import 'package:society_management/feature/LedgerManagement/presentation/bloc/LedgerManagementBloc/ledger_bloc.dart';
import 'package:society_management/feature/ParkingSLot/Presentation/Screen/parking_slot_screen.dart';
import 'package:society_management/feature/SocietyMaster/presentation/Screen/SocietyMasterScreen.dart';
import 'package:society_management/feature/Vehicle/presentation/Screen/vehicle_screen.dart';
import 'package:society_management/feature/cashbook/presentation/bloc/transaction_bloc.dart';
import 'package:society_management/feature/cashbook/presentation/screens/cashbook_screen.dart';
import 'package:society_management/feature/society_setup/presentation/ComplaintManagement/complaint_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/BillingManagement/bill_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/UserManagement/presentation/Screen/role_master_screen.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/UserManagement/presentation/Screen/user_master_screen.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_event.dart';
import 'package:society_management/feature/society_setup/presentation/pages/SocietySetupScreen.dart';
import 'package:society_management/feature/society_setup/presentation/pages/VisitorManagementScreen.dart';
import 'package:society_management/feature/society_setup/presentation/pages/bill_management_screen.dart';
import 'package:society_management/feature/society_setup/presentation/pages/complaint_management_screen.dart';
import 'package:society_management/feature/society_setup/presentation/pages/society_staff_screen.dart';
import 'admin_main_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});
  void openSocietySetupEdit(BuildContext context, int step) {
  final bloc = context.read<SocietySetupBloc>();

  bloc.add(SocietySetupStepChanged(step));

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const SocietySetupScreen(isEditMode: true),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const Text(
            'More',
            style: TextStyle(
              color: AdminColors.text,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Society tools and administration',
            style: TextStyle(color: AdminColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFE5F1), Color(0xFFFFF0E4)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AdminColors.primary,
                  child: Icon(
                    Icons.apartment_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jainam Heights',
                        style: TextStyle(
                          color: AdminColors.text,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Admin account',
                        style: TextStyle(
                          color: AdminColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AdminColors.muted),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _MoreGroup(title: 'Dashboard', items: [
             
            ],
          ),
          const SizedBox(height: 18),
          _MoreGroup(
            title: 'User Management',
            items: [
              _MoreItem(
                Icons.apartment_rounded,
                'User Master',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserMasterScreen()),
                  );
                },
              ),
              _MoreItem(
                Icons.domain_rounded,
                'Roles',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RoleMasterScreen()),
                  );
                },
              ),
              _MoreItem(Icons.door_front_door_rounded, 'Permission'),
            ],
          ),
          const SizedBox(height: 18),
          _MoreGroup(
            title: 'Society Management',
            items: [
              _MoreItem(
                Icons.apartment_rounded,
                'Society Master',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SocietyMasterScreen(),
                    ),
                  );
                },
              ),
              _MoreItem(Icons.domain_rounded, 'Wing Master' ,onTap: () => openSocietySetupEdit(context, 2),),
              _MoreItem(Icons.door_front_door_rounded, 'Flat Master', onTap: () => openSocietySetupEdit(context, 3),),
              _MoreItem(Icons.groups_rounded, 'Member Master',onTap: () => openSocietySetupEdit(context, 4),),
              _MoreItem(Icons.groups_rounded, 'Non Member Master',  onTap: () => openSocietySetupEdit(context, 6),),
              _MoreItem(
                Icons.groups_rounded,
                'Parking Slots',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ParkingSlotScreen(),
                    ),
                  );
                },
              ),
              _MoreItem(
                Icons.groups_rounded,
                'Vehicles',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VehicleScreen()),
                  );
                },
              ),
              _MoreItem(
                Icons.groups_rounded,
                'Document Category Master',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DocumentCategoryScreen(),
                    ),
                  );
                },
              ),
              _MoreItem(Icons.groups_rounded, 'Document Verification'),
              _MoreItem(
                Icons.report_problem_rounded,
                'Complaint Master',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => ComplaintBloc(),
                        child: ComplaintManagementScreen(),
                      ),
                    ),
                  );
                },
              ),

              _MoreItem(Icons.groups_rounded, 'Notification Master'),
            ],
          ),
          _MoreGroup(
            title: 'Accounts & Finance',
            items: [
            _MoreItem(
  Icons.sell_outlined,
  'Bank Master',
  onTap: () {
    final bloc = context.read<SocietySetupBloc>();

    // Step 2 = index 1
    bloc.add(SocietySetupStepChanged(1));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const SocietySetupScreen(isEditMode: true),
        ),
      ),
    );
  },
),
              _MoreItem(Icons.category_outlined, 'Expense Master' ,onTap: () => openSocietySetupEdit(context, 8),),
              _MoreItem(Icons.calendar_month_rounded, 'Account Group Master'),
              _MoreItem(
                Icons.account_balance_rounded,
                'Ledger Master',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => LedgerBloc(),
                        child: const LedgerScreen(),
                      ),
                    ),
                  );
                },
              ),
              _MoreItem(Icons.account_balance_rounded, 'Head Master', onTap: () => openSocietySetupEdit(context, 7),),
            ],
          ),
          _MoreGroup(
            title: 'Billing & Transactions',
            items: [
              _MoreItem(
                Icons.sell_outlined,
                'Bill Generation',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => BillBloc(),
                        child: const BillManagementScreen(),
                      ),
                    ),
                  );
                },
              ),
          _MoreItem(
  Icons.category_outlined,
  'Transaction',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => TransactionBloc(),
          child: const CashbookScreen(),
        ),
      ),
    );
  },
),
              _MoreItem(Icons.calendar_month_rounded, 'Bank Book'),
              _MoreItem(Icons.account_balance_rounded, 'Push Tally'),
              _MoreItem(Icons.account_balance_rounded, 'Bill Configuration', onTap: () => openSocietySetupEdit(context, 9),),
            ],
          ),
          const SizedBox(height: 14),
          _MoreGroup(
            title: 'Financial Configuration',
            items: [
              _MoreItem(
                Icons.category_outlined,
                'Financial Year',
                onTap: () => openSocietySetupEdit(context, 5),
              ),
              _MoreItem(
                Icons.category_outlined,
                'Financial Month',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FinancialScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          _MoreGroup(
            title: 'Visitor Management',
            items: const [],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VisitorManagementScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          const _MoreGroup(
            title: 'Reports',
            items: [
              _MoreItem(Icons.bar_chart_rounded, 'maintenance'),
              _MoreItem(Icons.fact_check_outlined, 'Receipt-report'),
              _MoreItem(Icons.settings_outlined, 'Expense-report'),
              _MoreItem(Icons.help_outline_rounded, 'Member-ledger'),
              _MoreItem(Icons.help_outline_rounded, 'Outstanding-report'),
              _MoreItem(Icons.help_outline_rounded, 'Society-summary'),
            ],
          ),
          const SizedBox(height: 18),
          _MoreGroup(
            title: 'Audit Logs',
            items: [],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => AuditLogBloc(),
                    child: const AuditLogScreen(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          _MoreGroup(
            title: 'Society Staff',
            items: [],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SocietyStaffScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded, color: AdminColors.red),
            label: const Text(
              'Logout',
              style: TextStyle(
                color: AdminColors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              side: const BorderSide(color: AdminColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreGroup extends StatelessWidget {
  final String title;
  final List<_MoreItem> items;
  final VoidCallback? onTap;

  const _MoreGroup({
    super.key,
    required this.title,
    required this.items,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 13, 14, 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: AdminColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      color: AdminColors.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .6,
                    ),
                  ),
                ),
                if (onTap != null)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AdminColors.muted,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        ...items.map(
          (item) => ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(item.icon, color: AdminColors.primary, size: 21),
            title: Text(
              item.title,
              style: const TextStyle(
                color: AdminColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AdminColors.muted,
              size: 20,
            ),
            onTap: item.onTap,
          ),
        ),
      ],
    ),
  );

}

class _MoreItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _MoreItem(this.icon, this.title, {this.onTap});
}
