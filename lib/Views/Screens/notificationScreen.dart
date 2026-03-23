import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lensfed/Provider/notication_provider.dart';
import 'package:lensfed/utilities/colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
String formatFirestoreDate(String? raw) {
  if (raw == null || raw.isEmpty) return "";

  try {
    // CASE 1: Normal ISO string
    if (raw.contains("-")) {
      DateTime dt = DateTime.parse(raw);
      return DateFormat("dd MMM, hh:mm a").format(dt);
    }

    // CASE 2: Firestore {_seconds: ...}
    final secondsMatch = RegExp(r'_seconds:\s*(\d+)').firstMatch(raw);

    if (secondsMatch != null) {
      final seconds = int.parse(secondsMatch.group(1)!);
      DateTime dt =
          DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      return DateFormat("dd MMM, hh:mm a").format(dt);
    }

    return raw;
  } catch (e) {
    return raw;
  }
}
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;
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
        "NOTIFICATIONS",
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
      elevation: 3,
    ),

      body: Consumer<NotificationProvider>(
  builder: (context, provider, child) {

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.notifications.isEmpty) {
      return  Center(
        child: Text(
          "No Notifications",
          style: TextStyle(fontSize:  width * 0.04),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: provider.notifications.length,
        itemBuilder: (context, index) {

          final notification = provider.notifications[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.all(14),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ICON
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.blue,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// TITLE
                        Text(
                          notification.title ?? "",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// MESSAGE
                        Text(
                          notification.message ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
              GestureDetector(
  onTap: () async {
    String url = notification.attachment ?? "";

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid link")),
      );
      return;
    }

    // ✅ FIX: Add https if missing
    if (!url.startsWith("http")) {
      url = "https://$url";
    }

    final Uri uri = Uri.parse(url);

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open link")),
      );
    }
  },
  child: Text(
    notification.attachment ?? "",
    style: TextStyle(
      fontSize: 14,
      color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
  ),
),

                        const SizedBox(height: 8),

                        /// DATE
                        Row(
                          children: [

                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              formatFirestoreDate(notification.createDateTime ?? ""),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  },
)
    );
  }
}