enum TransactionType { send, receive, topUp, payment, transfer }

enum TransactionStatus { pending, success, failed }

class TransactionModel {
  final String id;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final String description;
  final String? merchantName;
  final String? merchantLocation;
  final DateTime timestamp;
  final String? referenceId;

  TransactionModel({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    required this.description,
    this.merchantName,
    this.merchantLocation,
    required this.timestamp,
    this.referenceId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${json['type']}',
        orElse: () => TransactionType.payment,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString() == 'TransactionStatus.${json['status']}',
        orElse: () => TransactionStatus.success,
      ),
      amount: (json['amount'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      merchantName: json['merchantName'],
      merchantLocation: json['merchantLocation'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      referenceId: json['referenceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'amount': amount,
      'description': description,
      'merchantName': merchantName,
      'merchantLocation': merchantLocation,
      'timestamp': timestamp.toIso8601String(),
      'referenceId': referenceId,
    };
  }

  String get formattedAmount {
    final prefix = type == TransactionType.receive || type == TransactionType.topUp
        ? '+'
        : '-';
    return '$prefix RM ${amount.toStringAsFixed(2)}';
  }

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays == 0) {
      return 'Today, ${_formatTime(timestamp)}';
    } else if (diff.inDays == 1) {
      return 'Yesterday, ${_formatTime(timestamp)}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
