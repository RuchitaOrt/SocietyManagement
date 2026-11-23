
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:society_management/Member/VisitorPass/presentation/bloc/VisitorPassBloc.dart';
import 'package:society_management/Member/VisitorPass/presentation/bloc/VisitorPassEvent.dart';
import 'package:society_management/Member/VisitorPass/presentation/bloc/VisitorPassState.dart';
import 'package:society_management/Member/VisitorPass/presentation/bloc/VisitorPassModel.dart';
import 'package:society_management/Member/VisitorPass/presentation/repository/visitor_pass_repository.dart';
import 'package:society_management/Member/VisitorPass/presentation/widget/visitor_pass_card.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/VisitorManagement/add_visitor_pass_bottom_sheet.dart';



class VisitorPassScreen extends StatelessWidget {
  final String societyName;

  const VisitorPassScreen({
    super.key,
    required this.societyName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VisitorPassBloc(
        VisitorPassRepository(),
      )..add(LoadVisitorPasses()),
      child: VisitorPassView(
        societyName: societyName,
      ),
    );
  }
}

class VisitorPassView extends StatelessWidget {
  final String societyName;

  const VisitorPassView({
    super.key,
    required this.societyName,
  });

  static const Color pink = Color(0xFFE93691);
  static const Color orange = Color(0xFFFFA05C);
  static const Color navy = Color(0xFF202B43);
  static const Color grey = Color(0xFF91A0B8);

  Future<void> _addVisitor(BuildContext context) async {
    final visitor = await showAddVisitorPassBottomSheet(
      context: context,
      societyName: societyName,
    );

    if (!context.mounted || visitor == null) return;

    context.read<VisitorPassBloc>().add(
      AddVisitorPass(visitor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.page,
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
                'Visitor Pass',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Create a visitor gate pass for your flat | Ruchita | Flat 201 | A',
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
         
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
           
            Expanded(
              child: BlocConsumer<VisitorPassBloc, VisitorPassState>(
                listener: (context, state) {
                  if (state.status == VisitorPassStatus.failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage ?? 'Something went wrong',
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == VisitorPassStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: pink,
                      ),
                    );
                  }

                  if (state.status == VisitorPassStatus.failure &&
                      state.visitors.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Unable to load visitor passes'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context.read<VisitorPassBloc>().add(
                                LoadVisitorPasses(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: pink,
                    onRefresh: () async {
                      context.read<VisitorPassBloc>().add(
                        RefreshVisitorPasses(),
                      );
                      await Future.delayed(
                        const Duration(milliseconds: 500),
                      );
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        18, 20, 18, 30,
                      ),
                      children: [
                        // Add visitor button
                        _addVisitorButton(
                          onTap: () => _addVisitor(context),
                          isAdding: state.isAdding,
                        ),

                        const SizedBox(height: 24),

                        // List heading
                        Row(
                          children: [
                            const Text(
                              'Visitor History',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: navy,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE8F3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${state.visitors.length} Visitors',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: pink,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Visitor cards
                        if (state.visitors.isEmpty)
                          _emptyView()
                        else
                          ...state.visitors.map(
                            (visitor) => VisitorPassCard(
                              visitor: visitor,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addVisitorButton({
    required VoidCallback onTap,
    required bool isAdding,
  }) {
    return InkWell(
      onTap: isAdding ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 17,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [pink, orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: pink.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.person_add_alt_1_rounded,
              color: Colors.white,
              size: 23,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Visitor Pass',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Create a new visitor entry',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (isAdding)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _emptyView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 45,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.directions_walk_rounded,
            size: 48,
            color: pink,
          ),
          SizedBox(height: 12),
          Text(
            'No Visitors Yet',
            style: TextStyle(
              color: navy,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tap Add Visitor Pass to create your first visitor entry.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
