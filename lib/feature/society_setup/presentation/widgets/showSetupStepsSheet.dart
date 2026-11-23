
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_event.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_state.dart';

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

Future<void> showSetupStepsSheet({
  required BuildContext context,
  required SocietySetupState state,
  required List<String> steps,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: context.read<SocietySetupBloc>(),
        child: SetupStepsSheet(
          state: state,
          steps: steps,
        ),
      );
    },
  );
}

class SetupStepsSheet extends StatelessWidget {
  final SocietySetupState state;
  final List<String> steps;

  const SetupStepsSheet({
    super.key,
    required this.state,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final currentStep = state.currentStep;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F7FB),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(context),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: steps.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _stepItem(
                    context,
                    index,
                    currentStep,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Setup Steps',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: _textColor,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }

  Widget _stepItem(
    BuildContext context,
    int index,
    int currentStep,
  ) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;
    final isLocked = index > currentStep;

    final iconColor = isCompleted
        ? Colors.green
        : isCurrent
            ? _primaryColor
            : _hintColor;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: isLocked
          ? null
          : () {
              context.read<SocietySetupBloc>().add(
                    SocietySetupStepChanged(index),
                  );
              Navigator.pop(context);
            },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCurrent
                ? _primaryColor
                : const Color(0xFFE9EDF4),
            width: isCurrent ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted
                    ? Icons.check_rounded
                    : isLocked
                        ? Icons.lock_outline_rounded
                        : Icons.circle_outlined,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isCurrent
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: isLocked ? _hintColor : _textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompleted
                        ? 'Completed'
                        : isCurrent
                            ? 'Currently in progress'
                            : 'Pending',
                    style: TextStyle(
                      fontSize: 11,
                      color: isCompleted
                          ? Colors.green
                          : isCurrent
                              ? _primaryColor
                              : _hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isLocked
                  ? Icons.lock_outline
                  : Icons.chevron_right_rounded,
              color: isLocked ? _hintColor : _primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
