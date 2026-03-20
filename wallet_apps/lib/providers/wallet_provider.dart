import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../models/bank_account_model.dart';
import '../services/storage_service.dart';

class WalletProvider extends ChangeNotifier {
  final StorageService _storage;
  
  double _balance = 0.0;
  List<TransactionModel> _transactions = [];
  List<BankAccountModel> _bankAccounts = [];
  bool _isLoading = false;

  WalletProvider(this._storage) {
    _loadData();
  }

  double get balance => _balance;
  List<TransactionModel> get transactions => _transactions;
  List<BankAccountModel> get bankAccounts => _bankAccounts;
  bool get isLoading => _isLoading;

  String get formattedBalance => 'RM ${_balance.toStringAsFixed(2)}';

  List<TransactionModel> get recentTransactions {
    return _transactions.take(5).toList();
  }

  void _loadData() {
    _balance = _storage.getBalance();
    _transactions = _storage.getTransactions();
    _bankAccounts = _storage.getBankAccounts();
    
    if (_transactions.isEmpty) {
      _loadSampleTransactions();
    }
    
    notifyListeners();
  }

  void _loadSampleTransactions() {
    final now = DateTime.now();
    _transactions = [
      TransactionModel(
        id: '1',
        type: TransactionType.payment,
        status: TransactionStatus.success,
        amount: 45.00,
        description: 'Shopping',
        merchantName: 'Fashion Store',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      TransactionModel(
        id: '2',
        type: TransactionType.payment,
        status: TransactionStatus.success,
        amount: 28.50,
        description: 'Food & Beverages',
        merchantName: 'Restaurant',
        timestamp: now.subtract(const Duration(hours: 4)),
      ),
      TransactionModel(
        id: '3',
        type: TransactionType.topUp,
        status: TransactionStatus.success,
        amount: 100.00,
        description: 'Wallet Top Up',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
      TransactionModel(
        id: '4',
        type: TransactionType.payment,
        status: TransactionStatus.success,
        amount: 60.00,
        description: 'Petrol Station',
        merchantName: 'Petronas',
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      TransactionModel(
        id: '5',
        type: TransactionType.payment,
        status: TransactionStatus.success,
        amount: 15.00,
        description: 'Entertainment',
        merchantName: 'Cinema',
        timestamp: now.subtract(const Duration(days: 2)),
      ),
      TransactionModel(
        id: '6',
        type: TransactionType.receive,
        status: TransactionStatus.success,
        amount: 250.00,
        description: 'Transfer from John',
        timestamp: now.subtract(const Duration(days: 3)),
      ),
    ];
    _storage.saveTransactions(_transactions);
  }

  Future<bool> topUp(double amount) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _balance += amount;
      await _storage.saveBalance(_balance);

      final transaction = TransactionModel(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.topUp,
        status: TransactionStatus.success,
        amount: amount,
        description: 'Wallet Top Up',
        timestamp: DateTime.now(),
      );

      _transactions.insert(0, transaction);
      await _storage.addTransaction(transaction);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> makePayment({
    required double amount,
    required String merchantName,
    String? merchantLocation,
    required String pin,
  }) async {
    if (!_storage.verifyPin(pin)) {
      return false;
    }

    if (amount > _balance) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _balance -= amount;
      await _storage.saveBalance(_balance);

      final transaction = TransactionModel(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.payment,
        status: TransactionStatus.success,
        amount: amount,
        description: 'Payment to $merchantName',
        merchantName: merchantName,
        merchantLocation: merchantLocation,
        timestamp: DateTime.now(),
      );

      _transactions.insert(0, transaction);
      await _storage.addTransaction(transaction);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> transfer({
    required double amount,
    required String recipientName,
    required String pin,
  }) async {
    if (!_storage.verifyPin(pin)) {
      return false;
    }

    if (amount > _balance) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _balance -= amount;
      await _storage.saveBalance(_balance);

      final transaction = TransactionModel(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.transfer,
        status: TransactionStatus.success,
        amount: amount,
        description: 'Transfer to $recipientName',
        timestamp: DateTime.now(),
      );

      _transactions.insert(0, transaction);
      await _storage.addTransaction(transaction);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
