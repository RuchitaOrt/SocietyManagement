
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/Financial/presentation/Screen/FinancialMonthSection.dart';
import 'package:society_management/feature/Financial/presentation/Widget/AddFinancialMonthBottomSheet.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_event.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_state.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {


    Future<void> _showAddFinancialMonth() async {
    final result = await showAddFinancialMonthBottomSheet(
      context: context,
    );

    if (!mounted || result == null) return;

    context.read<SocietySetupBloc>().add(
      FinancialMonthAdded(result),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AdminColors.page,
       floatingActionButton: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton.extended(
      heroTag: 'addCategory',
      onPressed: _showAddFinancialMonth
      ,
      backgroundColor: const Color(0xFFE93691),
      icon: const Icon(Icons.category_outlined, color: Colors.white),
      label: const Text(
        'Add Financial Month',
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
         'Financial Month Master',
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
         
      body: BlocBuilder<SocietySetupBloc, SocietySetupState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FinancialMonthSection(
                  financialMonths: state.financialMonths,
                  onRemove: (index) {
                    context.read<SocietySetupBloc>().add(
                      FinancialMonthRemoved(index),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
