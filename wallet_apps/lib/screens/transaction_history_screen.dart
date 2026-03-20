import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../constants/app_colors.dart';
import '../models/transaction_model.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<WalletProvider>(
        builder: (context, wallet, child) {
          if (wallet.transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your transaction history will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: wallet.transactions.length,
            itemBuilder: (context, index) {
              final transaction = wallet.transactions[index];
              return _buildTransactionItem(context, transaction);
            },
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionModel transaction) {
    IconData icon;
    Color iconColor;
    String title;
    
    switch (transaction.type) {
      case TransactionType.payment:
        icon = Icons.shopping_bag_rounded;
        iconColor = AppColors.rhbBlue;
        title = transaction.merchantName ?? transaction.description;
        break;
      case TransactionType.topUp:
        icon = Icons.add_circle_outline_rounded;
        iconColor = AppColors.activeStatus;
        title = transaction.description;
        break;
      case TransactionType.receive:
        icon = Icons.download_rounded;
        iconColor = Colors.green;
        title = transaction.description;
        break;
      case TransactionType.transfer:
        icon = Icons.send_rounded;
        iconColor = AppColors.bankRakyatBlue;
        title = transaction.description;
        break;
      case TransactionType.send:
        icon = Icons.arrow_upward_rounded;
        iconColor = Colors.orange;
        title = transaction.description;
        break;
    }

    final isPositive = transaction.type == TransactionType.topUp || 
                       transaction.type == TransactionType.receive;

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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 26,
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
                const SizedBox(height: 4),
                Text(
                  transaction.formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.formattedAmount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
