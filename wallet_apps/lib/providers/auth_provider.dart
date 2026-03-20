import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storage;
  
  UserModel _user = UserModel.guest();
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._storage) {
    _loadUser();
  }

  UserModel get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _storage.isLoggedIn;
  String? get error => _error;

  void _loadUser() {
    final savedUser = _storage.getUser();
    if (savedUser != null) {
      _user = savedUser;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (email.isEmpty || password.isEmpty) {
        _error = 'Please fill in all fields';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = UserModel(
        id: 'user_001',
        username: email.split('@').first,
        email: email,
        phone: '+60123456789',
        balance: 150.50,
        createdAt: DateTime.now(),
      );

      await _storage.saveUser(_user);
      await _storage.setLoggedIn(true);
      await _storage.saveBalance(_user.balance);
      
      if (_storage.getPin() == null) {
        await _storage.savePin('123456');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup({
    required String username,
    required String email,
    required String phone,
    required String password,
    required String pin,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (username.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
        _error = 'Please fill in all fields';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (pin.length != 6) {
        _error = 'PIN must be 6 digits';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        email: email,
        phone: phone,
        balance: 0.0,
        createdAt: DateTime.now(),
      );

      await _storage.saveUser(_user);
      await _storage.savePin(pin);
      await _storage.setLoggedIn(true);
      await _storage.saveBalance(0.0);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Signup failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.logout();
    _user = UserModel.guest();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> updateBalance(double newBalance) async {
    _user = _user.copyWith(balance: newBalance);
    await _storage.saveUser(_user);
    await _storage.saveBalance(newBalance);
    notifyListeners();
  }

  Future<bool> verifyPin(String pin) async {
    return _storage.verifyPin(pin);
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    if (!_storage.verifyPin(oldPin)) {
      _error = 'Current PIN is incorrect';
      notifyListeners();
      return false;
    }
    
    await _storage.savePin(newPin);
    return true;
  }
}
