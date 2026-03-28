import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lensfed/Modals/meetings_modal.dart';
import 'package:lensfed/Provider/meeting_provider.dart';
import 'package:lensfed/Views/Screens/meetingsCheckinOUT_Screen.dart';
import 'package:lensfed/Views/Screens/meetingsQRcodeScreen.dart';
import 'package:provider/provider.dart';

class MeetingDetailsScreen extends StatefulWidget {
 
  const MeetingDetailsScreen({super.key,});
  

  @override
  State<MeetingDetailsScreen> createState() => _MeetingDetailsScreenState();
}


class _MeetingDetailsScreenState extends State<MeetingDetailsScreen> {
  @override
void initState() {
  super.initState();

  Future.microtask(() {
    Provider.of<MeetingProvider>(context, listen: false)
        .fetchMeeting();
  });
}
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MeetingProvider>(context);
    final meeting = provider.selectedMeeting;
    DateTime date = DateFormat("dd-MM-yyyy").parse(meeting!.meetingDate ?? "");
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Back to Meetings',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Gradient Border Decoration
                  Container(
                    height: 4,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Date Badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.assignment_outlined, color: Colors.brown, size: 28),
                            const SizedBox(width: 12),
                             Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${meeting.meetingName}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _Tag(label: 'General', color: Colors.blue),
                                      SizedBox(width: 8),
                                      _StatusTag(label: 'Scheduled', color: Colors.green),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            _DateBadge(
  day: DateFormat("dd").format(date),
  month: DateFormat("MMM").format(date).toUpperCase(),
),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Info Tiles
                         _InfoTile(
                          icon: Icons.calendar_today_outlined,
                          label: 'DATE',
                          value: "${meeting.meetingDate}",
                        ),
                         _InfoTile(
                          icon: Icons.access_time,
                          label: 'TIME',
                          value: '${meeting.meetingTime}',
                        ),
                         _InfoTile(
                          icon: Icons.location_on_outlined,
                          label: 'LOCATION',
                          value: '${meeting.meetingLocation}',
                        ),
                         _InfoTile(
                          icon: Icons.people_outline,
                          label: 'EXPECTED ATTENDEES',
                          value: '${meeting.meetingAttendees}',
                        ),
                         _InfoTile(
                          icon: Icons.people_outline,
                          label: 'MEETING TYPE',
                          value: '${meeting.meetingType}',
                        ),
                         _InfoTile(
                          icon: Icons.people_outline,
                          label: 'MEETING STATUS',
                          value: '${meeting.meetingStatus}',
                        ),
                         _InfoTile(
                          icon: Icons.notifications_none_outlined,
                          label: 'REMINDER',
                          value: '${meeting.meetingReminder}',
                        ),

                        const Divider(height: 40, thickness: 1),

                        // Full Address Section
                        const Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'FULL ADDRESS',
                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                         Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                      '${meeting.addressLine1 ?? ''}, ${meeting.addressLine2 ?? ''}, ${meeting.city ?? ''}, ${meeting.postalCode ?? ''}, ${meeting.state ?? ''}, ${meeting.country ?? ''}'
                          ),
                        ),

                        const Divider(height: 30, thickness: 1),

                        // Agenda Section
                        const Row(
                          children: [
                            Icon(Icons.description_outlined, size: 18, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'AGENDA',
                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child:  Text(
                            '${meeting.meetingAgenda}',
                            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Enter Meeting Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7B61FF).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QRScannerScreen(selectedMeeting: meeting,)));

                            },
                            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                            label: const Text(
                              'Enter Meeting',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
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
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  final String day, month;
  const _DateBadge({required this.day, required this.month});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(day, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF7B61FF))),
          const SizedBox(height: 2),
          Text(month, style: const TextStyle(fontSize: 10, color: Color(0xFF7B61FF), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: const Color(0xFF7B61FF), size: 20),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}