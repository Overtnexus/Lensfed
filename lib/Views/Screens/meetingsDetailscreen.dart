import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lensfed/Modals/meetings_modal.dart';
import 'package:lensfed/Provider/meeting_provider.dart';
import 'package:lensfed/Views/Screens/meetingsCheckinOUT_Screen.dart';
import 'package:lensfed/Views/Screens/meetingsQRcodeScreen.dart';
import 'package:provider/provider.dart';

class MeetingDetailsScreen extends StatefulWidget {
  const MeetingDetailsScreen({super.key});

  @override
  State<MeetingDetailsScreen> createState() => _MeetingDetailsScreenState();
}

class _MeetingDetailsScreenState extends State<MeetingDetailsScreen> {
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
    final meeting = provider.selectedMeeting;
    
    // --- MEDIA QUERY CONFIG ---
    final mq = MediaQuery.of(context);
    final W = mq.size.width;
    final H = mq.size.height;
    final isWeb = W > 800;

    if (meeting == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    DateTime date = DateFormat("dd-MM-yyyy").parse(meeting.meetingDate ?? "01-01-2024");

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey, size: W * 0.06 > 24 ? 24 : W * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(
          'Back to Meetings',
          style: TextStyle(
            color: Colors.grey,
            fontSize: W * 0.04 > 16 ? 16 : W * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: W * 0.05, vertical: H * 0.015),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(W * 0.04 > 16 ? 16 : W * 0.04),
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
                      // Top Gradient Border
                      Container(
                        height: H * 0.006,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(W * 0.04 > 16 ? 16 : W * 0.04),
                            topRight: Radius.circular(W * 0.04 > 16 ? 16 : W * 0.04),
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(W * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.assignment_outlined, color: Colors.brown, size: W * 0.075 > 32 ? 32 : W * 0.075),
                                SizedBox(width: W * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${meeting.meetingName}",
                                        style: TextStyle(
                                          fontSize: W * 0.05 > 22 ? 22 : W * 0.05,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: H * 0.01),
                                      Row(
                                        children: [
                                          _Tag(label: 'General', color: Colors.blue, width: W),
                                          SizedBox(width: W * 0.02),
                                          _StatusTag(label: 'Scheduled', color: Colors.green, width: W),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                _DateBadge(
                                  day: DateFormat("dd").format(date),
                                  month: DateFormat("MMM").format(date).toUpperCase(),
                                  width: W,
                                ),
                              ],
                            ),
                            SizedBox(height: H * 0.03),

                            // Dynamic Info Tiles
                            _buildInfoGrid(meeting, W),

                            Divider(height: H * 0.05, thickness: 1),

                            // Address Section
                            _ResponsiveHeader(icon: Icons.location_on_outlined, label: 'FULL ADDRESS', width: W),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: H * 0.015),
                              child: Text(
                                '${meeting.addressLine1 ?? ''}, ${meeting.addressLine2 ?? ''}, ${meeting.city ?? ''}, ${meeting.postalCode ?? ''}, ${meeting.state ?? ''}',
                                style: TextStyle(fontSize: W * 0.035 > 14 ? 14 : W * 0.035, color: Colors.black87),
                              ),
                            ),

                            Divider(height: H * 0.04, thickness: 1),

                            // Agenda Section
                            _ResponsiveHeader(icon: Icons.description_outlined, label: 'AGENDA', width: W),
                            SizedBox(height: H * 0.015),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(W * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(W * 0.03),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                '${meeting.meetingAgenda}',
                                style: TextStyle(
                                  fontSize: W * 0.038 > 14 ? 14 : W * 0.038, 
                                  color: Colors.black87, 
                                  height: 1.5
                                ),
                              ),
                            ),
                            SizedBox(height: H * 0.04),

                            // ACTION BUTTON
                            _AnimatedGradientButton(
                               label: 'Enter Meeting', 
                               width: W, 
                               height: H,
                               onTap: () {
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QRScannerScreen(selectedMeeting: meeting)));
                               }
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
        ),
      ),
    );
  }

  Widget _buildInfoGrid(MeetingModel meeting, double W) {
    return Column(
      children: [
        _InfoTile(icon: Icons.calendar_today_outlined, label: 'DATE', value: "${meeting.meetingDate}", width: W),
        _InfoTile(icon: Icons.access_time, label: 'TIME', value: '${meeting.meetingTime}', width: W),
        _InfoTile(icon: Icons.location_on_outlined, label: 'LOCATION', value: '${meeting.meetingLocation}', width: W),
        _InfoTile(icon: Icons.people_outline, label: 'ATTENDEES', value: '${meeting.meetingAttendees}', width: W),
        _InfoTile(icon: Icons.category_outlined, label: 'TYPE', value: '${meeting.meetingType}', width: W),
      ],
    );
  }
}

// --- SHARED RESPONSIVE COMPONENTS ---

class _ResponsiveHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final double width;
  const _ResponsiveHeader({required this.icon, required this.label, required this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: width * 0.045 > 18 ? 18 : width * 0.045, color: Colors.grey),
        SizedBox(width: width * 0.02),
        Text(
          label,
          style: TextStyle(
            fontSize: width * 0.03 > 12 ? 12 : width * 0.03, 
            color: Colors.grey, 
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}

class _AnimatedGradientButton extends StatelessWidget {
  final String label;
  final double width, height;
  final VoidCallback onTap;
  const _AnimatedGradientButton({required this.label, required this.width, required this.height, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height * 0.07 > 56 ? 56 : height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)]),
        boxShadow: [BoxShadow(color: const Color(0xFF7B61FF).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(Icons.qr_code_scanner, color: Colors.white, size: width * 0.05 > 24 ? 24 : width * 0.05),
        label: Text(label, style: TextStyle(color: Colors.white, fontSize: width * 0.04 > 16 ? 16 : width * 0.04, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final double width;
  const _InfoTile({required this.icon, required this.label, required this.value, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: width * 0.03),
      child: Container(
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: const Color(0xFF7B61FF), size: width * 0.05 > 20 ? 20 : width * 0.05),
            ),
            SizedBox(width: width * 0.04),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: width * 0.025 > 10 ? 10 : width * 0.025, color: Colors.grey, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: width * 0.035 > 14 ? 14 : width * 0.035, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
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
  final double width;
  const _Tag({required this.label, required this.color, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: color.withOpacity(0.5)), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: width * 0.03 > 12 ? 12 : width * 0.03, fontWeight: FontWeight.w500)),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String label;
  final Color color;
  final double width;
  const _StatusTag({required this.label, required this.color, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: color),
          SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: width * 0.03 > 12 ? 12 : width * 0.03, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  final String day, month;
  final double width;
  const _DateBadge({required this.day, required this.month, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(day, style: TextStyle(fontSize: width * 0.055 > 22 ? 22 : width * 0.055, fontWeight: FontWeight.bold, color: const Color(0xFF7B61FF))),
          Text(month, style: TextStyle(fontSize: width * 0.025 > 10 ? 10 : width * 0.025, color: const Color(0xFF7B61FF), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}