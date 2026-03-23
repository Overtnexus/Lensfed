import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_floating_navigation_bar/custom_floating_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lensfed/Modals/member_modal.dart';
import 'package:lensfed/Modals/notification_modal.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Provider/meeting_provider.dart';
import 'package:lensfed/Provider/member_provider.dart';
import 'package:lensfed/Provider/notication_provider.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';
import 'package:lensfed/Views/Screens/Meetings.dart';
import 'package:lensfed/Views/Screens/checkinOut.dart';
import 'package:lensfed/Views/Screens/notificationScreen.dart';
import 'package:lensfed/utilities/colors.dart';

import 'package:lensfed/utilities/fonts.dart';
import 'package:provider/provider.dart';

class ModuleItem {
  final String title;
  final String desc;
  final IconData icon;
  final Widget? screen;

  ModuleItem({
    required this.title,
    required this.desc,
    required this.icon,
    this.screen
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
    late PageController _pageController;
  int _currentPage = 0;
bool isUserTouching = false;

@override
void initState() {
  super.initState();
 _pageController = PageController(viewportFraction: 0.9);

  startAutoScroll();

  Future.microtask(() {
    Provider.of<MemberProvider>(context, listen: false).fetchMembers();
  });
 Future.microtask(() {
    Provider.of<MeetingProvider>(context, listen: false).fetchMeeting();
  });
  _tabController = TabController(length: 2, vsync: this);

  WidgetsBinding.instance.addPostFrameCallback((_) {

    final auth = Provider.of<AuthProvider>(context, listen: false);

    Provider.of<NotificationProvider>(context, listen: false)
    .loadNotifications(auth.role ?? "member");
     Future.microtask(() {
    context.read<NotificationProvider>().fetchNotification();
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {

  context.read<NotificationProvider>().fetchNotification();

});

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {

  print("Foreground notification received");

  if (message.notification != null) {

    print(message.notification!.title);
    print(message.notification!.body);

  }

});

  });
}
void startAutoScroll() {
  Future.delayed(const Duration(seconds: 3), () {

    if (!mounted || !_pageController.hasClients) return;

    if (isUserTouching) {
      startAutoScroll(); // pause when user touching
      return;
    }

    final provider =
        Provider.of<MeetingProvider>(context, listen: false);

    final meetings = provider.meeting.take(3).toList();

    if (meetings.isEmpty) return;

    _currentPage = (_currentPage + 1) % meetings.length;

    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    startAutoScroll();
  });
}
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
final formsTab = [
       ModuleItem(
      title: "Check In / Check Out",
      desc: "Meeting Times & track meetings",
      icon: Icons.timeline_sharp),
  ModuleItem(
      title: "Meetings",
      desc: "Track meetings",
      icon: Icons.calendar_today),
      // ModuleItem(
      // title: "Meetings Minutes",
      // desc: "Time & track meetings",
      // icon: Icons.timelapse),
     
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
    final authProvider = Provider.of<AuthProvider>(context);
final memberProvider = Provider.of<MemberProvider>(context);
final user = authProvider.user;
final loggedMember = memberProvider
    .getLoggedMember(authProvider.membershipId);

    final W = MediaQuery.of(context).size.width;
    final H = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: AppColors.foregroundDark,
       key: _scaffoldKey,
      drawer: _buildDrawer(context, loggedMember),
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
          Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   
                    GestureDetector(onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                      child: CircleAvatar(
                        radius: H *0.022 ,
                        backgroundColor: Colors.white,
                        child: Text(
                          user?["fullName"] != null
                              ? user!["fullName"][0].toUpperCase()
                              : "U",
                          style:  TextStyle(
                              fontSize: H *0.02 , fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Text("WELCOME",style: getFonts(W*0.05, AppColors.accentLight),),
                  Consumer<NotificationProvider>(
  builder: (context, provider, child) {
    return Stack(
      children: [

        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
            size: H * 0.04,
          ),
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationScreen(),
              ),
            );

          },
        ),

        if (provider.notifications.length > 0)
          Positioned(
            right: W*0.01,
            top: 6,
            child: Container(
              width: W*0.05,
              height: W*0.05,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(W*0.5),
              ),
              child: Center(
                child: Text(
                  provider.notifications.length.toString(),
                  style: getFonts(W*0.02,AppColors.accentLight ),
                ),
              ),
            ),
          ),

      ],
    );
  },
)
                  ],
                ),
                 const SizedBox(height: 10),
          Text(
                  "${user?["fullName"] ?? "User"} 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),

          SizedBox(height: screenWidth * 0.015), 

          Text(
            "The Licensed Engineers and Supervisors Federation (LESF) is an organization that represents the interests of licensed engineers, technical professionals, and supervisors across various industries.",
            style:drewerFonts()
          ),

          SizedBox(height: screenWidth * 0.01), 
    Consumer<MeetingProvider>(
  builder: (context, provider, child) {

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    if (provider.meeting.isEmpty) {
      return const SizedBox();
    }

    final meetings = provider.meeting.take(3).toList();

    return SizedBox(
      height: height * 0.22, // ✅ responsive height

      child: GestureDetector(
        onPanDown: (_) => isUserTouching = false,
        onPanEnd: (_) => isUserTouching = false,
        onPanCancel: () => isUserTouching = false,

        child: PageView.builder(
          controller: _pageController,
          itemCount: meetings.length,

          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },

          itemBuilder: (context, index) {

            final meeting = meetings[index];

            bool isActive = index == _currentPage;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,

              margin: EdgeInsets.symmetric(
                horizontal: width * 0.01,
                vertical: isActive
                    ? height * 0.01
                    : height * 0.02,
              ),

              transform: Matrix4.identity()
                ..scale(isActive ? 1.0 : 0.92),

              padding: EdgeInsets.all(width * 0.04),

              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(width * 0.05),

                gradient: LinearGradient(
                  colors: isActive
                      ? [Color(0xff4f46e5), Color(0xff6366f1)]
                      : [
                          Colors.grey.shade400,
                          Colors.grey.shade500
                        ],
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                        isActive ? 0.25 : 0.1),
                    blurRadius: isActive ? 12 : 6,
                    offset: const Offset(0, 5),
                  )
                ],
              ),

              child: Row(
                children: [

                  /// DATE BOX
                  Container(
                    width: width * 0.18,
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.015),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                          width * 0.04),
                    ),

                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          getDay(meeting.meetingDate),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          getMonth(meeting.meetingDate),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: width * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: width * 0.03),

                  /// DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [

                        Text(
                          meeting.meetingName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: height * 0.006),

                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.white70,
                                size: width * 0.035),
                            SizedBox(width: width * 0.01),
                            Expanded(
                              child: Text(
                                meeting.meetingLocation ?? "",
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: width * 0.032,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.006),

                        Row(
                          children: [
                            Icon(Icons.access_time,
                                color: Colors.white70,
                                size: width * 0.035),
                            SizedBox(width: width * 0.01),
                            Text(
                              meeting.meetingTime ?? "",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: width * 0.032,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.01),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.004,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            meeting.meetingType ?? "",
                            style: TextStyle(
                              color:
                                  const Color(0xff4f46e5),
                              fontSize: width * 0.028,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  },
),

          // GridView.count(
          //   crossAxisCount: gridCount,
          //   shrinkWrap: true,
          //   crossAxisSpacing: screenWidth * 0.03, 
          //   mainAxisSpacing: screenWidth * 0.02,  
          //   physics: const NeverScrollableScrollPhysics(),
          //   childAspectRatio: 1.5,
          //   children: [
          //     _statCard(context, "8", "Upcoming Meetings"),
          //     _statCard(context, "23", "Notifications"),
          //   ],
          // ),
        ],
      ),
    ),

    Expanded(
      child: _buildTabContent(formsTab),
    ),
  ],
),

    );
  }
String getDay(String? date) {
  if (date == null || date.isEmpty) return "--";
  try {
    final parts = date.split("-");
    return parts[0];
  } catch (e) {
    return "--";
  }
}

String getMonth(String? date) {
  if (date == null || date.isEmpty) return "";
  try {
    final parts = date.split("-");
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    int m = int.parse(parts[1]);
    return months[m - 1];
  } catch (e) {
    return "";
  }
}
Widget _buildDrawer(BuildContext context, MembersModal? member) {
  return Drawer(
    child: SafeArea(
      child: Column(
        children: [

          /// HEADER
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff6a11cb), Color(0xff2575fc)],
              ),
            ),
            accountName: Text(member?.fullName ?? "User"),
            accountEmail: Text("Member ID: ${member?.membershipId ?? ""}"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                member?.fullName != null
                    ? member!.fullName![0].toUpperCase()
                    : "U",
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /// DETAILS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [

                _infoTile(Icons.phone, "Mobile",
                    member?.contactNo ?? "-"),

                _infoTile(Icons.email, "Email",
                    member?.email ?? "-"),
                    _infoTile(Icons.location_on, "Email",
                    member?.area ?? "-"),
                    _infoTile(Icons.location_on_outlined, "Email",
                    member?.district ?? "-"),

             

                _infoTile(Icons.work, "Role",
                    member?.role ?? "Member"),
              ],
            ),
          ),

          /// LOGOUT
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              tileColor: Colors.red.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout2();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
            ),
          ),
        ],
      ),
    ),
  );
}
Widget _infoTile(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
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
                case "Check In / Check Out":
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CheckinOutScreen(),
                  ),
                );
                break;
                case "Meetings":
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MeetingScreen(),
                  ),
                );
                break;
               
                case "Notifications":
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationScreen(),
                  ),
                );
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

final List<ModuleItem> modules = [
  ModuleItem(
    icon: Icons.login,
    title: "Check In / Check Out",
    desc: "Mark attendance",
    screen: const CheckinOutScreen(),
  ),
  ModuleItem(
    icon: Icons.people,
    title: "Meetings",
    desc: "View meetings",
    screen: const MeetingScreen(),
  ),
  ModuleItem(
    icon: Icons.notifications,
    title: "Notifications",
    desc: "View alerts",
    screen: const NotificationScreen(),
  ),
  ModuleItem(
    icon: Icons.exit_to_app,
    title: "Exit",
    desc: "Close app",
  ),
];

  Widget _moduleCard(IconData icon, String title, String desc) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      color: AppColors.backgroundLight,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.05)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: screenWidth*0.08,
                backgroundColor: Colors.deepPurple.shade100,
                child: Icon(icon, color: Colors.deepPurple,size: screenWidth*0.08,),
              ),
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
        title:  Center(child: Text("Exit App",style: getFonts(15, AppColors.borderDark),)),
        content:  Text("Are you sure you want to exit?",style: drewerFonts(),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text("Cancel",style: getFonts(13, AppColors.primaryDark),),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child:  Text("Yes",style: getFonts(13, AppColors.primaryDark),),
          ),
        ],
      ),
    );
  }
}