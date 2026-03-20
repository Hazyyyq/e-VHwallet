class WalletModel {
  final String id;
  final double balance;
  final bool isActive;
  final DateTime lastUpdated;

  WalletModel({
    required this.id,
    required this.balance,
    required this.isActive,
    required this.lastUpdated,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      isActive: json['isActive'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'isActive': isActive,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  WalletModel copyWith({
    String? id,
    double? balance,
    bool? isActive,
    DateTime? lastUpdated,
  }) {
    return WalletModel(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  String get formattedBalance {
    return balance.toStringAsFixed(2);
  }
}
