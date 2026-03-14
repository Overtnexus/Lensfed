import 'package:flutter/material.dart';
import 'package:lensfed/Provider/notication_provider.dart';
import 'package:lensfed/utilities/colors.dart';
import 'package:provider/provider.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
      return const Center(
        child: Text(
          "No Notifications",
          style: TextStyle(fontSize: 16),
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

                  /// TEXT AREA
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
                              notification.createDateTime ?? "",
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