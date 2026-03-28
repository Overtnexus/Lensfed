import 'package:flutter/material.dart';
import 'package:lensfed/Modals/meetings_modal.dart';
import 'package:lensfed/Provider/meeting_provider.dart';
import 'package:lensfed/Views/Screens/meetingsDetailscreen.dart';
import 'package:lensfed/utilities/colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<MeetingProvider>(context, listen: false).fetchMeeting();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<MeetingProvider>(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.meeting.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No Meetings")),
      );
    }

    DateTime today = DateTime.now();

    /// ✅ COUNT CALCULATION
    int upcomingCount = 0;
    int pastCount = 0;

    for (var meeting in provider.meeting) {
      DateTime meetingDate =
          DateFormat("dd-MM-yyyy").parse(meeting.meetingDate ?? "");

      if (meetingDate.isAfter(today) ||
          meetingDate.isAtSameMomentAs(today)) {
        upcomingCount++;
      } else {
        pastCount++;
      }
    }

    int allCount = provider.meeting.length;

    /// ✅ AUTO FIX TAB
    if (upcomingCount == 0 && selectedTab == 0) {
      selectedTab = 2;
    }

    /// NEXT MEETING
    List<MeetingModel> upcomingMeetings = [];

    for (var meeting in provider.meeting) {
      DateTime meetingDate =
          DateFormat("dd-MM-yyyy").parse(meeting.meetingDate ?? "");

      if (meetingDate.isAfter(today) ||
          meetingDate.isAtSameMomentAs(today)) {
        upcomingMeetings.add(meeting);
      }
    }

    upcomingMeetings.sort((a, b) {
      DateTime aDate =
          DateFormat("dd-MM-yyyy").parse(a.meetingDate ?? "");
      DateTime bDate =
          DateFormat("dd-MM-yyyy").parse(b.meetingDate ?? "");
      return aDate.compareTo(bDate);
    });

    MeetingModel? nextMeeting =
        upcomingMeetings.isNotEmpty ? upcomingMeetings.first : null;

    /// ✅ FILTER LOGIC
    List<MeetingModel> filteredMeetings = [];

    for (var meeting in provider.meeting) {

      DateTime meetingDate =
          DateFormat("dd-MM-yyyy").parse(meeting.meetingDate ?? "");

      if (selectedTab == 0 && upcomingCount > 0) {

        if (meetingDate.isAfter(today) ||
            meetingDate.isAtSameMomentAs(today)) {
          filteredMeetings.add(meeting);
        }

      } else if (selectedTab == 1 && pastCount > 0) {

        if (meetingDate.isBefore(today)) {
          filteredMeetings.add(meeting);
        }

      } else {

        filteredMeetings.add(meeting);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        toolbarHeight: height * 0.09,
        backgroundColor: const Color(0xff4f46e5),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: width * 0.06,
          ),
        ),
        title: Text(
          "MEETINGS",
          style: TextStyle(
            fontSize: width * 0.045,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(width * 0.08),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * .04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// NEXT MEETING CARD
            if (nextMeeting != null)
              meetingCard(nextMeeting, width),

            SizedBox(height: height * .03),

            /// TABS
            tabBar(width, upcomingCount, pastCount, allCount),

            SizedBox(height: height * .02),

            /// LIST
            filteredMeetings.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.05),
                      child: Text(
                        "No meetings found",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredMeetings.length,
                    itemBuilder: (context, index) {
                      final meeting = filteredMeetings[index];
                      return meetingCard(meeting, width);
                    },
                  )
          ],
        ),
      ),
    );
  }

  /// TAB BAR
  Widget tabBar(double width, int upcoming, int past, int all) {
    return Row(
      children: [

        if (upcoming > 0)
          tabButton("Upcoming", 0, width, upcoming),

        if (upcoming > 0)
          SizedBox(width: width * .02),

        if (past > 0)
          tabButton("Past", 1, width, past),

        if (past > 0)
          SizedBox(width: width * .02),

        tabButton("All", 2, width, all),
      ],
    );
  }

  Widget tabButton(String title, int index, double width, int count) {

    bool selected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * .04,
            vertical: width * .02),
        decoration: BoxDecoration(
          color: selected
              ? Colors.deepPurple.shade50
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? Colors.deepPurple
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          "$title ($count)",
          style: TextStyle(
            fontSize: width * .032,
            color: selected
                ? Colors.deepPurple
                : Colors.black87,
          ),
        ),
      ),
    );
  }

  /// KEEP YOUR EXISTING UI METHODS BELOW (UNCHANGED)

  /// MEETING CARD
  
  Widget meetingCard(MeetingModel meeting, double width) {

  DateTime date = DateFormat("dd-MM-yyyy").parse(meeting.meetingDate ?? "");

    return GestureDetector(
      onTap: () {
        final provider = Provider.of<MeetingProvider>(context, listen: false);

  provider.setSelectedMeeting(meeting);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MeetingDetailsScreen()));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: width * .04),
        padding: EdgeInsets.all(width * .04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6)
          ],
        ),
        child: Row(
          children: [
      
            /// DATE
            Column(
              children: [
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: width * .065,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(month(date.month)),
                Text(date.year.toString()),
              ],
            ),
      
            SizedBox(width: width * .04),
      
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
      
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
      
                      Expanded(
                        child: Text(
                          meeting.meetingName ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: width * .04,
                          ),
                        ),
                      ),
      
                      Row(
                        children: const [
                          Icon(Icons.circle,
                              size: 8, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            "Scheduled",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
      
                  SizedBox(height: width * .02),
      
                  Wrap(
                    spacing: width * .03,
                    children: [
      
                      smallInfo(Icons.access_time,
                          meeting.meetingTime ?? "", width),
      
                      smallInfo(Icons.location_on,
                          meeting.meetingLocation ?? "", width),
      
                      smallInfo(Icons.people,
                          meeting.meetingAttendees ?? "", width),
                    ],
                  ),
      
                  SizedBox(height: width * .02),
      
                  Chip(
                    label: Text(
                      meeting.meetingType ?? "",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: width * .03,
                      ),
                    ),
                    backgroundColor: Colors.deepPurple.shade50,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget smallInfo(
      IconData icon, String text, double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: width * .035,
            color: Colors.grey),
        SizedBox(width: width * .01),
        Text(text,
            style: TextStyle(fontSize: width * .03)),
      ],
    );
  }

  String month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }
}