import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.cardColour,
  });

  final String balance;
  final String cardColour;

  @override
  Widget build(BuildContext context) {
    final Color themeColor = Color(int.parse(cardColour));
    final Color textColor = ThemeData.estimateBrightnessForColor(themeColor) == Brightness.dark 
        ? Colors.white 
        : Colors.black87;

    return Container(
      height: 200, // Reduced back to 200 to fit your PageView better
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [themeColor, themeColor.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Subtle decoration
            Positioned(
              top: -30,
              right: -30,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: textColor.withOpacity(0.07),
              ),
            ),
            
            // Content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0), // Reduced padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Added this to prevent overflow
                  children: [
                    Text(
                      'BALANCE',
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 20, // Slightly smaller
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 8), // Reduced spacing
                    
                    // Balance Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'RM',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          balance,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 36, // Reduced from 44 to 36
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12), // Reduced spacing
                    
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_user_rounded, color: Color(0xFF39FF14), size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'Active Wallet',
                            style: TextStyle(
                              color: Color(0xFF39FF14) ,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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