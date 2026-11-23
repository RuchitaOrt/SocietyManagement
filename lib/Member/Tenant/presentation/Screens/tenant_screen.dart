
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

import '../../data/tenant_repository.dart';
import '../bloc/tenant_bloc.dart';
import '../bloc/tenant_event.dart';
import '../bloc/tenant_state.dart';
import '../../domain/tenant_model.dart';

const Color primaryPink = Color(0xFFEC368E);
const Color lightPink = Color(0xFFFFF2F8);
const Color navyBlue = Color(0xFF233A60);
const Color mutedText = Color(0xFF7184A3);
const Color backgroundColor = Color(0xFFF4F6FA);
const Color borderColor = Color(0xFFE9EDF4);

class TenantScreen extends StatelessWidget {
  const TenantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NomineeBloc(
        repository: TenantRepositoryImpl(),
      )..add(TenantRequested()),
      child: const TenantView(),
    );
  }
}
class TenantView extends StatelessWidget {
  const TenantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: AdminColors.page,

      // APP BAR UNCHANGED
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  const LinearGradient(
                colors: [
                  Color(0xFFEC4899),
                  Color(0xFFF97316),
                ],
              ).createShader(bounds),
              child: const Text(
                'Tenants',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
                 'Tenant records linked to your flat | Ruchita | Flat 201 | A',
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
        actions: [],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          return Row(
            children: [
              if (isDesktop) const NomineeSidebar(),

              Expanded(
                child: Column(
                  children: [
                    // const NomineeTopBar(),
                    Expanded(
                      child: _buildMainContent(context, isDesktop),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    bool isDesktop,
  ) {
    return BlocBuilder<NomineeBloc, NomineeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 40 : 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildTitleSection(context, isDesktop),

              // const SizedBox(height: 28),

              if (state.status == NomineeStatus.loading &&
                  state.nominees.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: CircularProgressIndicator(
                      color: primaryPink,
                    ),
                  ),
                )
              else if (state.status == NomineeStatus.failure &&
                  state.nominees.isEmpty)
                _buildError(context, state)
              else if (state.nominees.isEmpty)
                _buildEmptyState()
              else
                _buildNomineeList(state.nominees, isDesktop),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleSection(
    BuildContext context,
    bool isDesktop,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 20 : 16,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nominees',
                  style: TextStyle(
                    fontSize: isDesktop ? 28 : 24,
                    fontWeight: FontWeight.w700,
                    color: primaryPink,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Nominee details linked to your account | '
                  'Ruchita | Flat 201 | A',
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          ElevatedButton.icon(
            onPressed: () {
              context.read<NomineeBloc>().add(
                    TenantRefreshed(),
                  );
            },
            icon: const Icon(
              Icons.refresh,
              size: 17,
            ),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPink,
              foregroundColor: Colors.white,
              elevation: 3,
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNomineeList(
    List<TenantModel> nominees,
    bool isDesktop,
  ) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: nominees.map((nominee) {
        return SizedBox(
          width: isDesktop ? 310 : double.infinity,
          child: NomineeCard(nominee: nominee),
        );
      }).toList(),
    );
  }

  Widget _buildError(
    BuildContext context,
    NomineeState state,
  ) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(state.errorMessage ?? 'Something went wrong'),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              context.read<NomineeBloc>().add(
                    TenantRequested(),
                  );
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 45,
              color: mutedText,
            ),
            SizedBox(height: 12),
            Text(
              'No nominees found',
              style: TextStyle(
                fontSize: 15,
                color: navyBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// NOMINEE CARD
// --------------------------------------------------

class NomineeCard extends StatelessWidget {
  final TenantModel nominee;

  const NomineeCard({
    super.key,
    required this.nominee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor.withOpacity(0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9F1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '#${nominee.id}',
                  style: const TextStyle(
                    color: primaryPink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: nominee.isActive
                      ? const Color(0xFFDCFBE8)
                      : const Color(0xFFFFE4E4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  nominee.isActive ? 'ACTIVE' : 'INACTIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: nominee.isActive
                        ? const Color(0xFF4E9470)
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            nominee.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF27364E),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            nominee.relationship,
            style: const TextStyle(
              fontSize: 12,
              color: mutedText,
            ),
          ),

          const SizedBox(height: 14),

          const Divider(
            height: 1,
            color: borderColor,
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nominee.mobile,
                style: const TextStyle(
                  fontSize: 11,
                  color: mutedText,
                ),
              ),
              Text(
                nominee.date,
                style: const TextStyle(
                  fontSize: 11,
                  color: mutedText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// SIDEBAR
// --------------------------------------------------

class NomineeSidebar extends StatelessWidget {
  const NomineeSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 282,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 8,
              bottom: 20,
            ),
            child: Row(
              children: [
                Text(
                  'MENU',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: navyBlue,
                    letterSpacing: 0.5,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.chevron_left,
                  size: 17,
                  color: navyBlue,
                ),
              ],
            ),
          ),

          Container(
            height: 43,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: lightPink,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: primaryPink,
                  size: 19,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Member Portal',
                    style: TextStyle(
                      color: primaryPink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_up,
                  color: primaryPink,
                  size: 19,
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          _menuItem('Overview', Icons.chevron_right),
          _menuItem('My Bills', Icons.chevron_right),
          _menuItem('Receipts', Icons.chevron_right),
          _menuItem('My Complaints', Icons.chevron_right),
          _menuItem('Notices', Icons.chevron_right),
          _menuItem('Tenants', Icons.chevron_right),

          _menuItem(
            'Nominees',
            Icons.chevron_right,
            selected: true,
          ),

          _menuItem('Visitor Pass', Icons.chevron_right),
          _menuItem('My Vehicles', Icons.chevron_right),

          const Spacer(),

          const Divider(color: borderColor),

          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Version 2.4.1',
                  style: TextStyle(
                    fontSize: 10,
                    color: navyBlue,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Help & Support',
                  style: TextStyle(
                    fontSize: 10,
                    color: navyBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    String title,
    IconData icon, {
    bool selected = false,
  }) {
    return Container(
      height: 37,
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: selected ? lightPink : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          if (selected)
            Container(
              width: 3,
              height: 28,
              decoration: BoxDecoration(
                color: primaryPink,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          else
            const SizedBox(width: 3),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? primaryPink : navyBlue,
                ),
              ),
            ),
          ),

          Icon(
            icon,
            size: 17,
            color: selected ? primaryPink : const Color(0xFF89A0C0),
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// TOP HEADER
// --------------------------------------------------

class NomineeTopBar extends StatelessWidget {
  const NomineeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: primaryPink,
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: const Text(
              'SM',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(width: 12),

          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Society Management',
                style: TextStyle(
                  color: Color(0xFF26354D),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.apartment,
                    size: 11,
                    color: mutedText,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Jainam',
                    style: TextStyle(
                      fontSize: 11,
                      color: mutedText,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.notifications_none,
              color: navyBlue,
              size: 22,
            ),
          ),

          const SizedBox(width: 15),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7FA),
              border: Border.all(
                color: const Color(0xFFFFB5D5),
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: primaryPink,
                  child: Text(
                    'R',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 9),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ruchita_5257',
                      style: TextStyle(
                        color: Color(0xFF27364E),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Member Mode - member',
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: mutedText,
                  size: 19,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
