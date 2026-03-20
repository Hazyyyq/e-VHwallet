import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_colors.dart';
import '../Utilities/qr_parser.dart';
import '../Pages/home_page.dart';
import '../Pages/qr_scanner_screen.dart';
import '../Pages/transfer_amount_screen.dart';
import 'wallet_page.dart';
import 'expenses_screen.dart';
import 'settings_screen.dart';
import 'pay_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, required this.username});

  final String username;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(
        title: 'VHWallet',
        username: widget.username,
        onNavigateToWallet: () => _onTabTapped(1),
        onNavigateToExpenses: () => _onTabTapped(2),
        onNavigateToSettings: () => _onTabTapped(3),
      ),
      WalletPage(
        title: 'My Wallet',
        username: widget.username,
      ),
      const ExpensesScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
        physics: const NeverScrollableScrollPhysics(),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PayScreen(),
                fullscreenDialog: true,
              ),
            );
          },
          elevation: 4,
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.black,
            size: 36,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.account_balance_wallet_rounded, 'Wallet'),
              const SizedBox(width: 70),
              _buildNavItem(2, Icons.bar_chart_rounded, 'Expenses'),
              _buildNavItem(3, Icons.settings_rounded, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.black87 : Colors.black54,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.black87 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.title,
    required this.username,
    required this.onNavigateToWallet,
    required this.onNavigateToExpenses,
    required this.onNavigateToSettings,
  });

  final String title;
  final String username;
  final VoidCallback onNavigateToWallet;
  final VoidCallback onNavigateToExpenses;
  final VoidCallback onNavigateToSettings;

  @override
  Widget build(BuildContext context) {
    return MyHomePage(
      title: 'VHWallet',
      username: username,
    );
  }
}
