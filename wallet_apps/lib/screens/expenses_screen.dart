import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../constants/app_colors.dart';
import '../models/transaction_model.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'This Year', 'All Time'];

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
                      Icons.bar_chart_rounded,
                      size: 28,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Expenses',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildPeriodSelector(),
            const SizedBox(height: 24),
            _buildSummaryCard(),
            const SizedBox(height: 24),
            Expanded(
              child: _buildExpensesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _periods.length,
        itemBuilder: (context, index) {
          final period = _periods[index];
          final isSelected = period == _selectedPeriod;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black87 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Consumer<WalletProvider>(
      builder: (context, wallet, child) {
        final transactions = wallet.transactions.where((t) => 
          t.type == TransactionType.payment || 
          t.type == TransactionType.transfer
        ).toList();
        
        double totalExpenses = 0;
        for (var txn in transactions) {
          totalExpenses += txn.amount;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black87,
                Colors.black.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Total Spending',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'RM ${totalExpenses.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(Icons.receipt_outlined, '${transactions.length}', 'Transactions'),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  _buildStatItem(Icons.trending_down_rounded, 'RM ${(totalExpenses / (transactions.isEmpty ? 1 : transactions.length)).toStringAsFixed(0)}', 'Average'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.7), size: 18),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesList() {
    return Consumer<WalletProvider>(
      builder: (context, wallet, child) {
        final expenseTransactions = wallet.transactions.where((t) => 
          t.type == TransactionType.payment || 
          t.type == TransactionType.transfer
        ).toList();

        if (expenseTransactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No expenses yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your spending will appear here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Text(
              'Spending Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCategoryBreakdown(expenseTransactions),
            const SizedBox(height: 24),
            const Text(
              'Recent Expenses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...expenseTransactions.take(10).map((txn) => _buildExpenseItem(txn)),
            const SizedBox(height: 100),
          ],
        );
      },
    );
  }

  Widget _buildCategoryBreakdown(List<TransactionModel> transactions) {
    final Map<String, double> categoryTotals = {};
    final Map<String, IconData> categoryIcons = {
      'Shopping': Icons.shopping_bag_rounded,
      'Food': Icons.restaurant_rounded,
      'Transport': Icons.directions_car_rounded,
      'Entertainment': Icons.movie_rounded,
      'Bills': Icons.receipt_long_rounded,
      'Transfer': Icons.send_rounded,
    };
    final Map<String, Color> categoryColors = {
      'Shopping': AppColors.rhbBlue,
      'Food': Colors.orange,
      'Transport': Colors.purple,
      'Entertainment': Colors.pink,
      'Bills': Colors.teal,
      'Transfer': AppColors.bankRakyatBlue,
    };

    for (var txn in transactions) {
      String category = _getCategoryFromDescription(txn.description);
      categoryTotals[category] = (categoryTotals[category] ?? 0) + txn.amount;
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: sortedCategories.map((entry) {
          final color = categoryColors[entry.key] ?? Colors.grey;
          final icon = categoryIcons[entry.key] ?? Icons.attach_money_rounded;
          final percentage = (entry.value / transactions.fold(0.0, (sum, t) => sum + t.amount) * 100).toStringAsFixed(1);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: double.parse(percentage) / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'RM ${entry.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getCategoryFromDescription(String description) {
    final lower = description.toLowerCase();
    if (lower.contains('shopping') || lower.contains('store')) return 'Shopping';
    if (lower.contains('food') || lower.contains('restaurant') || lower.contains('cafe')) return 'Food';
    if (lower.contains('petrol') || lower.contains('car') || lower.contains('transport')) return 'Transport';
    if (lower.contains('movie') || lower.contains('entertainment') || lower.contains('cinema')) return 'Entertainment';
    if (lower.contains('bill') || lower.contains('utilities')) return 'Bills';
    if (lower.contains('transfer') || lower.contains('send')) return 'Transfer';
    return 'Other';
  }

  Widget _buildExpenseItem(TransactionModel txn) {
    IconData icon;
    Color color;
    
    final category = _getCategoryFromDescription(txn.description);
    switch (category) {
      case 'Shopping':
        icon = Icons.shopping_bag_rounded;
        color = AppColors.rhbBlue;
        break;
      case 'Food':
        icon = Icons.restaurant_rounded;
        color = Colors.orange;
        break;
      case 'Transport':
        icon = Icons.directions_car_rounded;
        color = Colors.purple;
        break;
      case 'Entertainment':
        icon = Icons.movie_rounded;
        color = Colors.pink;
        break;
      case 'Bills':
        icon = Icons.receipt_long_rounded;
        color = Colors.teal;
        break;
      default:
        icon = Icons.attach_money_rounded;
        color = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.merchantName ?? txn.description,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  txn.formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- RM ${txn.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
