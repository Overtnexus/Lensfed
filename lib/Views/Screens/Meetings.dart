import 'package:flutter/material.dart';

class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({super.key});

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  final List<Map<String, dynamic>> upcoming = [
    {
      "title": "Annual General Body Meeting",
      "date": "Feb 28, 2026",
      "time": "10:00 AM",
      "venue": "Mumbai Convention Center",
      "participants": 45,
      "type": "General"
    },
    {
      "title": "Photography Workshop Planning",
      "date": "Mar 5, 2026",
      "time": "2:00 PM",
      "venue": "Online - Zoom",
      "participants": 12,
      "type": "Workshop"
    },
  ];

  final List<Map<String, dynamic>> past = [
    {
      "title": "Year-End Review 2025",
      "date": "Dec 20, 2025",
      "time": "10:00 AM",
      "venue": "Chennai Hall",
      "participants": 38,
      "type": "Review"
    },
  ];

  List<Map<String, dynamic>> get myMeetings =>
      [upcoming[0], past[0]];

  Color getTypeColor(String type) {
    switch (type) {
      case "General":
        return Colors.blue;
      case "Workshop":
        return Colors.purple;
      case "Finance":
        return Colors.green;
      case "Onboarding":
        return Colors.orange;
      case "Review":
        return Colors.grey;
      case "Contest":
        return Colors.pink;
      case "Board":
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),
      appBar: AppBar(
        title: const Text("Meetings"),
        backgroundColor: Colors.indigo,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Upcoming (${upcoming.length})"),
            const Tab(text: "Past"),
            const Tab(text: "My Meetings"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildMeetingGrid(upcoming),
          buildMeetingGrid(past),
          buildMeetingGrid(myMeetings),
        ],
      ),
    );
  }

  Widget buildMeetingGrid(List<Map<String, dynamic>> list) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, index) {
            return MeetingCard(
              meeting: list[index],
              color: getTypeColor(list[index]["type"]),
            );
          },
        );
      },
    );
  }
}

class MeetingCard extends StatelessWidget {
  final Map<String, dynamic> meeting;
  final Color color;

  const MeetingCard({
    super.key,
    required this.meeting,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  meeting["title"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  meeting["type"],
                  style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),

          const SizedBox(height: 14),

          infoRow(Icons.calendar_today, meeting["date"]),
          infoRow(Icons.access_time, meeting["time"]),
          infoRow(Icons.location_on, meeting["venue"]),
          infoRow(Icons.people, "${meeting["participants"]} participants"),
        ],
      ),
    );
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}