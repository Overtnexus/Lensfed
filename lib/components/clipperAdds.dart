import 'package:flutter/material.dart';
import 'package:lensfed/Modals/adverticement_modal.dart';
import 'package:lensfed/utilities/colors.dart';

class ModernAdPoster extends StatelessWidget {
  final AdModel ad;

  const ModernAdPoster({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220, // ✅ important for proper display
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            /// 1️⃣ Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.gradientPrimary,
              ),
            ),

            /// 2️⃣ Custom Shape Overlay
            ClipPath(
              clipper: PosterClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.02),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),

            /// 3️⃣ Decorative Circle
            Positioned(
              top: -40,
              right: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            /// 4️⃣ CONTENT
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// ACTIVE BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF10B981).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: Color(0xFF10B981),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "ACTIVE AD",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(Icons.auto_awesome,
                          color: Color(0xFFFBBF24)),
                    ],
                  ),

                  const Spacer(),

                  /// TITLE
                  Text(
                    ad.title ?? "Announcement",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// DATE
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          color: Colors.white70, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        ad.endDate != null
                            ? "Valid until ${ad.endDate!.day}/${ad.endDate!.month}/${ad.endDate!.year}"
                            : "No Expiry",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// BUTTON
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Tap for Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

/// ✅ FIXED CLIPPER (NO ERROR)
class PosterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(size.width * 0.3, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.85,
      size.width * 0.45,
      size.height,
    );

    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.75,
      size.width * 0.3,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}