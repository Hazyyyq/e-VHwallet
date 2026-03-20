class BankAccountModel {
  final String id;
  final String bankName;
  final String accountNumber;
  final double balance;
  final String cardColour;

  BankAccountModel({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.balance,
    required this.cardColour,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json['id'] ?? '',
      bankName: json['bankName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      cardColour: json['cardColour'] ?? '0xFF6200EE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'balance': balance,
      'cardColour': cardColour,
    };
  }

  String get maskedNumber {
    final last4 = accountNumber.length >= 4
        ? accountNumber.substring(accountNumber.length - 4)
        : accountNumber;
    return '**** **** **** $last4';
  }

  String get formattedBalance {
    return 'RM ${balance.toStringAsFixed(2)}';
  }
}
