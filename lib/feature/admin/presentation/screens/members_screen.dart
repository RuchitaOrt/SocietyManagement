import 'package:flutter/material.dart';
import 'admin_main_screen.dart';
import '../widgets/dashboard_widgets.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _PageHeader(
            title: 'Members',
            subtitle: 'Manage society residents',
            action: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: const [
                Expanded(
                  child: _MemberSummary(
                    title: 'Total Members',
                    value: '120',
                    color: AdminColors.blue,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _MemberSummary(
                    title: 'Active Flats',
                    value: '96',
                    color: AdminColors.green,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, flat or phone',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AdminColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AdminColors.border),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(label: 'All', selected: true),
                SizedBox(width: 8),
                _FilterChip(label: 'Owners'),
                SizedBox(width: 8),
                _FilterChip(label: 'Tenants'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _MemberTile(
                  name: 'Rahul Sharma',
                  flat: 'A-101',
                  phone: '+91 98765 43210',
                  role: 'Owner',
                  initials: 'RS',
                  color: AdminColors.blue,
                ),
                _MemberTile(
                  name: 'Priya Patel',
                  flat: 'A-102',
                  phone: '+91 98765 43211',
                  role: 'Owner',
                  initials: 'PP',
                  color: AdminColors.primary,
                ),
                _MemberTile(
                  name: 'Amit Deshmukh',
                  flat: 'A-103',
                  phone: '+91 98765 43212',
                  role: 'Tenant',
                  initials: 'AD',
                  color: AdminColors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;
  const _PageHeader({required this.title, required this.subtitle, this.action});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AdminColors.text,
                          fontSize: 23,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AdminColors.muted, fontSize: 12)),
                ],
              ),
            ),
            if (action != null) action!,
          ],
        ),
      );
}

class _MemberSummary extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _MemberSummary(
      {required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AdminColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 22, fontWeight: FontWeight.w800)),
            Text(title,
                style: const TextStyle(
                    color: AdminColors.muted, fontSize: 11)),
          ],
        ),
      );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AdminColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AdminColors.primary : AdminColors.border),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? AdminColors.primary : AdminColors.muted,
                fontWeight: FontWeight.w600,
                fontSize: 11)),
      );
}

class _MemberTile extends StatelessWidget {
  final String name;
  final String flat;
  final String phone;
  final String role;
  final String initials;
  final Color color;
  const _MemberTile({
    required this.name,
    required this.flat,
    required this.phone,
    required this.role,
    required this.initials,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AdminColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: color.withOpacity(.12),
              child: Text(initials,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 12)),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: AdminColors.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('$flat  •  $phone',
                      style: const TextStyle(
                          color: AdminColors.muted, fontSize: 10)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(role,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 10)),
            ),
          ],
        ),
      );
}
