import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lensfed/Provider/notication_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  DateTime? fromDate;
  DateTime? toDate;

  // --- HELPER METHODS ---
  String formatFullDate(String? raw) {
    DateTime? dt = parseToDateTime(raw);
    if (dt == null) return raw ?? "";
    return DateFormat("EEEE, MMMM dd, yyyy").format(dt);
  }

  String formatTime(String? raw) {
    DateTime? dt = parseToDateTime(raw);
    if (dt == null) return "--:--";
    return DateFormat("hh:mm a").format(dt);
  }

  String formatDay(String? raw) => DateFormat("dd").format(parseToDateTime(raw) ?? DateTime.now());
  String formatMonth(String? raw) => DateFormat("MMM").format(parseToDateTime(raw) ?? DateTime.now()).toUpperCase();

  DateTime? parseToDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      if (raw.contains("-")) return DateTime.parse(raw);
      final secondsMatch = RegExp(r'_seconds:\s*(\d+)').firstMatch(raw);
      if (secondsMatch != null) {
        return DateTime.fromMillisecondsSinceEpoch(int.parse(secondsMatch.group(1)!) * 1000);
      }
    } catch (_) {}
    return null;
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) fromDate = picked; else toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xff4f46e5),
        elevation: 0,
        title: const Text("NOTIFICATIONS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: _DateFilterTile(label: "From", date: fromDate, onTap: () => _selectDate(context, true))),
                const SizedBox(width: 12),
                Expanded(child: _DateFilterTile(label: "To", date: toDate, onTap: () => _selectDate(context, false))),
                IconButton(onPressed: () => setState(() { fromDate = null; toDate = null; }), icon: const Icon(Icons.refresh, color: Color(0xff4f46e5))),
              ],
            ),
          ),

          Expanded(
            child: Consumer<NotificationProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) return const Center(child: CircularProgressIndicator());

                final filteredList = provider.notifications.where((n) {
                  final date = parseToDateTime(n.createDateTime);
                  if (date == null) return true;
                  if (fromDate != null && date.isBefore(fromDate!)) return false;
                  if (toDate != null && date.isAfter(toDate!.add(const Duration(days: 1)))) return false;
                  return true;
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final n = filteredList[index];
                    return _NotificationCard(
                      title: n.title ?? "Update",
                      message: n.message ?? "",
                      date: formatFullDate(n.createDateTime),
                      onTap: () {
                        // Navigate to Beauty Details View
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationDetailsScreen(
                              title: n.title ?? "",
                              message: n.message ?? "",
                              rawDate: n.createDateTime,
                              attachment: n.attachment,
                              fullDate: formatFullDate(n.createDateTime),
                              time: formatTime(n.createDateTime),
                              day: formatDay(n.createDateTime),
                              month: formatMonth(n.createDateTime),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- BEAUTIFUL DETAILS SCREEN ---
class NotificationDetailsScreen extends StatelessWidget {
  final String title, message, fullDate, time, day, month;
  final String? rawDate, attachment;

  const NotificationDetailsScreen({
    super.key, required this.title, required this.message, required this.fullDate,
    required this.time, required this.day, required this.month, this.rawDate, this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.grey), onPressed: () => Navigator.pop(context)),
        titleSpacing: 0,
        title: const Text('Back to Notifications', style: TextStyle(color: Colors.grey, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Gradient Strip
              Container(
                height: 5,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.description_outlined, color: Colors.brown, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                              const SizedBox(height: 8),
                              _StatusTag(label: 'Notification', color: Colors.blue),
                            ],
                          ),
                        ),
                        _DateBadge(day: day, month: month),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _InfoTile(icon: Icons.calendar_today_outlined, label: 'DATE', value: fullDate),
                    _InfoTile(icon: Icons.access_time, label: 'TIME', value: time),
                    if (attachment != null && attachment!.isNotEmpty)
                      _InfoTile(icon: Icons.link, label: 'ATTACHMENT', value: 'Click to open file', isLink: true, url: attachment!),
                    
                    const Divider(height: 48, thickness: 1, color: Color(0xFFF2F4F7)),
                    
                    const Row(children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('MESSAGE CONTENT', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEAECF0))),
                      child: Text(message, style: const TextStyle(fontSize: 15, color: Color(0xFF344054), height: 1.6)),
                    ),
                    const SizedBox(height: 32),
                    
                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF3EFFF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Dismiss', style: TextStyle(color: Color(0xFF7B61FF), fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- SUPPORTING WIDGETS ---

class _NotificationCard extends StatelessWidget {
  final String title, message, date;
  final VoidCallback onTap;
  const _NotificationCard({required this.title, required this.message, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Container(height: 4, decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)]),
            )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.notifications_active_outlined, color: Color(0xFF7B61FF)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF101828))),
                      const SizedBox(height: 4),
                      Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool isLink;
  final String? url;
  const _InfoTile({required this.icon, required this.label, required this.value, this.isLink = false, this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLink && url != null ? () => launchUrl(Uri.parse(url!)) : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: const Color(0xFF7B61FF), size: 20)),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isLink ? Colors.blue : Colors.black87)),
              ]),
            ],
          ),
        ),
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
      decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Text(day, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF7B61FF))),
        Text(month, style: const TextStyle(fontSize: 10, color: Color(0xFF7B61FF), fontWeight: FontWeight.bold)),
      ]),
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
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class _DateFilterTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  const _DateFilterTile({required this.label, this.date, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
        child: Row(children: [
          const Icon(Icons.calendar_today, size: 16, color: Color(0xff4f46e5)),
          const SizedBox(width: 8),
          Text(date == null ? label : DateFormat('dd/MM/yy').format(date!), style: const TextStyle(fontSize: 13)),
        ]),
      ),
    );
  }
}