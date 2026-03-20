import 'package:flutter/material.dart';

class BankCard extends StatelessWidget {
  const BankCard({
    super.key,
    required this.username,
    required this.balance,
    required this.expiryDate,
    required this.cardNumber,
    required this.cardType,
    required this.cardColour, // Expecting a hex string like "0xFF6200EE"
  });

  final String username;
  final String balance;
  final String expiryDate;
  final String cardNumber;
  final String cardType;
  final String cardColour;

  @override
  Widget build(BuildContext context) {
    // Convert the string color to a Flutter Color object
    final Color themeColor = Color(int.parse(cardColour));

    return Container(
      height: 200,
            width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        // Dynamic gradient based on your cardColour input
        gradient: LinearGradient(
          colors: [
            themeColor,
            themeColor.withOpacity(0.7), // Creates a natural depth
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Abstract background decoration
            Positioned(
              right: -20,
              bottom: -20,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL BALANCE',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'RM $balance',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Dynamic Card Type Icon
                      Icon(
                        cardType.toLowerCase() == 'visa' 
                            ? Icons.credit_card 
                            : Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Masked Card Number
                  Text(
                    cardNumber, // e.g., "**** **** **** 1234"
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 2,
                      fontFamily: 'Courier', // Gives it a card-like feel
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARD HOLDER',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            username.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'EXPIRES',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            expiryDate, // Dynamic expiry
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
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
  }
}