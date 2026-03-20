import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';

import 'services/storage_service.dart';
import 'providers/auth_provider.dart';
import 'providers/wallet_provider.dart';
import 'constants/app_colors.dart';
import 'routes/app_routes.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/pin_screen.dart';
import 'screens/transaction_success_screen.dart';
import 'screens/transaction_failure_screen.dart';
import 'screens/transaction_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/wallet_page.dart';
import 'screens/expenses_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/pay_screen.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storageService = await StorageService.getInstance();
  
  runApp(EWalletApp(storageService: storageService));
}

class EWalletApp extends StatelessWidget {
  final StorageService storageService;

  const EWalletApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => WalletProvider(storageService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VHWallet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            primary: AppColors.primary,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
        ),
        initialRoute: storageService.isLoggedIn ? AppRoutes.home : AppRoutes.login,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      
      case AppRoutes.signup:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );
      
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (context) => Consumer<AuthProvider>(
            builder: (context, auth, child) => MainNavigation(
              username: auth.user.username,
            ),
          ),
        );
      
      case AppRoutes.wallet:
        return MaterialPageRoute(
          builder: (context) => Consumer<AuthProvider>(
            builder: (context, auth, child) => WalletPage(
              title: 'My Wallet',
              username: auth.user.username,
            ),
          ),
        );
      
      case AppRoutes.expenses:
        return MaterialPageRoute(
          builder: (_) => const ExpensesScreen(),
        );
      
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      
      case AppRoutes.pay:
        return MaterialPageRoute(
          builder: (_) => const PayScreen(),
          fullscreenDialog: true,
        );
      
      case AppRoutes.pin:
        return MaterialPageRoute(
          builder: (context) => PinScreen(
            title: 'Enter PIN',
            subtitle: 'Enter your 6-digit PIN to confirm',
            onPinComplete: (pin) {
              Navigator.pop(context, pin);
            },
          ),
        );
      
      case AppRoutes.pinConfirm:
        return MaterialPageRoute(
          builder: (context) => PinScreen(
            title: 'Set PIN',
            subtitle: 'Create a 6-digit PIN for your account',
            onPinComplete: (pin) {
              Navigator.pop(context, pin);
            },
            isConfirmation: true,
          ),
        );
      
      case AppRoutes.success:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TransactionSuccessScreen(
            amount: args['amount'] ?? 0.0,
            merchantName: args['merchantName'] ?? 'Merchant',
            merchantLocation: args['merchantLocation'],
            transactionId: args['transactionId'] ?? 'N/A',
          ),
        );
      
      case AppRoutes.failure:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => TransactionFailureScreen(
            reason: args?['reason'],
          ),
        );
      
      case AppRoutes.history:
        return MaterialPageRoute(
          builder: (_) => const TransactionHistoryScreen(),
        );
      
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
    }
  }
}
=======
// ================= Import Pages ===============
import 'package:wallet_apps/Pages/home_page.dart';

// ================= Main Function ==
void main() {
  //Firebase setup initilization here
  runApp(const EWalletApp());
}

// ================= Main Class ======
class EWalletApp extends StatelessWidget {
  const EWalletApp({super.key});

  //Main Class of the app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VHWallet',
      theme: ThemeData(
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      // Put Auth redirect page here, if user is not logged in, else go to home page
      // Note: Username of the user should be passed to the home page, so that it can be displayed in the welcome message
      // Then put MyHomePage redirect after auth validation, remove below as it is not needed
      home: const MyHomePage(title: 'VHWallet Home Page', username: "TestName",),
      
    );
  }
}


>>>>>>> origin/main
