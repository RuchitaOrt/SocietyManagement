import 'package:flutter/material.dart';
import '../screens/admin_main_screen.dart';

class AdminBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AdminBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      _NavItem(Icons.home_rounded, 'Home'),
      _NavItem(Icons.people_alt_rounded, 'Members'),
      _NavItem(Icons.add_rounded, 'Add'),
      _NavItem(Icons.account_balance_wallet_rounded, 'Finance'),
      _NavItem(Icons.grid_view_rounded, 'More'),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 76,
        padding: const EdgeInsets.fromLTRB(8, 7, 8, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AdminColors.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 18,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final selected = selectedIndex == index;
            final item = items[index];

            if (index == 2) {
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => onTap(index),
                  child: Center(
                    child: Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: AdminColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AdminColors.primary.withOpacity(.28),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 32),
                    ),
                  ),
                ),
              );
            }

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 23,
                      color: selected ? AdminColors.primary : AdminColors.muted,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color:
                            selected ? AdminColors.primary : AdminColors.muted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 3,
                      width: selected ? 25 : 0,
                      decoration: BoxDecoration(
                        color: AdminColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
