
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_event.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_state.dart';
import 'package:society_management/feature/society_setup/presentation/pages/SocietySetupScreen.dart';

const Color primaryColor = Color(0xFFE93691);
const Color orangeColor = Color(0xFFF97316);
const Color pageColor = Color(0xFFF5F7FA);
const Color textColor = Color(0xFF25324B);
const Color mutedColor = Color(0xFF71809A);
const Color borderColor = Color(0xFFE5EAF2);

class SocietyMasterScreen extends StatelessWidget {
  final VoidCallback? onEdit;

  const SocietyMasterScreen({
    super.key,
    this.onEdit,
  });

  static const Color pink = Color(0xFFEC4899);
  static const Color orange = Color(0xFFFF795B);
  static const Color navy = Color(0xFF25324A);
  static const Color muted = Color(0xFF71829F);
  static const Color background = Color(0xFFF4F6FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AdminColors.page,

     appBar: AppBar(
  centerTitle: false,
  backgroundColor: AdminColors.page,
  surfaceTintColor: AdminColors.page,
  elevation: 0,
  titleSpacing: 18,
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [primaryColor, orangeColor],
        ).createShader(bounds),
        child: const Text(
          'Society Master',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      const SizedBox(height: 3),
      const Text(
        'View and manage your society information',
        style: TextStyle(
          color: mutedColor,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  ),
),
      body: BlocBuilder<SocietySetupBloc, SocietySetupState>(
        builder: (context, state) {
          debugPrint('========== SOCIETY MASTER DEBUG ==========');
debugPrint('Society Name: ${state.societyName}');
debugPrint('Address: ${state.address}');
debugPrint('City: ${state.city}');
debugPrint('State: ${state.state}');
debugPrint('Pincode: ${state.pincode}');
debugPrint('Registration: ${state.registrationNumber}');
debugPrint('PAN: ${state.panNumber}');
debugPrint('Completed Steps: ${state.completedSteps}');
debugPrint('==========================================');
          final hasSociety =
              state.completedSteps.contains(0) &&
              state.societyName.trim().isNotEmpty;

          if (!hasSociety) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildHeading(),

                // const SizedBox(height: 22),

                _buildSocietyCount(),

                const SizedBox(height: 22),

                Row(
                  children: [
                    const Text(
                      'Society Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F8EF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Color(0xFF10B981),
                            size: 13,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'SAVED',
                            style: TextStyle(
                              color: Color(0xFF059669),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _buildSocietyCard(context, state),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [pink, orange],
            ).createShader(bounds);
          },
          child: const Text(
            'Society Master',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'View and manage your society information',
          style: TextStyle(
            color: muted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildSocietyCount() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEF6),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: pink,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
                Text(
                  'Society Profile',
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
            color: Color(0xFFB6C2D2),
          ),
        ],
      ),
    );
  }

  Widget _buildSocietyCard(
    BuildContext context,
    SocietySetupState state,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE9EDF3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFE5F0),
                  Color(0xFFFFEEDC),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    color: pink,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.societyName,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Society Information
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GENERAL INFORMATION',
                  style: TextStyle(
                    color: muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 17),

                _detailItem(
                  icon: Icons.confirmation_number_outlined,
                  title: 'Registration Number',
                  value: state.registrationNumber,
                ),

                _detailItem(
                  icon: Icons.location_on_outlined,
                  title: 'Address',
                  value: state.address,
                ),

                _detailItem(
                  icon: Icons.location_city_outlined,
                  title: 'City',
                  value: state.city,
                ),

                _detailItem(
                  icon: Icons.map_outlined,
                  title: 'State',
                  value: state.state,
                ),

                _detailItem(
                  icon: Icons.markunread_mailbox_outlined,
                  title: 'PIN Code',
                  value: state.pincode,
                ),

                _detailItem(
                  icon: Icons.credit_card_outlined,
                  title: 'PAN Number',
                  value: state.panNumber,
                  showDivider: false,
                ),
              ],
            ),
          ),

          // Edit Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: SizedBox(
              height: 46,
              child: OutlinedButton.icon(
               onPressed: () {
  context.read<SocietySetupBloc>().add(
    SocietySetupStepChanged(0),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SocietySetupScreen(isEditMode: true,),
    ),
  );
},
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 17,
                ),
                label: const Text(
                  'Edit Society Details',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: navy,
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFFE0E7F0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailItem({
    required IconData icon,
    required String title,
    required String value,
    bool showDivider = true,
  }) {
    final displayValue =
        value.trim().isEmpty ? '-' : value;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6FA),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF8192AC),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayValue,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            color: Color(0xFFEDF0F5),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.apartment_outlined,
              size: 60,
              color: pink,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Society Details Found',
              style: TextStyle(
                color: navy,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Please complete Step 1 of Society Setup.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: muted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
