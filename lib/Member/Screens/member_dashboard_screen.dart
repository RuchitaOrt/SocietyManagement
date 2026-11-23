
import 'package:flutter/material.dart';
import 'package:society_management/Member/Biill/presentation/bloc/Screen/member_bills_screen.dart';
import 'package:society_management/Member/More/presentation/screens/more_screen.dart';
import 'package:society_management/Member/Notice/presentation/bloc/screens/notices_page.dart';
import 'package:society_management/Member/Receipt/presentation/screen/receipts_page.dart';
import 'package:society_management/Member/Settings/presentation/Screen/society_settings_screen.dart';
import 'package:society_management/Member/Tenant/presentation/Screens/tenant_screen.dart';
import 'package:society_management/Member/VisitorPass/presentation/Screen/VisitorPassScreen.dart';
import 'package:society_management/Member/complaints/presentation/screens/member_complaints_screen.dart';
import 'package:society_management/Member/member_profile/Screens/member_profile_screen.dart';
import 'package:society_management/Member/nominees/presentation/Screens/nominees_screen.dart';
import 'package:society_management/Member/vehicles/presentation/Screens/my_vehicles_screen.dart';

class _PortalMenuItem {
  final String title;
  final IconData icon;

  const _PortalMenuItem(this.title, this.icon);
}
class MemberDashboardScreen extends StatefulWidget {
  const MemberDashboardScreen({super.key});

  @override
  State<MemberDashboardScreen> createState() =>
      _MemberDashboardScreenState();
}

class _MemberDashboardScreenState extends State<MemberDashboardScreen> {
  int selectedIndex = 0;
final GlobalKey<ScaffoldState> _scaffoldKey =
    GlobalKey<ScaffoldState>();

void _handleBottomNavigation(int index) {
  if (index == 1) {
    setState(() => selectedIndex = 1);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MemberProfileScreen(),
      ),
    ).then((_) {
      if (mounted) setState(() => selectedIndex = 0);
    });

  } else if (index == 2) {
    setState(() => selectedIndex = 2);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SocietySettingsScreen(),
      ),
    ).then((_) {
      if (mounted) setState(() => selectedIndex = 0);
    });

  } if (index == 3) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const MoreScreen(),
    ),
  );
} else {
    setState(() => selectedIndex = index);
  }
}

bool isMemberPortalExpanded = true;
String selectedMenu = 'Overview';
  static const Color pink = Color(0xFFF52291);
  static const Color orange = Color(0xFFFF9D36);
  static const Color navy = Color(0xFF101D50);
  static const Color muted = Color(0xFF68749F);
  static const Color background = Color(0xFFFCF9FF);

void onAction(String action) {
  if (action == 'My Bills' || action == 'Bills'||action == 'Maintainance') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MemberBillsScreen(),
      ),
    );
    return;
  }else if(action == 'Overview' || action == 'overview')
  {
    

      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MemberDashboardScreen(),
      ),
    );
    return;
  }else if(action == 'My Complaints'||action == 'Complaints')
  {
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const MemberComplaintsScreen(),
  ),
);
 return;
  }else if(action == 'Notices')
  {
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const NoticesPage(),
  ),
);
 return;
  }else if(action == 'Receipts')
  {
   Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const ReceiptsPage(),
  ),
);
 return;
  }else if(action == 'Visitor Pass')
  {
     Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const VisitorPassScreen(societyName: 'Jainam',),
  ),
);
 return;
    
  }
else if (action == 'Nominees')
{
  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const NomineesScreen(),
  ),
);
 return;
}
else if (action == 'My Vehicles')
{
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const MyVehiclesScreen(),
  ),
);
 return;
}
else if(action == 'Tenants')
{
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const TenantScreen(),
  ),
);
 return;
}

  debugPrint('Action: $action');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         key: _scaffoldKey,
    backgroundColor: background,

    drawer: _memberDrawer(),

      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 145,
              child: _headerBackground(),
            ),
            _dashboardContent(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  // HEADER BACKGROUND

  Widget _headerBackground() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF43BA7),
              Color(0xFFFF786B),
              Color(0xFFFFA02D),
            ],
            stops: [0, .55, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -70,
              top: -90,
              child: Transform.rotate(
                angle: -.7,
                child: Container(
                  width: 190,
                  height: 250,
                  color: Colors.white.withOpacity(.07),
                ),
              ),
            ),
            Positioned(
              left: -55,
              bottom: -95,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.08),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DASHBOARD CONTENT

Widget _memberDrawer() {
  final menuItems = [
    _PortalMenuItem('Overview', Icons.dashboard_outlined),
    _PortalMenuItem('My Bills', Icons.receipt_long_outlined),
    _PortalMenuItem('Receipts', Icons.receipt_outlined),
    _PortalMenuItem('My Complaints', Icons.report_problem_outlined),
    _PortalMenuItem('Notices', Icons.notifications_none_rounded),
    _PortalMenuItem('Tenants', Icons.people_outline_rounded),
    _PortalMenuItem('Nominees', Icons.person_outline_rounded),
    _PortalMenuItem('Visitor Pass', Icons.badge_outlined),
    _PortalMenuItem('My Vehicles', Icons.directions_car_outlined),
  ];

  return Drawer(
    width: 300,
    backgroundColor: Colors.white,
    elevation: 10,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    child: SafeArea(
      child: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFF0EDF3),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 43,
                  width: 43,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF52291),
                        Color(0xFFFF8A64),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'SM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Society Management',
                        style: TextStyle(
                          color: Color(0xFF17213D),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.apartment,
                            size: 12,
                            color: Color(0xFF71809A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Jainam',
                            style: TextStyle(
                              color: Color(0xFF71809A),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    size: 21,
                    color: Color(0xFF68749F),
                  ),
                ),
              ],
            ),
          ),

          // MENU LABEL
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Row(
              children: [
                const Text(
                  'MENU',
                  style: TextStyle(
                    color: Color(0xFF26334D),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .5,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.chevron_left,
                    size: 18,
                    color: Color(0xFF26334D),
                  ),
                ),
              ],
            ),
          ),

          // MEMBER PORTAL EXPANSION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  isMemberPortalExpanded =
                      !isMemberPortalExpanded;
                });
              },
              borderRadius: BorderRadius.circular(13),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F8),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: Color(0xFFF52291),
                      size: 19,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Member Portal',
                        style: TextStyle(
                          color: Color(0xFFF52291),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      isMemberPortalExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFFF52291),
                      size: 19,
                    ),
                  ],
                ),
              ),
            ),
          ),
SizedBox(height: 20,),
          // EXPANDABLE MENU ITEMS
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: isMemberPortalExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: menuItems.map((item) {
                final isSelected =
                    selectedMenu == item.title;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    40, 2, 12, 2,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedMenu = item.title;
                      });

                      Navigator.pop(context);
                      onAction(item.title);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 39,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFF1F8)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: 
                      Stack(
                        children: [
                          if (isSelected)
                            Positioned(
                              left: -13,
                              top: 7,
                              bottom: 7,
                              child: Container(
                                width: 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF52291),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      color: isSelected
                                          ? const Color(0xFFF52291)
                                          : const Color(0xFF526B91),
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: isSelected
                                      ? const Color(0xFFF52291)
                                      : const Color(0xFF8DA0BB),
                                  size: 17,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            secondChild: const SizedBox(
              width: double.infinity,
            ),
          ),

          const Spacer(),

          // FOOTER
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE4E8EF),
                ),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Version 2.4.1',
                  style: TextStyle(
                    color: Color(0xFF26334D),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Help & Support',
                  style: TextStyle(
                    color: Color(0xFF26334D),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _dashboardContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(15, 7, 15, 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _appBar(),
                const SizedBox(height: 23),

                _welcomeCard(),

                const SizedBox(height: 13),

                _memberBalanceCard(),

                const SizedBox(height: 14),

                _summaryGrid(),

                const SizedBox(height: 13),

                _billsBanner(),

                const SizedBox(height: 17),

                _quickActionsHeader(),

                const SizedBox(height: 10),

                _quickActionsGrid(),

                const SizedBox(height: 15),

                _communityFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // TOP APP BAR

  Widget _appBar() {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
        InkWell(
  onTap: () {
    _scaffoldKey.currentState?.openDrawer();
  },
  child: const Icon(
    Icons.menu,
    color: Colors.white,
    size: 29,
  ),
),

          const SizedBox(width: 25),

          const Icon(
            Icons.home_outlined,
            color: Colors.white,
            size: 37,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Society\nManagement',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ),

          InkWell(
            onTap: () => onAction('Notifications'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 31,
                ),
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    width: 19,
                    height: 19,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE90068),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.2,
                      ),
                    ),
                    child: const Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WELCOME CARD

  Widget _welcomeCard() {
    return Container(
      height: 83,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFE4F3),
            Color(0xFFFFF0E9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white,
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB98CC8).withOpacity(.14),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            width: 105,
            child: Opacity(
              opacity: .27,
              child: CustomPaint(
                painter: _BuildingPainter(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: pink,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'RS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome, ',
                              style: TextStyle(
                                color: navy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'Ruchita!',
                              style: TextStyle(
                                color: pink,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Your society account summary',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MEMBER INFORMATION AND BALANCE

  Widget _memberBalanceCard() {
    return Container(
      height: 79,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: _cardDecoration(radius: 24),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFE9EAFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF4551E8),
              size: 30,
            ),
          ),

          const SizedBox(width: 9),

          const Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ruchita Sharma',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Flat 201 | A',
                  style: TextStyle(
                    color: navy,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 45,
            width: 1,
            color: const Color(0xFFE1D8EA),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Outstanding Balance',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFF15B96B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                const Text(
                  '₹0',
                  style: TextStyle(
                    color: pink,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),

                InkWell(
                  onTap: () => onAction('Outstanding Details'),
                  child: const Row(
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          color: pink,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: pink,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SUMMARY GRID

  Widget _summaryGrid() {
    final items = [
      _SummaryItem(
        'My Bills',
        '0',
        Icons.description,
        const Color(0xFF4054F5),
        const Color(0xFFE9EAFF),
      ),
      _SummaryItem(
        'Complaints',
        '0',
        Icons.access_time_filled,
        const Color(0xFFFF694B),
        const Color(0xFFFFEAE5),
      ),
      _SummaryItem(
        'Notices',
        '0',
        Icons.campaign,
        const Color(0xFF13B66B),
        const Color(0xFFE8F8EF),
      ),
      _SummaryItem(
        'Visitors Pass',
        '0',
        Icons.people_alt,
        const Color(0xFFFFA323),
        const Color(0xFFFFF3E1),
      ),
      _SummaryItem(
        'Events',
        '0',
        Icons.calendar_month,
        const Color(0xFFB31AA8),
        const Color(0xFFF9E9F7),
      ),
      _SummaryItem(
        'Parking',
        '0',
        Icons.directions_car,
        const Color(0xFF405CF2),
        const Color(0xFFE9EDFF),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.10,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return InkWell(
          onTap: () => onAction(item.title),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            decoration: _cardDecoration(radius: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconCircle(
                  item.icon,
                  item.iconColor,
                  item.bgColor,
                  36,
                ),

                const SizedBox(height: 4),

                Text(
                  item.count,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // BILLS BANNER

  Widget _billsBanner() {
    return InkWell(
      onTap: () => onAction('My Bills'),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 19),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF22BA1),
              Color(0xFFFFA02E),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: pink.withOpacity(.14),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.22),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white,
                size: 27,
              ),
            ),

            const SizedBox(width: 15),

            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View My Bills',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Check and pay your bills',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  // QUICK ACTIONS TITLE

  Widget _quickActionsHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Quick Actions',
            style: TextStyle(
              color: navy,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        InkWell(
          onTap: () => onAction('View All'),
          child: const Row(
            children: [
              Text(
                'View All',
                style: TextStyle(
                  color: pink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward,
                color: pink,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // QUICK ACTIONS GRID

  Widget _quickActionsGrid() {
    final actions = [
      _QuickItem(
        'Maintainance',
        Icons.description,
        const Color(0xFFEF2990),
        const Color(0xFFFCE7F4),
      ),
      _QuickItem(
        'Complaints',
        Icons.error,
        const Color(0xFFFF9A36),
        const Color(0xFFFFEEE3),
      ),
      _QuickItem(
        'Notices',
        Icons.notifications_none,
        const Color(0xFF9C16B5),
        const Color(0xFFF6E6FA),
      ),
      _QuickItem(
        'Events',
        Icons.calendar_month,
        const Color(0xFF16B96A),
        const Color(0xFFE5F8ED),
      ),
      _QuickItem(
        'Parking',
        Icons.directions_car,
        const Color(0xFF4657EF),
        const Color(0xFFE9EAFF),
      ),
      _QuickItem(
        'Visitor Pass',
        Icons.people_alt,
        const Color(0xFFEF2990),
        const Color(0xFFFCE7F4),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 9,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final item = actions[index];

        return InkWell(
          onTap: () => onAction(item.title),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: _cardDecoration(radius: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconCircle(
                  item.icon,
                  item.iconColor,
                  item.bgColor,
                  35,
                ),

                const SizedBox(height: 5),

                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // COMMUNITY FOOTER

  Widget _communityFooter() {
    return SizedBox(
      height: 55,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: .35,
              child: CustomPaint(
                painter: _BuildingPainter(),
              ),
            ),
          ),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 17,
                  height: 1,
                  color: muted,
                ),
                const SizedBox(width: 9),
                const Flexible(
                  child: Text(
                    'Together for a better community',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Container(
                  width: 17,
                  height: 1,
                  color: muted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM NAVIGATION

  Widget _bottomNavigation() {
    final items = [
      _NavItem('Home', Icons.home_rounded),
      _NavItem('My Profile', Icons.person_outline_rounded),
      _NavItem('Settings', Icons.settings_outlined),
      _NavItem('More', Icons.more_horiz_rounded),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9673AD).withOpacity(.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 69,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = selectedIndex == index;

              return Expanded(
                child: InkWell(
                onTap: () {
  _handleBottomNavigation(index);
},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 25,
                        color: isSelected ? pink : muted,
                      ),

                      const SizedBox(height: 3),

                      Text(
                        item.title,
                        style: TextStyle(
                          color: isSelected ? pink : muted,
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 5),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 3,
                        width: isSelected ? 50 : 0,
                        decoration: BoxDecoration(
                          color: pink,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // COMMON CARD STYLE

  BoxDecoration _cardDecoration({double radius = 22}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(.96),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: const Color(0xFFF4EDF7),
        width: .7,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFB69BC6).withOpacity(.12),
          blurRadius: 13,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  Widget _iconCircle(
    IconData icon,
    Color iconColor,
    Color bgColor,
    double size,
  ) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: iconColor,
        size: size * .62,
      ),
    );
  }
}

// DECORATIVE BUILDINGS

class _BuildingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFF4A7B9);

    final baseY = size.height;

    // Building one
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .10,
        baseY * .40,
        size.width * .27,
        baseY * .60,
      ),
      paint,
    );

    // Building two
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .53,
        baseY * .10,
        size.width * .30,
        baseY * .90,
      ),
      paint,
    );

    // Building three
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .82,
        baseY * .35,
        size.width * .18,
        baseY * .65,
      ),
      paint,
    );

    // Roof
    final roof = Path()
      ..moveTo(size.width * .48, baseY * .10)
      ..lineTo(size.width * .68, 0)
      ..lineTo(size.width * .88, baseY * .10)
      ..close();

    canvas.drawPath(roof, paint);

    final windowPaint = Paint()
      ..color = Colors.white.withOpacity(.75);

    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 2; col++) {
        canvas.drawRect(
          Rect.fromLTWH(
            size.width * (.16 + col * .12),
            baseY * (.50 + row * .12),
            size.width * .045,
            baseY * .055,
          ),
          windowPaint,
        );

        canvas.drawRect(
          Rect.fromLTWH(
            size.width * (.58 + col * .13),
            baseY * (.20 + row * .15),
            size.width * .05,
            baseY * .065,
          ),
          windowPaint,
        );
      }
    }

    // Small decorative tree
    final treePaint = Paint()
      ..color = const Color(0xFFF5C58A);

    canvas.drawCircle(
      Offset(size.width * .43, baseY * .69),
      size.width * .075,
      treePaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .415,
        baseY * .70,
        size.width * .03,
        baseY * .30,
      ),
      treePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// MODELS

class _SummaryItem {
  final String title;
  final String count;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _SummaryItem(
    this.title,
    this.count,
    this.icon,
    this.iconColor,
    this.bgColor,
  );
}

class _QuickItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _QuickItem(
    this.title,
    this.icon,
    this.iconColor,
    this.bgColor,
  );
}

class _NavItem {
  final String title;
  final IconData icon;

  const _NavItem(this.title, this.icon);
}
