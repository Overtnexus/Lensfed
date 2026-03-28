import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertisementScreen extends StatelessWidget {
  const AdvertisementScreen({super.key});

  // --- DUMMY DATA LIST ---
  final List<Map<String, dynamic>> dummyAds = const [
    {
      "title": "Annual Tech Conference 2024",
      "imageUrl": "https://images.unsplash.com/photo-1505373877841-8d25f7d46678?q=80&w=1000&auto=format&fit=crop",
      "startDate": "2024-10-15",
      "endDate": "2024-10-18",
      "link": "https://flutter.dev"
    },
    {
      "title": "Product Design Workshop",
      "imageUrl": "https://images.unsplash.com/photo-1586717791821-3f44a563dc4c?q=80&w=1000&auto=format&fit=crop",
      "startDate": "2024-11-05",
      "endDate": "2024-11-06",
      "link": "https://google.com"
    },
    {
      "title": "Exclusive Membership Launch",
      "imageUrl": "https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=1000&auto=format&fit=crop",
      "startDate": "2024-12-01",
      "endDate": "2024-12-31",
      "link": "https://apple.com"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final bool isTablet = width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xff4f46e5),
        elevation: 0,
        toolbarHeight: width * 0.16 > 75 ? 75 : width * 0.16,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: isTablet ? 28 : 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ADVERTISEMENTS",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: isTablet ? 24 : 18,
            letterSpacing: 1.2
          ),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(width * 0.06)),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, 
          vertical: 20
        ),
        itemCount: dummyAds.length,
        itemBuilder: (context, index) {
          final ad = dummyAds[index];
          return AdCard(
            title: ad['title'],
            imageUrl: ad['imageUrl'],
            startDate: ad['startDate'],
            endDate: ad['endDate'],
            link: ad['link'],
          );
        },
      ),
    );
  }
}

class AdCard extends StatelessWidget {
  final String title, imageUrl, startDate, endDate, link;

  const AdCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.link,
  });

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(link);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Could not launch $link");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width > 600;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06), 
            blurRadius: 20, 
            offset: const Offset(0, 10)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Gradient Top Line (Example 2 Style) ---
          Container(
            height: 5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)]),
            ),
          ),

          // --- Clickable Ad Image ---
          GestureDetector(
            onTap: _launchURL,
            child: ClipRRect(
              child: Image.network(
                imageUrl,
                height: width * 0.45 > 280 ? 280 : width * 0.45,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, _, __) => Container(
                  height: 180, color: Colors.grey[200], child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.campaign_rounded, color: Colors.brown, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 19, 
                              fontWeight: FontWeight.bold, 
                              color: const Color(0xFF101828)
                            ),
                          ),
                          const SizedBox(height: 6),
                          const _StatusBadge(label: "Promoted", color: Colors.blue),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32, thickness: 1, color: Color(0xFFF2F4F7)),

                // --- Details Tiles (Responsive) ---
                _ResponsiveDetailTile(
                  icon: Icons.calendar_today_outlined,
                  label: "START DATE",
                  value: _formatDate(startDate),
                ),
                _ResponsiveDetailTile(
                  icon: Icons.event_available_outlined,
                  label: "END DATE",
                  value: _formatDate(endDate),
                ),

                const SizedBox(height: 24),

                // --- Gradient Action Button ---
                GestureDetector(
                  onTap: _launchURL,
                  child: Container(
                    width: double.infinity,
                    height: width * 0.14 > 56 ? 56 : width * 0.14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)]),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B61FF).withOpacity(0.3), 
                          blurRadius: 12, 
                          offset: const Offset(0, 6)
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.open_in_browser, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          "Explore Website",
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold, 
                            fontSize: isTablet ? 18 : 16
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      DateTime dt = DateTime.parse(date);
      return DateFormat('EEEE, MMM d, yyyy').format(dt);
    } catch (_) {
      return date;
    }
  }
}

// --- HELPER COMPONENTS ---

class _ResponsiveDetailTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _ResponsiveDetailTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width > 600;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAECF0))
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF7B61FF), size: isTablet ? 26 : 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: isTablet ? 12 : 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: isTablet ? 16 : 14, fontWeight: FontWeight.bold, color: const Color(0xFF101828))),
            ],
          ),
        ],
      ),
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
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}