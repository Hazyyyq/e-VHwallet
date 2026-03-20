import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/wallet_provider.dart';
import '../constants/app_colors.dart';
import '../Components/balance_card.dart';
import '../Components/bank_card.dart';
import '../Utilities/qr_parser.dart';
import '../routes/app_routes.dart';
import '../Pages/qr_scanner_screen.dart';
import '../Pages/transfer_amount_screen.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key, required this.title, required this.username});

  final String title;
  final String username;

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final page_controller = PageController();

  int currentIconIndex = 1;

  @override
  void dispose() {
    page_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 28,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Wallet',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        widget.username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 217, 215, 215),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 118, 117, 117)
                                .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_outlined,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Consumer<WalletProvider>(
              builder: (context, wallet, child) {
                return SizedBox(
                  height: 200,
                  child: PageView(
                    controller: page_controller,
                    scrollDirection: Axis.horizontal,
                    children: [
                      BalanceCard(
                        balance: wallet.balance.toStringAsFixed(2),
                        cardColour: "0xFF000000",
                      ),
                      ...wallet.bankAccounts.map((bank) => BankCard(
                        username: widget.username,
                        balance: bank.balance.toStringAsFixed(2),
                        expiryDate: "12/28",
                        cardNumber: bank.maskedNumber,
                        cardType: bank.bankName,
                        cardColour: bank.cardColour,
                      )),
                    ],
                  ),
                );
              },
            ),
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
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(Icons.send_rounded, 'Send'),
                  _buildActionButton(Icons.add_circle_outline_rounded, 'Top Up'),
                  _buildActionButton(Icons.qr_code_rounded, 'Pay'),
                  _buildActionButton(Icons.history_rounded, 'History', onTap: () {
                    Navigator.pushNamed(context, AppRoutes.history);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.history);
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<WalletProvider>(
                builder: (context, wallet, child) {
                  final recentTxns = wallet.recentTransactions;
                  
                  if (recentTxns.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No transactions yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: recentTxns.length,
                    itemBuilder: (context, index) {
                      final txn = recentTxns[index];
                      return _buildTransactionItem(
                        icon: _getTransactionIcon(txn.type),
                        iconColor: _getTransactionColor(txn.type),
                        title: txn.merchantName ?? txn.description,
                        subtitle: txn.formattedDate,
                        amount: txn.formattedAmount,
                        isPositive: txn.type.index >= 2,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () async {
            var status = await Permission.camera.status;

            if (status.isDenied) {
              status = await Permission.camera.request();
            }

            if (status.isGranted) {
              setState(() => currentIconIndex = -1);

              final scannedData = await Navigator.push<String?>(
                context,
                MaterialPageRoute(
                  builder: (context) => const QrScannerScreen(),
                ),
              );

              if (scannedData != null && mounted) {
                final Map<String, String> data = QrParser.parseEmvco(
                  scannedData,
                );
                String merchantName = data['59'] ?? "Unknown Merchant";
                String city = data['60'] ?? "Unknown City";
                String countryCode = data['58'] ?? "MY";

                String displayLocation;

                if (city.isEmpty || city == countryCode) {
                  displayLocation = city;
                } else {
                  displayLocation = "$city, $countryCode";
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransferAmountScreen(
                      merchantName: merchantName,
                      merchantLocation: displayLocation,
                      qrData: scannedData,
                    ),
                  ),
                );
              }
            } else if (status.isPermanentlyDenied) {
              openAppSettings();
            }
          },
        ),
      ),
    );
  }

  IconData _getTransactionIcon(dynamic type) {
    switch (type.toString()) {
      case 'TransactionType.payment':
        return Icons.shopping_bag_rounded;
      case 'TransactionType.topUp':
        return Icons.add_circle_outline_rounded;
      case 'TransactionType.receive':
        return Icons.download_rounded;
      case 'TransactionType.transfer':
        return Icons.send_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  Color _getTransactionColor(dynamic type) {
    switch (type.toString()) {
      case 'TransactionType.payment':
        return AppColors.rhbBlue;
      case 'TransactionType.topUp':
        return AppColors.activeStatus;
      case 'TransactionType.receive':
        return Colors.green;
      case 'TransactionType.transfer':
        return AppColors.bankRakyatBlue;
      default:
        return Colors.orange;
    }
  }

  Widget _buildActionButton(IconData icon, String label, {VoidCallback? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 28,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required bool isPositive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
