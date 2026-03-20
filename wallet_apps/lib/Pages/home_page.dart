// ================= Others Import ===============
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
<<<<<<< HEAD
=======
import 'package:permission_handler/permission_handler.dart';

// ================= Pages Import ===============
import 'package:wallet_apps/Pages/qr_scanner_screen.dart';
import 'package:wallet_apps/Pages/transfer_amount_screen.dart';
import 'package:wallet_apps/Pages/payment_review_screen.dart';
>>>>>>> origin/main

// ================= Components Import ===============
import 'package:wallet_apps/Components/balance_card.dart';
import 'package:wallet_apps/Components/bank_card.dart';

<<<<<<< HEAD
=======
// ================= Utilities Import ===============
import 'package:wallet_apps/Utilities/qr_parser.dart';

>>>>>>> origin/main
// ================= Home Screen ===============

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.username});

  final String title;
  final String username;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controller
  final page_controller = PageController();

  // Initilization

  int currentIconIndex = 0;

  @override
  void dispose() {
    page_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.white54,
=======
      backgroundColor: const Color(0xFFF5F5F7),
>>>>>>> origin/main
      body: SafeArea(
        child: Column(
          children: [
            // appbar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  // profile picture
                  const Icon(
                    Icons.person_3_rounded,
                    size: 45,
                    color: Color.fromARGB(255, 63, 61, 61),
                  ),
                  SizedBox(width: 10),

                  // welcome message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),

                      Text(
                        widget.username,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Add Card
                  Spacer(),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIconIndex = -1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 217, 215, 215),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              118,
                              117,
                              117,
                            ).withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // shadow offset
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // cards
<<<<<<< HEAD
            SizedBox(
=======
            Container(
>>>>>>> origin/main
              height: 200,
              child: PageView(
                controller: page_controller,
                scrollDirection: Axis.horizontal,
                children: [
                  BalanceCard(balance: "150.50", cardColour: "0xFF000000"),
                  // Maybank
                  BankCard(
                    username: widget.username,
                    balance: "2,450.50",
                    expiryDate: "12/28",
                    cardNumber: "**** **** **** 1234",
                    cardType: "Maybank",
                    cardColour: "0xFFE5B800", // Maybank Dark Yellow
                  ),

                  // RHB
                  BankCard(
                    username: widget.username,
                    balance: "1,120.00",
                    expiryDate: "05/27",
                    cardNumber: "**** **** **** 8890",
                    cardType: "RHB",
                    cardColour: "0xFF5BC2E7", // RHB Blue
                  ),

                  // Bank Rakyat
                  BankCard(
                    username: widget.username,
                    balance: "5,300.20",
                    expiryDate: "09/26",
                    cardNumber: "**** **** **** 4456",
                    cardType: "BankRakyat",
                    cardColour: "0xFF005CAB", // Bank Rakyat Blue
                  ),
                ],
              ),
            ),

            // dot indicator
            const SizedBox(height: 15),

            SmoothPageIndicator(
              controller: page_controller,
              count: 4,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.black,
                dotColor: Colors.grey.withOpacity(0.4),
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
              onDotClicked: (index) {
                page_controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),

            // buttons

            // column of buttons (send, receive, swap
          ],
        ),
      ),
<<<<<<< HEAD
=======

      //bottom navigation bar

      // floating action button (QR code scanner)
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () async {
            // 1. Check for Camera Permission
            var status = await Permission.camera.status;

            if (status.isDenied) {
              status = await Permission.camera.request();
            }

            if (status.isGranted) {
              // 2. Set index and Navigate to QR Scanner
              setState(() => currentIconIndex = -1);

              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => const QrScannerScreen(),
                ),
              );

              // 3. Handle the result
              if (result != null && mounted) {
                final String rawValue = result['rawValue'];
                //final Map<String, String> data = QrParser.parseEmvco(result,);
                final Map<String, String> data = result['data'];
                final bool isDynamic = result['isDynamic'] ?? false;
                final String? amountFromQr = result['amount'];

                // Parse data to get the Merchant Name for the next screen

                String merchantName = data['59'] ?? "Unknown Merchant";
                String city = data['60'] ?? "Unknown City";
                String countryCode = data['58'] ?? "MY";

                String displayLocation;

                // If city and country are the same, or city is missing, just show "Malaysia"
                if (city.isEmpty || city == countryCode) {
                  displayLocation = city;
                } else {
                  displayLocation = "$city, $countryCode";
                } // Navigate to TransferAmountScreen
                if (isDynamic && amountFromQr != null) {
                  // 🚀 DYNAMIC: Jump straight to Review Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentReviewScreen(
                        merchantName: merchantName,
                        merchantLocation: displayLocation,
                        amount: amountFromQr,
                        qrData: rawValue,
                      ),
                    ),
                  );
                } else {
                  // 💰 STATIC: Go to Enter Amount Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransferAmountScreen(
                        merchantName: merchantName,
                        merchantLocation: displayLocation,
                        qrData: rawValue,
                      ),
                    ),
                  );
                }
              }
            } else if (status.isPermanentlyDenied) {
              // Open app settings if blocked permanently
              openAppSettings();
            }
          },
          elevation: 4,
          backgroundColor: const Color.fromARGB(255, 228, 255, 120),
          shape: CircleBorder(
            side: BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
          ),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.black,
            size: 50,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // bottom navigation bar (menus icons)
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home_rounded, size: 35),
              color: currentIconIndex == 0 ? Colors.black : Colors.black54,
              onPressed: () {
                setState(() {
                  currentIconIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.account_balance_wallet_rounded, size: 35),
              color: currentIconIndex == 1 ? Colors.black : Colors.black54,
              onPressed: () {
                setState(() {
                  currentIconIndex = 1;
                });
              },
            ),
            SizedBox(width: 40), // Space for the floating action button
            IconButton(
              icon: Icon(Icons.bar_chart_rounded, size: 35),
              color: currentIconIndex == 2 ? Colors.black : Colors.black54,
              onPressed: () {
                setState(() {
                  currentIconIndex = 2;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.settings_rounded, size: 35),
              color: currentIconIndex == 3 ? Colors.black : Colors.black54,
              onPressed: () {
                setState(() {
                  currentIconIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
>>>>>>> origin/main
    );
  }
}
