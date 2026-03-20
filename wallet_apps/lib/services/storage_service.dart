import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../models/bank_account_model.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  bool get isLoggedIn => _prefs?.getBool(AppConstants.keyIsLoggedIn) ?? false;

  Future<bool> setLoggedIn(bool value) async {
    return await _prefs?.setBool(AppConstants.keyIsLoggedIn, value) ?? false;
  }

  Future<bool> saveUser(UserModel user) async {
    return await _prefs?.setString(
      'user_data',
      jsonEncode(user.toJson()),
    ) ?? false;
  }

  UserModel? getUser() {
    final userData = _prefs?.getString('user_data');
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<bool> savePin(String pin) async {
    return await _prefs?.setString(AppConstants.keyPin, pin) ?? false;
  }

  String? getPin() {
    return _prefs?.getString(AppConstants.keyPin);
  }

  bool verifyPin(String pin) {
    final storedPin = getPin();
    return storedPin == pin;
  }

  Future<bool> saveBalance(double balance) async {
    return await _prefs?.setDouble(AppConstants.keyBalance, balance) ?? false;
  }

  double getBalance() {
    return _prefs?.getDouble(AppConstants.keyBalance) ?? 0.0;
  }

  Future<bool> saveTransactions(List<TransactionModel> transactions) async {
    final List<Map<String, dynamic>> jsonList =
        transactions.map((t) => t.toJson()).toList();
    return await _prefs?.setString('transactions', jsonEncode(jsonList)) ?? false;
  }

  List<TransactionModel> getTransactions() {
    final data = _prefs?.getString('transactions');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => TransactionModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> addTransaction(TransactionModel transaction) async {
    final transactions = getTransactions();
    transactions.insert(0, transaction);
    return await saveTransactions(transactions);
  }

  Future<bool> saveBankAccounts(List<BankAccountModel> accounts) async {
    final List<Map<String, dynamic>> jsonList =
        accounts.map((a) => a.toJson()).toList();
    return await _prefs?.setString('bank_accounts', jsonEncode(jsonList)) ?? false;
  }

  List<BankAccountModel> getBankAccounts() {
    final data = _prefs?.getString('bank_accounts');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => BankAccountModel.fromJson(json)).toList();
    }
    return _getDefaultBankAccounts();
  }

  List<BankAccountModel> _getDefaultBankAccounts() {
    return [
      BankAccountModel(
        id: '1',
        bankName: 'Maybank',
        accountNumber: '12345678901234',
        balance: 2450.50,
        cardColour: '0xFFE5B800',
      ),
      BankAccountModel(
        id: '2',
        bankName: 'RHB',
        accountNumber: '9876543210890',
        balance: 1120.00,
        cardColour: '0xFF5BC2E7',
      ),
      BankAccountModel(
        id: '3',
        bankName: 'BankRakyat',
        accountNumber: '7896541234456',
        balance: 5300.20,
        cardColour: '0xFF005CAB',
      ),
    ];
  }

  Future<bool> clearAll() async {
    return await _prefs?.clear() ?? false;
  }

  Future<void> logout() async {
    await _prefs?.remove(AppConstants.keyIsLoggedIn);
    await _prefs?.remove('user_data');
  }
}
