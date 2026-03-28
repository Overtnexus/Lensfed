import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lensfed/Modals/checkinOut_modal.dart';
import 'package:lensfed/Modals/meetings_modal.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Provider/checkinOut_provider.dart';
import 'package:provider/provider.dart';

class MeetingscheckinoutScreen extends StatefulWidget {
  final MeetingModel meeting;
  const MeetingscheckinoutScreen({super.key,required this.meeting});

  @override
  State<MeetingscheckinoutScreen> createState() => _MeetingscheckinoutScreenState();
}

class _MeetingscheckinoutScreenState extends State<MeetingscheckinoutScreen> {
  late Stopwatch _stopwatch;
late Timer _timer;

bool isRunning = true;

String hours = "00";
String minutes = "00";
String seconds = "00";

double progress = 0.0;
String elapsedText = "0m";

final int totalMinutes = 2;

DateTime? checkinDateTime;
bool isSubmitted = false;

void endMeeting({bool auto = false}) async {
  if (isSubmitted) return;

  isSubmitted = true;

  _stopwatch.stop();
  _timer.cancel();

  final checkoutDateTime = DateTime.now();

  /// 🔥 CALCULATE TOTAL TIME
  final difference = checkoutDateTime.difference(checkinDateTime!);

  String totalTime =
      "${difference.inHours}h ${difference.inMinutes % 60}m";

  final provider =
      Provider.of<CheckinOutProvider>(context, listen: false);

  /// 🔥 SEND FINAL DATA (CHECKOUT UPDATE)
  await provider.addCheckinout(
    CheckinoutModal(
      meetingSchedule: widget.meeting.id ?? "",
      checkinDate: DateFormat("yyyy-MM-dd").format(checkinDateTime!),
      checkinTime: DateFormat("HH:mm:ss").format(checkinDateTime!),
      member: "Rahul",
      checkoutTime: DateFormat("HH:mm:ss").format(checkoutDateTime),
      totalHrs: totalTime,
    ),
  );

  /// UI RESPONSE
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(auto ? "Meeting Auto Ended" : "Meeting Ended"),
      content: Text("Total Time: $totalTime"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text("OK"),
        )
      ],
    ),
  );
}

@override
void initState() {
  super.initState();

  /// ✅ START TIME (CHECK-IN)
  checkinDateTime = DateTime.now();

  _stopwatch = Stopwatch()..start();

  _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (_stopwatch.isRunning) {
      setState(() {
        final elapsed = _stopwatch.elapsed;

        /// ⏱ TIMER UI
        hours = elapsed.inHours.toString().padLeft(2, '0');
        minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
        seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');

        /// 📊 PROGRESS CALCULATION
        double elapsedSeconds = elapsed.inSeconds.toDouble();
        double totalSeconds = totalMinutes * 60;

        progress = elapsedSeconds / totalSeconds;

        if (progress > 1) progress = 1.0;

        /// ⏳ TEXT FORMAT
        elapsedText = "${(elapsedSeconds / 60).floor()}m";
      });

      /// ✅ AUTO SAVE WHEN TIME COMPLETES
      if (progress >= 1.0 && !isSubmitted) {
        isSubmitted = true;

        _stopwatch.stop();
        _timer.cancel();

        final checkoutDateTime = DateTime.now();

        final duration =
            checkoutDateTime.difference(checkinDateTime!);

        final totalTime =
            "${duration.inHours}h ${duration.inMinutes % 60}m";

        final provider =
            Provider.of<CheckinOutProvider>(context, listen: false);

        final authProvider =
            Provider.of<AuthProvider>(context, listen: false);

        await provider.addCheckinout(
          CheckinoutModal(
            meetingSchedule: widget.meeting.id ?? "",

            checkinDate: DateFormat("yyyy-MM-dd")
                .format(checkinDateTime!),

            checkinTime: DateFormat("HH:mm:ss")
                .format(checkinDateTime!),

            member: authProvider.user?["fullName"] ?? "Unknown",

            checkoutTime:
                DateFormat("HH:mm:ss").format(checkoutDateTime),

            totalHrs: totalTime,

          ),
        );

        /// OPTIONAL SUCCESS MESSAGE
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Meeting auto-ended & saved"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  });
}

@override
void dispose() {
  _timer.cancel();
  _stopwatch.stop();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final Size size = MediaQuery.of(context).size;
    final double horizontalPadding = size.width > 600 ? size.width * 0.1 : 20.0;
        DateTime date = DateFormat("dd-MM-yyyy").parse(widget.meeting.meetingDate ?? "");

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF667085)),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Back to Meetings',
          style: TextStyle(color: Color(0xFF667085), fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
        child: Column(
          children: [
            // --- TOP CARD: MEETING IN PROGRESS ---
            _CustomCard(
              child: Column(
                children: [
                  const _StatusBadge(label: 'MEETING IN PROGRESS', color: Color(0xFF027A48), bgColor: Color(0xFFECFDF3)),
                  const SizedBox(height: 16),
                   Text(
                    '${widget.meeting.meetingName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TimerBlock(value: hours, label: 'HOURS', size: size),
                      _TimerSeparator(size: size),
                      _TimerBlock(value: minutes, label: 'MINUTES', size: size),
                      _TimerSeparator(size: size),
                      _TimerBlock(value: seconds, label: 'SECONDS', size: size),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _ProgressBar(
  elapsed: elapsedText,
  total: "${totalMinutes}m",
  progress: progress,
),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                         onPressed: () {
  setState(() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      isRunning = false;
    } else {
      _stopwatch.start();
      isRunning = true;
    }
  });
},
                          icon: const Icon(Icons.check_box_outline_blank, color: Color(0xFF344054)),
                          label: const Text('Pause', style: TextStyle(color: Color(0xFF344054), fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFFD0D5DD)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                      onPressed: () async {
  if (isSubmitted) return;

  isSubmitted = true;

  _stopwatch.stop();
  _timer.cancel();

  final checkoutDateTime = DateTime.now();
  final difference = checkoutDateTime.difference(checkinDateTime!);

  String totalTime =
      "${difference.inHours}h ${difference.inMinutes % 60}m";

  final provider =
      Provider.of<CheckinOutProvider>(context, listen: false);

  await provider.addCheckinout(
    CheckinoutModal(
      meetingSchedule: widget.meeting.id ?? "",
      checkinDate:
          DateFormat("yyyy-MM-dd").format(checkinDateTime!),
      checkinTime:
          DateFormat("HH:mm:ss").format(checkinDateTime!),
      member: authProvider.user?["fullName"],
      checkoutTime:
          DateFormat("HH:mm:ss").format(checkoutDateTime),
      totalHrs: totalTime,
    ),
  );

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Meeting Ended"),
      content: Text("Total Time: $totalTime"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text("OK"),
        )
      ],
    ),
  );
},
                          icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                          label: const Text('End Meeting', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF04438),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- BOTTOM CARD: MEETING DETAILS ---
            _CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network('https://cdn-icons-png.flaticon.com/512/2991/2991108.png', width: 40, height: 40),
                      const SizedBox(width: 12),
                       Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.meeting.meetingName}',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                _Tag(label: 'General', color: Color(0xFF4A90E2)),
                                SizedBox(width: 8),
                                _StatusBadge(label: 'In Progress', color: Color(0xFF027A48), bgColor: Color(0xFFECFDF3), isSmall: true),
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
                   SizedBox(height: 24),
                   _InfoTile(icon: Icons.calendar_month_outlined, label: 'DATE', value: '${widget.meeting.meetingDate}'),
                   _InfoTile(icon: Icons.access_time, label: 'TIME', value: '${widget.meeting.meetingTime}'),
                   _InfoTile(icon: Icons.location_on_outlined, label: 'LOCATION', value: '${widget.meeting.meetingLocation}'),
                   _InfoTile(icon: Icons.people_outline, label: 'EXPECTED ATTENDEES', value: '${widget.meeting.meetingAttendees}'),
                   _InfoTile(icon: Icons.notifications_none_outlined, label: 'REMINDER', value: '${widget.meeting.meetingStatus}'),
                   Divider(height: 48, color: Color(0xFFEAECF0)),
                  
                  _SectionHeader(icon: Icons.description_outlined, title: 'AGENDA'),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAECF0)),
                    ),
                    child:  Text(
                      '${widget.meeting.meetingAgenda}',
                      style: TextStyle(fontSize: 14, color: Color(0xFF344054), height: 1.5),
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

// --- HELPER COMPONENTS ---

class _CustomCard extends StatelessWidget {
  final Widget child;
  const _CustomCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)]),
            ),
          ),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}

class _TimerBlock extends StatelessWidget {
  final String value, label;
  final Size size;
  const _TimerBlock({required this.value, required this.label, required this.size});

  @override
  Widget build(BuildContext context) {
    double boxSize = size.width < 400 ? 70 : 85;
    return Column(
      children: [
        Container(
          width: boxSize,
          height: boxSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(20)),
          child: Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF7B61FF))),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF667085), fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _TimerSeparator extends StatelessWidget {
  final Size size;
  const _TimerSeparator({required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width < 400 ? 4 : 8, vertical: 20),
      child: const Text(':', style: TextStyle(fontSize: 32, color: Color(0xFFD0D5DD), fontWeight: FontWeight.bold)),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String elapsed, total;
  final double progress;

  const _ProgressBar({
    required this.elapsed,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Elapsed',
                style: const TextStyle(
                    color: Color(0xFF667085), fontSize: 13)),
            Text('$elapsed of ~$total',
                style: const TextStyle(
                    color: Color(0xFF667085), fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: const Color(0xFFEAECF0),
            color: const Color(0xFF4A90E2),
          ),
        ),
      ],
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: const Color(0xFF7B61FF), size: 22),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF667085), fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF101828))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color, bgColor;
  final bool isSmall;
  const _StatusBadge({required this.label, required this.color, required this.bgColor, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmall ? 4 : 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3.5, backgroundColor: color),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.3))),
      child: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}

class _DateBadge extends StatelessWidget {
  final String day, month;
  const _DateBadge({required this.day, required this.month});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(day, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF7B61FF))),
          Text(month, style: const TextStyle(fontSize: 10, color: Color(0xFF7B61FF), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF667085)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF667085), fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  const _GradientButton({required this.onPressed, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)]),
        boxShadow: [BoxShadow(color: const Color(0xFF7B61FF).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
      ),
    );
  }
}