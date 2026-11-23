import 'bill_model.dart';

abstract class BillEvent {}

class BillCreated extends BillEvent {
  final List<BillModel> bills;

  BillCreated(this.bills);
}

class BillDeleted extends BillEvent {
  final BillModel bill;

  BillDeleted(this.bill);
}

class BillStatusUpdated extends BillEvent {
  final BillModel bill;
  final String status;

  BillStatusUpdated(this.bill, this.status);
}

class BillSearchChanged extends BillEvent {
  final String query;

  BillSearchChanged(this.query);
}

class BillFilterChanged extends BillEvent {
  final String wing;
  final String month;
  final String status;

  BillFilterChanged({
    required this.wing,
    required this.month,
    required this.status,
  });
}