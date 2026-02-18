import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lensfed/Views/Screens/Addmember.dart';
import 'package:lensfed/Views/Screens/Meetings.dart';
import 'package:lensfed/Views/Screens/Membership.dart';
import 'package:lensfed/Views/Screens/checkinOut.dart';
import 'package:lensfed/Views/Screens/payments.dart';
import 'package:lensfed/Views/Screens/units.dart';

class ModuleItem {
  final String title;
  final String desc;
  final IconData icon;

  ModuleItem({
    required this.title,
    required this.desc,
    required this.icon,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
final formsTab = [
  ModuleItem(
      title: "Add Members",
      desc: "Create & update Members",
      icon: Icons.person),
      ModuleItem(
      title: "Membership",
      desc: "Manage members",
      icon: Icons.people),
      ModuleItem(
      title: "Units",
      desc: "Area configarations",
      icon: Icons.area_chart),
  ModuleItem(
      title: "Meetings Schedule",
      desc: "Schedule & track meetings",
      icon: Icons.calendar_today),
      ModuleItem(
      title: "Meetings Minutes",
      desc: "Time & track meetings",
      icon: Icons.timelapse),
      ModuleItem(
      title: "Check In / Check Out",
      desc: "Meeting Times & track meetings",
      icon: Icons.timeline_sharp),
  
  ModuleItem(
      title: "Payments",
      desc: "Fees & transactions",
      icon: Icons.payment),
      ModuleItem(
      title: "Notifications",
      desc: "Remind",
      icon: Icons.notification_add),
  ModuleItem(
      title: "Exit",
      desc: "Close application",
      icon: Icons.exit_to_app),
];

final reportTab = [
  ModuleItem(
      title: "Meetings Report",
      desc: "Schedule & track meetings",
      icon: Icons.calendar_today),
  ModuleItem(
      title: "Membership Report",
      desc: "Manage members",
      icon: Icons.people),
  ModuleItem(
      title: "Payments Report",
      desc: "Fees & transactions",
      icon: Icons.payment),
  ModuleItem(
      title: "Exit",
      desc: "Close application",
      icon: Icons.exit_to_app),
];

    final width = MediaQuery.of(context).size.width;

    int gridCount = 2;
    if (width > 1000) {
      gridCount = 4;
    } else if (width > 600) {
      gridCount = 3;
    }
     final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
  children: [
    Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.05,   
        screenWidth * 0.12,   
        screenWidth * 0.05,   
        screenWidth * 0.05,   
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff6a11cb), Color(0xff2575fc)],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(
            screenWidth * 0.07, 
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back, John Doe! 👋",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: screenWidth * 0.015), 

          Text(
            "Manage your federation effortlessly. Access forms, track reports, and stay updated — all in one place.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: screenWidth * 0.035,
            ),
          ),

          SizedBox(height: screenWidth * 0.03), 

          GridView.count(
            crossAxisCount: gridCount,
            shrinkWrap: true,
            crossAxisSpacing: screenWidth * 0.03, 
            mainAxisSpacing: screenWidth * 0.02,  
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              _statCard(context, "8", "Upcoming Meetings"),
              _statCard(context, "23", "Notifications"),
            ],
          ),
        ],
      ),
    ),

    SizedBox(height: screenWidth * 0.04), 
    Expanded(
      child: _buildTabContent(formsTab),
    ),
  ],
)
    );
  }

Widget _statCard(
  BuildContext context,
  String value,
  String label,
) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Container(
    padding: EdgeInsets.all(screenWidth * 0.03), // was 12
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(
        screenWidth * 0.04, // was 16
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.045, // was 18
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: screenWidth * 0.01, // was 4
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: screenWidth * 0.03, // was 12
          ),
        ),
      ],
    ),
  );
}

Widget _buildTabContent(List<ModuleItem> modules) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final gridItemWidth = screenWidth * 0.4;
  final gridItemHeight = screenHeight * 0.25;

  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: screenHeight * 0.01,
      horizontal: screenWidth * 0.04,
    ),
    child: GridView.builder(
      itemCount: modules.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 900
            ? 4
            : screenWidth > 600
                ? 3
                : 2,
        mainAxisSpacing: screenHeight * 0.02,
        crossAxisSpacing: screenWidth * 0.03,
        childAspectRatio: gridItemWidth / gridItemHeight,
      ),
      itemBuilder: (context, index) {
        final module = modules[index];

        return GestureDetector(
          onTap: () {
            switch (module.title) {

              case "Add Members":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddmemberScreen(),
                  ),
                );
                break;

              case "Membership":
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MembershipRenewalScreen(),
                  ),
                );
                break;
                case "Units":
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UnitScreen(),
                  ),
                );
                break;
                case "Meetings Schedule":
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MeetingsScreen(),
                  ),
                );
                break;
                case "Meetings Minutes":
                // Navigator.push(...);
                break;
                case "Check In / Check Out":
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CheckinOutScreen(),
                  ),
                );
                break;
                case "Payments":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentScreen(),
                  ),
                );
                break;
                case "Notifications":
                // Navigator.push(...);
                break;

              case "Exit":
                _exitApp();
                break;

            }
          },
          child: _moduleCard(
            module.icon,
            module.title,
            module.desc,
          ),
        );
      },
    ),
  );
}

Widget _buildReportTabContent(List<ModuleItem> modules) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: screenHeight * 0.01,
      horizontal: screenWidth * 0.04,
    ),
    child: GridView.builder(
      itemCount: modules.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 900
            ? 4
            : screenWidth > 600
                ? 3
                : 2,
        mainAxisSpacing: screenHeight * 0.02,
        crossAxisSpacing: screenWidth * 0.03,
        childAspectRatio: screenWidth > 900
            ? 1.3
            : screenWidth > 600
                ? 1.2
                : 1.1,
      ),
      itemBuilder: (context, index) {
        final module = modules[index];

        return GestureDetector(
          onTap: () {
            switch (module.title) {

              case "Meetings Repot":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MembershipRenewalScreen(),
                  ),
                );
                break;

              case "Payments Report":
                // Navigator.push(...);
                break;

              case "Membership Report":
                // Navigator.push(...);
                break;

              case "Exit":
                _exitApp();
                break;

            }
          },
          child: _moduleCard(
            module.icon,
            module.title,
            module.desc,
          ),
        );
      },
    ),
  );
}

  Widget _moduleCard(IconData icon, String title, String desc) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.05)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepPurple.shade100,
              child: Icon(icon, color: Colors.deepPurple),
            ),
           SizedBox(height: screenWidth * 0.04),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
            SizedBox(height: screenWidth * 0.01),
            Text(desc,
                style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _reportTile(String title, String subtitle,BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      margin:EdgeInsets.only(bottom: screenWidth * 0.03),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.04)),
      child: ListTile(
        leading: const Icon(Icons.bar_chart, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

   void _exitApp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}