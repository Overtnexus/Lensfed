import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:lensfed/Modals/meetings_modal.dart';
import 'package:lensfed/Views/Screens/meetingsCheckinOUT_Screen.dart';

class QRScannerScreen extends StatefulWidget {
  final MeetingModel selectedMeeting;

  const QRScannerScreen({super.key, required this.selectedMeeting});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isScanned = false;

  // --- KEPT FUNCTIONS EXACTLY AS PROVIDED ---
  String normalize(String? value) {
    if (value == null) return "";
    return value.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  void validateQR(String code) {
    try {
      final parts = code.split("|");
      if (parts.length < 3) {
        showError("");
        return;
      }

      final scannedId = normalize(parts[0]);
      final scannedName = normalize(parts[1]);
      final scannedDate = normalize(parts[2]);

      final meetingId = normalize(widget.selectedMeeting.id);
      final meetingName = normalize(widget.selectedMeeting.meetingName);
      final meetingDate = normalize(widget.selectedMeeting.meetingDate);

      if (scannedId == meetingId && scannedName == meetingName && scannedDate == meetingDate) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ QR Verified Successfully"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MeetingscheckinoutScreen(
              meeting: widget.selectedMeeting,
            ),
          ),
        );
      } else {
        showError("This QR is not for this meeting");
      }
    } catch (e) {
      showError("Invalid QR Code");
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
    setState(() {
      isScanned = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.qr_code_scanner, color: Color(0xFF7B61FF)),
                  const SizedBox(width: 8),
                  const Text(
                    'Scan QR to Enter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B61FF),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- SCANNER AREA ---
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF7B61FF).withOpacity(0.2),
                            width: 1.5,
                            style: BorderStyle.solid, // Note: For dashed border, use a custom painter or package
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              MobileScanner(
                                onDetect: (BarcodeCapture capture) {
                                  if (isScanned) return;
                                  final barcode = capture.barcodes.first;
                                  final code = barcode.rawValue;
                                  if (code != null) {
                                    isScanned = true;
                                    validateQR(code);
                                  }
                                },
                              ),
                              
                              // Placeholder / Overlay UI from the image
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_outlined, size: 48, color: Colors.grey),
                                  SizedBox(height: 12),
                                  Text(
                                    'Activating camera...',
                                    style: TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),

                              // Corner Brackets
                              const _ScannerCorners(color: Color(0xFF7B61FF)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Position the QR code within the frame to check in',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 48),

                    // --- CANCEL BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF3EFFF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF7B61FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerCorners extends StatelessWidget {
  final Color color;
  const _ScannerCorners({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double size = constraints.maxWidth * 0.5;
        const double thickness = 4.0;
        const double length = 30.0;

        return Stack(
          children: [
            // Top Left
            Positioned(top: 60, left: 60, child: _corner(0, 0)),
            // Top Right
            Positioned(top: 60, right: 60, child: _corner(0, 1)),
            // Bottom Left
            Positioned(bottom: 60, left: 60, child: _corner(1, 0)),
            // Bottom Right
            Positioned(bottom: 60, right: 60, child: _corner(1, 1)),
          ],
        );
      },
    );
  }

  Widget _corner(int v, int h) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: v == 0 ? BorderSide(color: color, width: 4) : BorderSide.none,
          bottom: v == 1 ? BorderSide(color: color, width: 4) : BorderSide.none,
          left: h == 0 ? BorderSide(color: color, width: 4) : BorderSide.none,
          right: h == 1 ? BorderSide(color: color, width: 4) : BorderSide.none,
        ),
      ),
    );
  }
}