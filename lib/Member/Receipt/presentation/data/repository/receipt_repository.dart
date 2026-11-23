import 'package:society_management/Member/Receipt/presentation/bloc/ReceiptModel.dart';

class ReceiptRepository {
  Future<List<ReceiptModel>> getReceipts() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      ReceiptModel(
        id: '1',
        receiptNumber: 'REC-2026-001',
        billNumber: 'BILL-2026-011',
        date: '23 Nov 2026',
        month: 'November 2026',
        paymentMode: 'UPI',
        amount: 4500,
        status: 'Paid',
      ),
      ReceiptModel(
        id: '2',
        receiptNumber: 'REC-2026-002',
        billNumber: 'BILL-2026-010',
        date: '15 Oct 2026',
        month: 'October 2026',
        paymentMode: 'Bank Transfer',
        amount: 4500,
        status: 'Paid',
      ),
      ReceiptModel(
        id: '3',
        receiptNumber: 'REC-2026-003',
        billNumber: 'BILL-2026-009',
        date: '12 Sep 2026',
        month: 'September 2026',
        paymentMode: 'Credit Card',
        amount: 4500,
        status: 'Paid',
      ),
      ReceiptModel(
        id: '4',
        receiptNumber: 'REC-2026-004',
        billNumber: 'BILL-2026-008',
        date: '10 Aug 2026',
        month: 'August 2026',
        paymentMode: 'Cash',
        amount: 4500,
        status: 'Paid',
      ),
    ];
  }
}
