import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/AdminAccountScreen/AdminAccountScreen.dart';
import 'package:society_management/feature/Notification/NoticeListScreen.dart';
import 'package:society_management/feature/society_setup/presentation/ComplaintManagement/complaint_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/BillingManagement/bill_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/VisitorManagement/visitor_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/VisitorManagement/visitor_event.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/VisitorManagement/visitor_state.dart';
import 'package:society_management/feature/society_setup/presentation/pages/VisitorManagementScreen.dart';
import 'package:society_management/feature/society_setup/presentation/pages/bill_management_screen.dart';
import 'package:society_management/feature/society_setup/presentation/pages/complaint_management_screen.dart';
import 'package:society_management/feature/society_setup/presentation/pages/society_staff_screen.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/VisitorManagement/add_visitor_pass_bottom_sheet.dart';
import '../widgets/dashboard_widgets.dart';
import 'admin_main_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _DashboardHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _WelcomeBanner(),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Expanded(
                      child: DashboardStatCard(
                        title: 'Total Members',
                        value: '120',
                        trend: '5%',
                        icon: Icons.groups_rounded,
                        color: AdminColors.blue,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DashboardStatCard(
                        title: "Today's Visitors",
                        value: '8',
                        trend: '12%',
                        icon: Icons.people_alt_rounded,
                        color: AdminColors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(
                      child: DashboardStatCard(
                        title: 'Staff Present',
                        value: '0 / 0',
                        trend: '0% attendance',
                        icon: Icons.account_balance_wallet_rounded,
                        color: AdminColors.primary,
                        isDown: false,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DashboardStatCard(
                        title: 'Monthly Collection',
                        value: '₹1.85 L',
                        trend: '8%',
                        icon: Icons.currency_rupee_rounded,
                        color: AdminColors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Expanded(
                      child: DashboardStatCard(
                        title: 'Open Complaints',
                        value: '0',
                        trend: '0 in progress',
                        icon: Icons.account_balance_wallet_rounded,
                        color: AdminColors.red,
                        isDown: false,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DashboardStatCard(
                        title: 'Collection Rate',
                        value: '100% ',
                        trend: '100%',
                        icon: Icons.currency_rupee_rounded,
                        color: AdminColors.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _FinancialOverview(),
                const SizedBox(height: 16),
                const _GateAndVisitorSection(),
                const SizedBox(height: 16),
                _QuickActions(),
                const SizedBox(height: 16),
                const _HelpdeskOverview(),
                const SizedBox(height: 16),
                const _RecentActivity(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 13, 18, 8),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AdminColors.primary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AdminColors.primary.withOpacity(.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jainam Heights',
                  style: TextStyle(
                    color: AdminColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Andheri West, Mumbai',
                  style: TextStyle(color: AdminColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AdminColors.text,
                  size: 27,
                ),
              ),
              Positioned(
                right: 7,
                top: 5,
                child: Container(
                  height: 16,
                  width: 16,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AdminColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminAccountScreen(),
                ),
              );
            },
            child: CircleAvatar(
              radius: 21,
              backgroundColor: AdminColors.primaryLight,
              child: const Text(
                'JD',
                style: TextStyle(
                  color: AdminColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE0F0), Color(0xFFFFECDD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF8C8E0)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -4,
            bottom: -10,
            child: Icon(
              Icons.apartment_rounded,
              size: 116,
              color: AdminColors.primary.withOpacity(.15),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  color: AdminColors.text,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'John Doe!',
                style: TextStyle(
                  color: AdminColors.text,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Your society is well managed\nand up to date.',
                style: TextStyle(
                  color: Color(0xFF5D6680),
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FinancialOverview extends StatelessWidget {
  const _FinancialOverview();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Financial Overview',
      subtitle: 'November 2026',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _LegendDot(color: AdminColors.green, label: 'Income'),
              SizedBox(width: 20),
              _LegendDot(color: AdminColors.primary, label: 'Expense'),
              Spacer(),
              Text(
                'Last 6 Months',
                style: TextStyle(color: AdminColors.muted, fontSize: 10),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 17,
                color: AdminColors.muted,
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 155,
            width: double.infinity,
            child: CustomPaint(painter: _FinancialChartPainter()),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MonthLabel('Jun'),
              _MonthLabel('Jul'),
              _MonthLabel('Aug'),
              _MonthLabel('Sep'),
              _MonthLabel('Oct'),
              _MonthLabel('Nov'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(radius: 4, backgroundColor: color),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(color: AdminColors.muted, fontSize: 11),
      ),
    ],
  );
}

class _MonthLabel extends StatelessWidget {
  final String text;
  const _MonthLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(color: AdminColors.muted, fontSize: 10),
  );
}

class _FinancialChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFEDEAF0)
      ..strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      final y = i * size.height / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final income = [0.72, 0.66, 0.55, 0.49, 0.31, 0.38];
    final expense = [0.88, 0.82, 0.73, 0.61, 0.47, 0.56];

    void drawLine(List<double> values, Color color) {
      final path = Path();
      for (int i = 0; i < values.length; i++) {
        final point = Offset(
          i * size.width / (values.length - 1),
          values[i] * size.height,
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      final paint = Paint()
        ..color = color
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, paint);

      for (int i = 0; i < values.length; i++) {
        final point = Offset(
          i * size.width / (values.length - 1),
          values[i] * size.height,
        );
        canvas.drawCircle(point, 3.5, Paint()..color = color);
      }
    }

    drawLine(income, AdminColors.green);
    drawLine(expense, AdminColors.primary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GateAndVisitorSection extends StatelessWidget {
  const _GateAndVisitorSection();

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.isNegative) {
      return 'Upcoming visitor';
    }

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    return '${difference.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SectionCard(
            title: 'Live Gate Feed',
            subtitle: "Today's entries",
            child: BlocBuilder<VisitorBloc, VisitorState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state.visitors.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 124,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.door_sliding_rounded,
                            size: 38,
                            color: AdminColors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      const Text(
                        'No visitors yet',
                        style: TextStyle(
                          color: AdminColors.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const Text(
                        'Visitor entries will appear here',
                        style: TextStyle(
                          color: AdminColors.muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  );
                }

                // Latest visitor added to the list.
                final latestVisitor = state.visitors.last;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 124,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.door_sliding_rounded,
                          size: 38,
                          color: AdminColors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      latestVisitor.visitorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AdminColors.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${latestVisitor.type} • ${_getTimeAgo(latestVisitor.expectedAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AdminColors.muted,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Status: ${latestVisitor.status}',
                      style: const TextStyle(
                        color: AdminColors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SectionCard(
            title: 'Visitor Types',
            subtitle: 'Breakdown by category',
            child: const Column(
              children: [
                _VisitorType(
                  icon: Icons.person,
                  title: 'Guest',
                  count: '12',
                  color: AdminColors.blue,
                ),
                SizedBox(height: 8),
                _VisitorType(
                  icon: Icons.local_taxi,
                  title: 'Cab',
                  count: '4',
                  color: Color(0xFF8B5CF6),
                ),
                SizedBox(height: 8),
                _VisitorType(
                  icon: Icons.local_shipping,
                  title: 'Maid',
                  count: '2',
                  color: AdminColors.green,
                ),
                SizedBox(height: 8),
                _VisitorType(
                  icon: Icons.local_shipping,
                  title: 'Delivery',
                  count: '2',
                  color: AdminColors.orange,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class _VisitorType extends StatelessWidget {
  final IconData icon;
  final String title;
  final String count;
  final Color color;
  const _VisitorType({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: color.withOpacity(.09),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: AdminColors.text, fontSize: 10),
            ),
          ),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatefulWidget {
  @override
  State<_QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<_QuickActions> {
  void _openVisitorPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VisitorManagementScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Quick Actions',
      subtitle: 'Common management tasks',
      child: Column(
        children: [
          _DashboardQuickAction(
            title: 'Add Gate Pass',
            subtitle: 'Pre-approve visitor entry',
            icon: Icons.directions_walk_rounded,
            color: AdminColors.blue,
            onTap: _openVisitorPage,
          ),
          const SizedBox(height: 9),
          _DashboardQuickAction(
            title: 'Broadcast Notice',
            subtitle: 'Send notice to all residents',
            icon: Icons.campaign_outlined,
            color: AdminColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NoticeListScreen()),
              );
            },
          ),
          const SizedBox(height: 9),
          _DashboardQuickAction(
            title: 'Raise Complaint',
            subtitle: 'Log a new helpdesk ticket',
            icon: Icons.support_agent_rounded,
            color: AdminColors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => ComplaintBloc(),
                    child: const ComplaintManagementScreen(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 9),
          _DashboardQuickAction(
            title: 'Collect Payment',
            subtitle: 'Record maintenance receipt',
            icon: Icons.payments_outlined,
            color: AdminColors.green,
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
          const SizedBox(height: 9),
          _DashboardQuickAction(
            title: 'Staff Attendance',
            subtitle: "Mark today's staff check-in/out",
            icon: Icons.fact_check_outlined,
            color: const Color(0xFF8B5CF6),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SocietyStaffScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardQuickAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardQuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AdminColors.border),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(.13),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AdminColors.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AdminColors.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AdminColors.muted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpdeskOverview extends StatelessWidget {
  const _HelpdeskOverview();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Helpdesk Overview',
      subtitle: 'This month',
      actionText: '0 total',
      child: Column(
        children: const [
          _HelpdeskStatusRow(
            title: 'Open',
            count: '0',
            percent: '0%',
            color: AdminColors.red,
          ),
          SizedBox(height: 15),
          _HelpdeskStatusRow(
            title: 'In Progress',
            count: '0',
            percent: '0%',
            color: AdminColors.orange,
          ),
          SizedBox(height: 15),
          _HelpdeskStatusRow(
            title: 'Resolved',
            count: '0',
            percent: '0%',
            color: AdminColors.green,
          ),
          SizedBox(height: 15),
          _HelpdeskStatusRow(
            title: 'Closed',
            count: '0',
            percent: '0%',
            color: Color(0xFF64748B),
          ),
          SizedBox(height: 14),
          Divider(color: AdminColors.border, height: 1),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total complaints this month',
                  style: TextStyle(color: AdminColors.muted, fontSize: 11),
                ),
              ),
              Text(
                '0',
                style: TextStyle(
                  color: AdminColors.text,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpdeskStatusRow extends StatelessWidget {
  final String title;
  final String count;
  final String percent;
  final Color color;

  const _HelpdeskStatusRow({
    required this.title,
    required this.count,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 9),
        SizedBox(
          width: 78,
          child: Text(
            title,
            style: const TextStyle(
              color: AdminColors.text,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: 22,
          child: Text(
            count,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AdminColors.text,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0,
              minHeight: 6,
              backgroundColor: Color(0xFFE7E9EF),
              valueColor: AlwaysStoppedAnimation(AdminColors.green),
            ),
          ),
        ),
        const SizedBox(width: 9),
        SizedBox(
          width: 25,
          child: Text(
            percent,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AdminColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Notice Board',
      subtitle: "Recent announcements",
      actionText: 'View All',
      child: const Column(
        children: [
          _ActivityRow(
            icon: Icons.payments_rounded,
            color: AdminColors.green,
            title: 'Payment received from Rahul Sharma',
            subtitle: 'Today, 4:20 PM',
            amount: '₹5,000',
          ),
          Divider(height: 18, color: AdminColors.border),
          _ActivityRow(
            icon: Icons.person_add_alt_1_rounded,
            color: AdminColors.blue,
            title: 'Member added: Priya Patel',
            subtitle: 'Today, 3:15 PM',
            amount: '',
          ),
          Divider(height: 18, color: AdminColors.border),
          _ActivityRow(
            icon: Icons.receipt_long_rounded,
            color: AdminColors.orange,
            title: 'Expense added: Electricity Bill',
            subtitle: 'Today, 1:30 PM',
            amount: '₹12,500',
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String amount;
  const _ActivityRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: color.withOpacity(.12),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AdminColors.text,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: AdminColors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
        if (amount.isNotEmpty)
          Text(
            amount,
            style: const TextStyle(
              color: AdminColors.text,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
      ],
    );
  }
}

class _UpcomingTasks extends StatelessWidget {
  const _UpcomingTasks();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Upcoming Tasks',
      actionText: 'View All',
      child: const Column(
        children: [
          _TaskRow('Send monthly bills', 'Due today'),
          _TaskRow('Check bank statement', 'Due tomorrow'),
          _TaskRow('Review expense report', 'Due in 2 days'),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final String title;
  final String due;
  const _TaskRow(this.title, this.due);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AdminColors.primary,
            size: 18,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: AdminColors.text, fontSize: 11),
            ),
          ),
          Text(
            due,
            style: const TextStyle(
              color: AdminColors.orange,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
