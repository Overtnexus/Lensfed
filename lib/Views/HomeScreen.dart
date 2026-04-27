import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lensfed/Modals/member_modal.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Provider/adverticement_provider.dart';
import 'package:lensfed/Provider/meeting_provider.dart';
import 'package:lensfed/Provider/member_provider.dart';
import 'package:lensfed/Provider/notication_provider.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';
import 'package:lensfed/Views/Screens/Meetings.dart';
import 'package:lensfed/Views/Screens/notificationScreen.dart';
import 'package:lensfed/Views/Screens/profile.dart';
import 'package:lensfed/components/clipperAdds.dart';
import 'package:lensfed/components/defaultposter.dart';
import 'package:lensfed/utilities/colors.dart';

import 'package:lensfed/utilities/fonts.dart';
import 'package:provider/provider.dart';
import 'package:super_animated_navigation_bar/super_animated_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool notificationInitialized = false;


@override
void initState() {
  super.initState();
 _pageController = PageController(viewportFraction: 0.9);
 WidgetsBinding.instance.addPostFrameCallback((_) {
      initNotificationPermission();
    });
  startAutoScroll();
    Future.microtask(() {
    Provider.of<AdsProvider>(context, listen: false).fetchAds();
  });

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


  });
}

Future<void> initNotificationPermission() async {
    if (notificationInitialized) return;

    notificationInitialized = true;

    final messaging =
        FirebaseMessaging.instance;

    /// ASK PERMISSION HERE
    NotificationSettings settings =
        await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint(
      "Permission Status: ${settings.authorizationStatus}",
    );

    if (settings.authorizationStatus ==
            AuthorizationStatus.authorized ||
        settings.authorizationStatus ==
            AuthorizationStatus.provisional) {
      final authProvider =
          Provider.of<AuthProvider>(
        context,
        listen: false,
      );

      final memberId =
          authProvider.membershipId ?? "";

      String? token =
          await messaging.getToken();

      debugPrint("MEMBER ID => $memberId");
      debugPrint("FCM TOKEN => $token");

      if (token != null &&
          memberId.isNotEmpty) {
        await context
            .read<NotificationProvider>()
            .saveDeviceTokenMAin(
              memberId: memberId,
              token: token,
            );
      }

      /// TOKEN REFRESH
      FirebaseMessaging.instance.onTokenRefresh
          .listen((newToken) async {
        await context
            .read<NotificationProvider>()
            .saveDeviceTokenMAin(
              memberId: memberId,
              token: newToken,
            );
      });
    }
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
                 SizedBox(height: H*0.003,),
          Text(
                  "${user?["fullName"] ?? "User"} 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      
          SizedBox(height: screenWidth * 0.013), 
      
          Text(
            "The Licensed Engineers and Supervisors Federation (LESF) is an organization that represents the interests of licensed engineers, technical professionals, and supervisors across various industries.",
            style:drewerFonts()
          ),
      
          SizedBox(height: screenWidth * 0.01), 
          
          beautifulImageSlider(context)
      
        ],
      ),
          ),
          SizedBox(height: H*0.003,),
          adsPosterSlider(),
        ],
      ),
bottomNavigationBar: Container(
  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
  child: SuperAnimatedNavBar(
    currentIndex: _currentPage,
  
    indeicatorDecoration: IndeicatorDecoration(
      indicatorType: IndicatorType.wave,
      indeicatorColor: Colors.deepPurple.shade900,
      glowEnable: true,
      glowColor: Colors.white,
      glowRadius: screenWidth * 0.06,
      indicatorPosition: IndicatorPosition.bottom,
      curve: Curves.easeInOutBack,
      animateDuration: const Duration(milliseconds: 800),
    ),
  
    items: [
    NavigationBarItem(
      selectedIcon: _navItem(Icons.home_filled, "Home", true),
      unSelectedIcon: _navItem(Icons.home_outlined, "Home", false),
    ),
  
    NavigationBarItem(
      selectedIcon: _navItem(Icons.calendar_today, "Meetings", true),
      unSelectedIcon: _navItem(Icons.calendar_today_outlined, "Meetings", false),
    ),
  
    NavigationBarItem(
      selectedIcon: _navItem(Icons.notifications, "Alerts", true),
      unSelectedIcon: _navItem(Icons.notifications_none, "Alerts", false),
    ),
     NavigationBarItem(
      selectedIcon: _navItem(Icons.person_3, "Profile", true),
      unSelectedIcon: _navItem(Icons.person_3, "Profile", false),
    ),
  ],
  
    
    onTap: (index) {
      setState(() => _currentPage = index);
  
      // 🔥 NAVIGATION WITHOUT CHANGING BODY
      switch (index) {
        case 0:
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
  
          break;
  
        case 1:
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MeetingScreen()));
  
          break;
  
        case 2:
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NotificationScreen()));
  
          break;
          case 3:
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen()));

          break;
      }
    },
  
    barHeight: H*0.09,
    backgroundColor: Colors.grey.shade100,
  ),
),
    );
  }

  Widget adsPosterSlider() {
  return Consumer<AdsProvider>(
    builder: (context, adsProvider, child) {
      final height = MediaQuery.of(context).size.height;
      final width = MediaQuery.of(context).size.width;

      // 1. FILTER: Active Ads Only logic
      final now = DateTime.now();
      final activeAds = adsProvider.ads.where((ad) {
        if (ad.startDate == null || ad.endDate == null) return true;
        return now.isAfter(ad.startDate!) && now.isBefore(ad.endDate!.add(const Duration(days: 1)));
      }).toList();

      if (adsProvider.isLoading) {
        return SizedBox(height: height * 0.28, child: const Center(child: CircularProgressIndicator()));
      }

      // 2. CONDITION: If empty, show the "Default Beautiful Poster"
      if (activeAds.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
          child: Column(
            children: [
              Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFFFBBF24), size: 18),
                const SizedBox(width: 8),
                Text("LATEST ONES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey[600])),
              ],
              
            ),
            SizedBox(height: width*0.01,),
              const DefaultAppPoster(),
            ],
          ), // The beautiful placeholder
        );
      }

      // 3. IF DATA EXISTS: Show the real slider
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFFFBBF24), size: 18),
                const SizedBox(width: 8),
                Text("LATEST UPDATES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.28,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              itemCount: activeAds.length,
              itemBuilder: (context, index) {
                return ModernAdPoster(ad: activeAds[index]);
              },
            ),
          ),
        ],
      );
    },
  );
}

// Widget adsPosterSlider() {
//   return Consumer<AdsProvider>(
//     builder: (context, adsProvider, child) {
//       final mq = MediaQuery.of(context);
//       final height = mq.size.height;
//       final width = mq.size.width;

//       // 🔥 Responsive scale factors
//       final padding = width * 0.035;
//       final smallGap = width * 0.015;
//       final iconSize = width * 0.04;
//       final fontSize = width * 0.032;

//       /// 1️⃣ FILTER: Active Ads Only
//       final now = DateTime.now();
//       final activeAds = adsProvider.ads.where((ad) {
//         if (ad.startDate == null || ad.endDate == null) return true;
//         return now.isAfter(ad.startDate!) &&
//             now.isBefore(ad.endDate!.add(const Duration(days: 1)));
//       }).toList();

//       /// LOADING
//       if (adsProvider.isLoading) {
//         return SizedBox(
//           height: height * 0.3,
//           child: const Center(child: CircularProgressIndicator()),
//         );
//       }

//       /// EMPTY
//       if (activeAds.isEmpty) return const SizedBox.shrink();

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// 🔹 HEADER
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: padding,
//               vertical: smallGap,
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.campaign,
//                   color: const Color(0xFF7C3AED),
//                   size: iconSize,
//                 ),
//                 SizedBox(width: smallGap),
//                 Text(
//                   "SPECIAL NOTICES",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: fontSize,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           /// 🔹 SLIDER
//           SizedBox(
//             height: height * 0.3,
//             child: PageView.builder(
//               controller: PageController(
//                 viewportFraction: width < 600 ? 0.92 : 0.7, // 🔥 responsive
//               ),
//               itemCount: activeAds.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: width * 0.01),
//                   child: GestureDetector(
//                     onTap: () async {
//                       final link = activeAds[index].attachmentLink;
//                       if (link != null) {
//                         await launchUrl(
//                           Uri.parse(link),
//                           mode: LaunchMode.externalApplication,
//                         );
//                       }
//                     },
//                     child: ModernAdPoster(ad: activeAds[index]),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

  
Widget beautifulImageSlider(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  final List<String> images = [
    "assets/checkin.png",
    "assets/meetings.png",
    "assets/members.png",
  ];

  final PageController controller =
      PageController(viewportFraction: 0.9);

  return StatefulBuilder(
    builder: (context, setState) {
      int currentPage = 0;

      return Column(
        children: [
          SizedBox(
            height: height * 0.21,
            child: PageView.builder(
              controller: controller,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() => currentPage = index);
              },
              itemBuilder: (context, index) {

                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                  ),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.05),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(width * 0.05),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),

           SizedBox(height:width*0.02 ),

          /// 🔥 DOT INDICATOR
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin:  EdgeInsets.symmetric(horizontal: height * 0.005),
                width: currentPage == index ? 14 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? Colors.deepPurple
                      : Colors.white,
                  borderRadius: BorderRadius.circular(width*0.02),
                ),
              );
            }),
          ),
        ],
      );
    },
  );
}

  Widget _navItem(IconData icon, String label, bool isSelected) {
    final W = MediaQuery.of(context).size.width;
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: isSelected ? W * 0.07 : W * 0.06,
        color: isSelected ? Colors.deepPurple.shade900 : Colors.grey,
      ),
       SizedBox(height: W*0.001),
      Text(
        label,
        style: btmNav()
      ),
    ],
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
  final W = MediaQuery.of(context).size.width;
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
                style:  TextStyle(
                    fontSize: W * 0.06, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /// DETAILS
          Expanded(
            child: ListView(
              padding:  EdgeInsets.symmetric(horizontal:  W* 0.04),
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
            padding:  EdgeInsets.all(W* 0.04),
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
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;

  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: h * 0.01, // 8
    ),
    child: Container(
      padding: EdgeInsets.all(w * 0.03), // 12
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(w * 0.03), // 12
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blueAccent,
            size: w * 0.05, // responsive icon size
          ),

          SizedBox(width: w * 0.03), // 12

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: w * 0.03, // 12
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: h * 0.005), // 4

                Text(
                  value,
                  style: TextStyle(
                    fontSize: w * 0.037, // 15
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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