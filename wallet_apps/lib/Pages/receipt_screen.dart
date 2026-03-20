import 'package:flutter/material.dart';
import 'package:wallet_apps/Utilities/receipt_download.dart';
import 'package:wallet_apps/routes/app_routes.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String merchantName;
  final String amount;
  final String refNumber;
  final String date;

  const PaymentSuccessScreen({
    super.key,
    required this.merchantName,
    required this.amount,
    required this.refNumber,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(),
              
              // 1. Success Animation/Icon
              const Icon(Icons.check_circle_rounded, color: Color(0xFFE4FF78), size: 100),
              const SizedBox(height: 24),
              const Text("Payment Successful", 
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text("RM $amount", 
                style: const TextStyle(color: Color(0xFFE4FF78), fontSize: 36, fontWeight: FontWeight.bold)),

              const SizedBox(height: 40),

              // 2. Receipt Details Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildRow("Recipient", merchantName),
                    _buildRow("Reference ID", refNumber),
                    _buildRow("Date", date),
                  ],
                ),
              ),

              const Spacer(),

              // 3. DOWNLOAD PDF BUTTON (The New Addition)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: Color(0xFFE4FF78)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFE4FF78)),
                  label: const Text("DOWNLOAD RECEIPT", 
                    style: TextStyle(color: Color(0xFFE4FF78), fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    // Trigger the utility we built
                    await DownloadReceipt.generatePdf(
                      merchantName: merchantName,
                      amount: amount,
                      refID: refNumber,
                      date: date,
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // 4. DONE BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE4FF78),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  ),
                  child: const Text("BACK TO HOME", 
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}