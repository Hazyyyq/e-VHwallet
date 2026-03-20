import 'package:flutter/material.dart';

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
  String amount = "0";

  void _updateAmount(String value) {
    setState(() {
      if (value == "back") {
        if (amount.length > 1) {
          amount = amount.substring(0, amount.length - 1);
        } else {
          amount = "0";
        }
      } else if (value == ".") {
        if (!amount.contains(".")) {
          amount += ".";
        }
      } else {
        if (amount == "0") {
          amount = value;
        } else {
          // Limit to 2 decimal places
          if (amount.contains(".") && amount.split(".")[1].length >= 2) {
            return;
          }
          amount += value;
        }
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
            style: const TextStyle(
              color: Color(0xFFE4FF78),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4), // Small gap
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white54,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                widget.merchantLocation,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),

          // Amount Display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                "RM ",
                style: TextStyle(color: Colors.white54, fontSize: 24),
              ),
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: double.parse(amount) > 0
                    ? () {
                        // TODO: Proceed to PIN/Success Screen
                      }
                    : null,
                child: const Text(
                  "CONFIRM",
                  style: TextStyle(
                    color: Colors.black,
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
          _buildKeyboardRow([".", "0", "back"]),
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
              icon: const Icon(
                Icons.backspace_outlined,
                color: Colors.white,
                size: 28,
              ),
            );
          }
          return TextButton(
            onPressed: () => _updateAmount(key),
            child: Text(
              key,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
