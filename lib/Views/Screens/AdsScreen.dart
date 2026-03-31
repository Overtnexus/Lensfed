import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lensfed/Modals/adverticement_modal.dart';
import 'package:lensfed/Provider/adverticement_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// Import your AdsProvider and AdModel paths here

class AdsViewScreen extends StatefulWidget {
  const AdsViewScreen({super.key});

  @override
  State<AdsViewScreen> createState() => _AdsViewScreenState();
}

class _AdsViewScreenState extends State<AdsViewScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch ads on init
    Future.microtask(() => 
      Provider.of<AdsProvider>(context, listen: false).fetchAds()
    );
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = context.watch<AdsProvider>();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
          ),
        ),
        title: const Text("ADVERTISEMENTS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: adsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : adsProvider.ads.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: adsProvider.ads.length,
                  itemBuilder: (context, index) {
                    final ad = adsProvider.ads[index];
                    return _buildAdCard(ad, width);
                  },
                ),
    );
  }

  Widget _buildAdCard(AdModel ad, double width) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          // Gradient Accent Top
          Container(
            height: 5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                // Ad Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     // _StatusBadge(label: _getAdStatus(ad), color: _getStatusColor(ad)),
                     // const SizedBox(height: 10),
                      Text(ad.title ?? "No Title", 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF101828))),
                        const SizedBox(height: 10),
                      GestureDetector(
  onTap: () async {
    final url = ad.attachmentLink ?? "";

    if (url.isNotEmpty) {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print("Could not launch $url");
      }
    }
  },
  child: Text(
    ad.attachmentLink ?? "No Link",
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color(0xFF101828),
      decoration: TextDecoration.underline, // 👈 makes it look like link
    ),
  ),
),
                      const SizedBox(height: 12),
                      _DateRow(icon: Icons.calendar_today, label: "START", date: ad.startDate),
                      const SizedBox(height: 5),
                      _DateRow(icon: Icons.event_busy, label: "EXPIRE", date: ad.endDate),
                    ],
                  ),
                ),
                // Action Menu
                IconButton(
                  onPressed: () => _showAdDetails(ad),
                  icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAdStatus(AdModel ad) {
    final now = DateTime.now();
    if (ad.endDate != null && ad.endDate!.isBefore(now)) return "EXPIRED";
    return "ACTIVE";
  }

  Color _getStatusColor(AdModel ad) {
    return _getAdStatus(ad) == "ACTIVE" ? const Color(0xFF10B981) : const Color(0xFFF04438);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No Advertisements Found", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  void _showAdDetails(AdModel ad) {
    // Implement detail view or zoom image here
  }
}

// --- Internal Helper Widgets ---

class _DateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final DateTime? date;

  const _DateRow({required this.icon, required this.label, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
        Text(date != null ? DateFormat('dd MMM yyyy').format(date!) : "N/A", 
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF344054))),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}