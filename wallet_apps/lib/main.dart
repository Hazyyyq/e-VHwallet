import 'package:flutter/material.dart';
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


