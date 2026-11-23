import 'package:equatable/equatable.dart';

enum TransactionType {
  credit,
  debit,
  transfer,
}

enum PaymentMode { cash, bankTransfer, cheque, upi, card }

class CashbookTransaction extends Equatable {
  final String id;
  final DateTime date;
  final TransactionType type;
  final String description;
  final String category;
  final String memberOrParty;
  final String bank;
  final PaymentMode mode;
  final double amount;
  final String? referenceNumber;

  const CashbookTransaction({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.category,
    required this.memberOrParty,
    required this.bank,
    required this.mode,
    required this.amount,
    this.referenceNumber,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        type,
        description,
        category,
        memberOrParty,
        bank,
        mode,
        amount,
        referenceNumber,
      ];
}

extension TransactionTypeLabel on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.credit:
        return 'Credit';
      case TransactionType.debit:
        return 'Debit';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }
}

extension PaymentModeLabel on PaymentMode {
  String get label {
    switch (this) {
      case PaymentMode.cash:
        return 'Cash';
      case PaymentMode.bankTransfer:
        return 'Bank Transfer';
      case PaymentMode.cheque:
        return 'Cheque';
      case PaymentMode.upi:
        return 'UPI';
      case PaymentMode.card:
        return 'Card';
    }
  }
}
