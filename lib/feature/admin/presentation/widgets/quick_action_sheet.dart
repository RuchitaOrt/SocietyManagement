import 'package:flutter/material.dart';
import '../screens/admin_main_screen.dart';

void showQuickActionSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _QuickActionSheet(),
  );
}

class _QuickActionSheet extends StatelessWidget {
  const _QuickActionSheet();

  @override
  Widget build(BuildContext context) {
    final actions = <_ActionData>[
      _ActionData('Add Gate Pass', Icons.directions_walk_rounded, AdminColors.blue),
      _ActionData('Broadcast Notice', Icons.campaign_outlined, AdminColors.primary),
      _ActionData('Raise Complaint', Icons.support_agent_rounded, AdminColors.orange),
      _ActionData('Collect Payment', Icons.payments_outlined, AdminColors.green),
      _ActionData('Staff Attendance', Icons.fact_check_outlined, const Color(0xFF8B5CF6)),
    ];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFD8DCE5),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Expanded(
                  child: Text('Quick Actions',
                      style: TextStyle(
                          color: AdminColors.text,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ),
                Text('Choose an action',
                    style: TextStyle(
                        color: AdminColors.muted, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.08,
              ),
              itemBuilder: (context, index) {
                final action = actions[index];
                return InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: action.color.withOpacity(.07),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: action.color.withOpacity(.14),
                          child: Icon(action.icon,
                              color: action.color, size: 22),
                        ),
                        const SizedBox(height: 9),
                        Text(action.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AdminColors.text,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionData {
  final String title;
  final IconData icon;
  final Color color;
  const _ActionData(this.title, this.icon, this.color);
}
