
import 'package:flutter/material.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

class SocietySettingsScreen extends StatefulWidget {
  const SocietySettingsScreen({super.key});

  @override
  State<SocietySettingsScreen> createState() =>
      _SocietySettingsScreenState();
}

class _SocietySettingsScreenState extends State<SocietySettingsScreen> {
  static const Color pink = Color(0xFFEC268F);
  static const Color orange = Color(0xFFFF9A45);
  static const Color navy = Color(0xFF25334D);
  static const Color muted = Color(0xFF64748B);
  static const Color page = Color(0xFFF4F7FB);
  static const Color border = Color(0xFFE2E8F0);
  static const Color green = Color(0xFF10B981);

  bool societyRulesExpanded = false;
  bool notificationsExpanded = true;
  bool browserNotificationsEnabled = true;

  bool _savedNotificationValue = true;

  void _resetSettings() {
    setState(() {
      browserNotificationsEnabled = _savedNotificationValue;
      societyRulesExpanded = false;
      notificationsExpanded = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings reset successfully')),
    );
  }

  void _saveSettings() {
    setState(() {
      _savedNotificationValue = browserNotificationsEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              backgroundColor: AdminColors.page,
               floatingActionButton: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton.extended(
      heroTag: 'addCategory',
      onPressed: ()
      {
        
      },
      backgroundColor: const Color(0xFFE93691),
      icon: const Icon(Icons.category_outlined, color: Colors.white),
      label: const Text(
        'Reset',
        style: TextStyle(color: Colors.white),
      ),
    ),
    SizedBox(width: 10,),
    FloatingActionButton.extended(
      heroTag: 'addCategory',
      onPressed: ()
      {

      },
      backgroundColor: const Color(0xFFE93691),
      icon: const Icon(Icons.category_outlined, color: Colors.white),
      label: const Text(
        'Save Setting',
        style: TextStyle(color: Colors.white),
      ),
    ),
    
  ],
),
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
                'Society Master - Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Maintenance billing and interest policies for the society',
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
            onPressed: () {},
            icon: const Icon(
              Icons.logout,
              color: Color(0xFFEC4899),
              size: 25,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding =
                constraints.maxWidth > 700 ? 32.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                22,
                horizontalPadding,
                24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPageHeader(context),
                      const SizedBox(height: 22),

                      _buildExpandableHeader(
                        icon: Icons.home_outlined,
                        title: 'SOCIETY PREDEFINED RULES',
                        subtitle:
                            'Maintenance billing and interest policies for the society',
                        trailing: '2 Rules',
                        expanded: societyRulesExpanded,
                        onTap: () {
                          setState(() {
                            societyRulesExpanded = !societyRulesExpanded;
                          });
                        },
                        iconColor: orange,
                      ),

                      if (societyRulesExpanded) ...[
                        const SizedBox(height: 10),
                        _buildRulesContent(),
                      ],

                      const SizedBox(height: 22),

                      _buildExpandableHeader(
                        icon: Icons.notifications_none_rounded,
                        title: 'NOTIFICATIONS & ALERTS',
                        subtitle:
                            'Control how and when you receive visitor gate alerts',
                        expanded: notificationsExpanded,
                        onTap: () {
                          setState(() {
                            notificationsExpanded =
                                !notificationsExpanded;
                          });
                        },
                        iconColor: const Color(0xFF8B45E9),
                      ),

                      if (notificationsExpanded) ...[
                        _buildNotificationContent(),
                      ],

                      const SizedBox(height: 24),
                      _buildBottomActions(),
                       const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 480;


        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // OutlinedButton.icon(
            //   onPressed: _resetSettings,
            //   icon: const Icon(Icons.refresh, size: 16),
            //   label: const Text('Reset'),
            //   style: OutlinedButton.styleFrom(
            //     foregroundColor: muted,
            //     side: const BorderSide(color: border),
            //     backgroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 14,
            //       vertical: 13,
            //     ),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(9),
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 9),
            // ElevatedButton.icon(
            //   onPressed: _saveSettings,
            //   icon: const Icon(Icons.save_outlined, size: 16),
            //   label: const Text('Save Settings'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: pink,
            //     foregroundColor: Colors.white,
            //     elevation: 2,
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 15,
            //       vertical: 13,
            //     ),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(9),
            //     ),
            //   ),
            // ),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              actions,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                ],
              ),
            ),
            actions,
          ],
        );
      },
    );
  }

  Widget _buildExpandableHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool expanded,
    required VoidCallback onTap,
    required Color iconColor,
    String? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 17,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFE8F0),
                Color(0xFFFFEEDC),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFFFD8C9),
            ),
            boxShadow: [
              BoxShadow(
                color: pink.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 37,
                width: 37,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: pink,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      height: 1,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFFC9DC),
                    ),
                  ),
                  child: Text(
                    trailing,
                    style: const TextStyle(
                      color: pink,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 7),
              Icon(
                expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: pink,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 450;

                final description = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Browser Push Notifications',
                      style: TextStyle(
                        color: navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Receive an instant alert on your device when a visitor arrives at the gate — even if the tab is in the background.',
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                  ],
                );

                final status = Column(
                  crossAxisAlignment: compact
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: browserNotificationsEnabled
                            ? const Color(0xFFE9FBF3)
                            : const Color(0xFFFFEEEE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 7,
                            color: browserNotificationsEnabled
                                ? green
                                : Colors.red,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            browserNotificationsEnabled
                                ? 'ENABLED'
                                : 'DISABLED',
                            style: TextStyle(
                              color: browserNotificationsEnabled
                                  ? const Color(0xFF059669)
                                  : Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 9),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          browserNotificationsEnabled =
                              !browserNotificationsEnabled;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8FAFC),
                        foregroundColor: navy,
                        side: const BorderSide(color: border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            browserNotificationsEnabled
                                ? Icons.check
                                : Icons.notifications_off_outlined,
                            size: 16,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            browserNotificationsEnabled
                                ? 'Enabled'
                                : 'Enable',
                          ),
                        ],
                      ),
                    ),
                  ],
                );

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _notificationIcon(),
                          const SizedBox(width: 12),
                          Expanded(child: description),
                        ],
                      ),
                      const SizedBox(height: 15),
                      status,
                    ],
                  );
                }

                return Row(
                  children: [
                    _notificationIcon(),
                    const SizedBox(width: 16),
                    Expanded(child: description),
                    const SizedBox(width: 12),
                    status,
                  ],
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F9FC),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HOW VISITOR GATE NOTIFICATIONS WORK',
                  style: TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final steps = [
                      'Guard logs visitor at the gate app',
                      'You receive a browser popup & bell badge',
                      'Tap Allow Entry or Deny from Visitor Pass',
                      'Guard receives your decision instantly',
                    ];

                    final columns = constraints.maxWidth < 550
                        ? 1
                        : constraints.maxWidth < 850
                            ? 2
                            : 4;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: steps.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 60,
                      ),
                      itemBuilder: (context, index) {
                        return _workflowStep(index + 1, steps[index]);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationIcon() {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE9FFF5),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFA7F3D0),
        ),
      ),
      child: const Icon(
        Icons.notifications_none_rounded,
        color: green,
        size: 25,
      ),
    );
  }

  Widget _workflowStep(int number, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            height: 23,
            width: 23,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: pink,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: navy,
                fontSize: 11,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ruleRow(
            'Maintenance Billing',
            'Configure predefined maintenance billing rules.',
          ),
          const Divider(height: 24, color: border),
          _ruleRow(
            'Interest Policies',
            'Configure applicable interest policies for the society.',
          ),
        ],
      ),
    );
  }

  Widget _ruleRow(String title, String subtitle) {
    return Row(
      children: [
        const Icon(
          Icons.rule_folder_outlined,
          color: pink,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: muted,
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 10,
        runSpacing: 10,
        children: [
          OutlinedButton(
            onPressed: _resetSettings,
            style: OutlinedButton.styleFrom(
              foregroundColor: muted,
              side: const BorderSide(color: border),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text('Discard Changes'),
          ),
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save_outlined, size: 16),
            label: const Text('Save All Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: pink,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
