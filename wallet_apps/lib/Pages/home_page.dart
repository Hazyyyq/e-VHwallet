// ================= Others Import ===============
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ================= Components Import ===============
import 'package:wallet_apps/Components/balance_card.dart';
import 'package:wallet_apps/Components/bank_card.dart';

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
      backgroundColor: Colors.white54,
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
            SizedBox(
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
    );
  }
}
