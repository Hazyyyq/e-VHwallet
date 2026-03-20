import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this to pubspec.yaml
import 'package:wallet_apps/Pages/payment_review_screen.dart';

class TransferAmountScreen extends StatefulWidget {
  final String merchantName;
  final String merchantLocation;
  final String qrData;

  const TransferAmountScreen({
    super.key,
    required this.merchantName,
    required this.merchantLocation,
    required this.qrData,
  });

  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends State<TransferAmountScreen> {
  // Store everything as an integer (cents) to keep the .00 format stable
  int _amountInCents = 0;

  // Helper to format the integer into a RM string (e.g., 500 -> 5.00)
  String get _formattedAmount {
    double dollars = _amountInCents / 100.0;
    return NumberFormat.currency(symbol: '', decimalDigits: 2).format(dollars);
  }

  void _updateAmount(String value) {
    setState(() {
      if (value == "back") {
        // Remove the last digit (Integer division by 10)
        _amountInCents = _amountInCents ~/ 10;
      } else if (value == "00") {
        // Add two zeros to the end
        if (_amountInCents > 0 && _amountInCents < 1000000) {
          _amountInCents = _amountInCents * 100;
        }
      } else {
        // Prevent amount from exceeding RM 99,999.99
        if (_amountInCents > 999999) return;

        // Shift existing digits left and add the new one
        int digit = int.parse(value);
        _amountInCents = (_amountInCents * 10) + digit;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Paying to",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            widget.merchantName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE4FF78),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white54, size: 16),
              const SizedBox(width: 4),
              Text(
                widget.merchantLocation,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
          
          const Spacer(),

          // --- The Cleaner Amount Display ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                "RM ",
                style: TextStyle(color: Colors.white54, fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Text(
                _formattedAmount,
                style: TextStyle(
                  color: _amountInCents > 0 ? Colors.white : Colors.white24,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Custom Numeric Keypad
          _buildNumericKeypad(),

          // Confirm Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE4FF78),
                  disabledBackgroundColor: Colors.white10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: _amountInCents > 0
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentReviewScreen(
                              merchantName: widget.merchantName,
                              merchantLocation: widget.merchantLocation,
                              amount: _formattedAmount,
                              qrData: widget.qrData,
                            ),
                          ),
                        )
                    : null,
                child: Text(
                  "CONFIRM",
                  style: TextStyle(
                    color: _amountInCents > 0 ? Colors.black : Colors.white30,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildKeyboardRow(["1", "2", "3"]),
          _buildKeyboardRow(["4", "5", "6"]),
          _buildKeyboardRow(["7", "8", "9"]),
          _buildKeyboardRow(["00", "0", "back"]),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: keys.map((key) {
          if (key == "back") {
            return IconButton(
              onPressed: () => _updateAmount("back"),
              icon: const Icon(Icons.backspace_outlined, color: Colors.white, size: 28),
            );
          }
          return InkWell(
            onTap: () => _updateAmount(key),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: const EdgeInsets.all(12),
              width: 70,
              child: Center(
                child: Text(
                  key,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}