import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/providers/wallet_provider.dart';
import 'package:wallet_apps/Pages/receipt_screen.dart';

class PaymentReviewScreen extends StatefulWidget {
  final String merchantName;
  final String merchantLocation;
  final String amount;
  final String qrData;
  final String bankName;

  const PaymentReviewScreen({
    super.key,
    required this.merchantName,
    required this.merchantLocation,
    required this.amount,
    required this.qrData,
    this.bankName = "DuitNow / Bank Transfer",
  });

  @override
  State<PaymentReviewScreen> createState() => _PaymentReviewScreenState();
}

class _PaymentReviewScreenState extends State<PaymentReviewScreen> {
  bool _isProcessing = false;

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
                  const SizedBox(height: 20),
                  const Text("Total Amount", style: TextStyle(color: Colors.white54)),
                  Text(
                    "RM ${widget.amount}",
                    style: const TextStyle(
                      color: Color(0xFFE4FF78),
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildReviewRow("Recipient", widget.merchantName, isBold: true),
                        _buildReviewRow("Location", widget.merchantLocation),
                        _buildReviewRow("Payment Type", widget.bankName),
                        const Divider(color: Colors.white12, height: 30),
                        _buildReviewRow("Merchant ID", _extractMerchantID(widget.qrData)),
                        _buildReviewRow("Ref Number", "TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}"),
                        _buildReviewRow("Date", "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                onPressed: _isProcessing ? null : () async {
                  setState(() => _isProcessing = true);
                  
                  final wallet = Provider.of<WalletProvider>(context, listen: false);
                  final paymentAmount = double.tryParse(widget.amount) ?? 0.0;
                  
                  await wallet.makePayment(
                    amount: paymentAmount,
                    merchantName: widget.merchantName,
                    merchantLocation: widget.merchantLocation,
                    pin: '123456',
                  );

                  if (mounted) {
                    final String refID = "TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
                    final String currentDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}";
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentSuccessScreen(
                          amount: widget.amount,
                          merchantName: widget.merchantName,
                          refNumber: refID,
                          date: currentDate,
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  }
                },
                child: _isProcessing
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : const Text(
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

  String _extractMerchantID(String data) {
    return data.length > 15 ? data.substring(0, 15).toUpperCase() : data;
  }
}
