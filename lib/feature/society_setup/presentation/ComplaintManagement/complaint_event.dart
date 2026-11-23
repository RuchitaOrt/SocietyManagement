import 'complaint_model.dart';

abstract class ComplaintEvent {}

class ComplaintCreated extends ComplaintEvent {
  final ComplaintModel complaint;

  ComplaintCreated(this.complaint);
}

class ComplaintStatusChanged extends ComplaintEvent {
  final ComplaintModel complaint;
  final String status;

  ComplaintStatusChanged(this.complaint, this.status);
}

class ComplaintDeleted extends ComplaintEvent {
  final ComplaintModel complaint;

  ComplaintDeleted(this.complaint);
}