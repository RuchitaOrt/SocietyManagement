
class ReceiptModel {
  final String id;
  final String receiptNumber;
  final String billNumber;
  final String date;
  final String month;
  final String paymentMode;
  final double amount;
  final String status;

  const ReceiptModel({
    required this.id,
    required this.receiptNumber,
    required this.billNumber,
    required this.date,
    required this.month,
    required this.paymentMode,
    required this.amount,
    required this.status,
  });
}
