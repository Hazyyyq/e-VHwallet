import 'package:flutter/material.dart';
import 'package:wallet_apps/Pages/receipt_screen.dart';

class PaymentReviewScreen extends StatelessWidget {
  final String merchantName;
  final String merchantLocation;
  final String amount;
  final String qrData; // Contains the Merchant ID/Account info
  final String bankName; // You can pass the bank name from the home card

  const PaymentReviewScreen({
    super.key,
    required this.merchantName,
    required this.merchantLocation,
    required this.amount,
    required this.qrData,
    this.bankName = "DuitNow / Bank Transfer",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Review Payment", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Big Amount Header
                  const SizedBox(height: 20),
                  const Text("Total Amount", style: TextStyle(color: Colors.white54)),
                  Text(
                    "RM $amount",
                    style: const TextStyle(
                      color: Color(0xFFE4FF78),
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Receipt-style Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildReviewRow("Recipient", merchantName, isBold: true),
                        _buildReviewRow("Location", merchantLocation),
                        _buildReviewRow("Payment Type", bankName),
                        const Divider(color: Colors.white12, height: 30),
                        _buildReviewRow("Merchant ID", _extractMerchantID(qrData)),
                        _buildReviewRow("Ref Number", "TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}"),
                        _buildReviewRow("Date", "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE4FF78),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  final String refID = "TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
  final String currentDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}";
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentSuccessScreen(
                        amount: amount,
                        merchantName: merchantName,
                        refNumber: refID,
                        date: currentDate,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "PAY NOW",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build the information rows
  Widget _buildReviewRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 14)),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Simple helper to get a chunk of the ID from QR Data
  String _extractMerchantID(String data) {
    // In EMVCo, the Merchant ID is usually in Tag 02-15 or similar. 
    // For now, we'll just show a shortened version of the raw data as a placeholder ID
    return data.length > 15 ? data.substring(0, 15).toUpperCase() : data;
  }
}