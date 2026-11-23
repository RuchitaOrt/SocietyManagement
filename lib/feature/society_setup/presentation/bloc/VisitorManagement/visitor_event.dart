
import 'package:equatable/equatable.dart';
import 'package:society_management/Member/VisitorPass/presentation/bloc/VisitorPassModel.dart';


abstract class VisitorEvent extends Equatable {
  const VisitorEvent();

  @override
  List<Object?> get props => [];
}

class VisitorPassCreated extends VisitorEvent {
  final VisitorPassModel visitor;

  const VisitorPassCreated(this.visitor);

  @override
  List<Object?> get props => [visitor];
}
class VisitorPassStatusChanged extends VisitorEvent {
  final VisitorPassModel visitor;
  final String status;

  const VisitorPassStatusChanged(this.visitor, this.status);

  @override
  List<Object?> get props => [visitor, status];
}

class VisitorPassDeleted extends VisitorEvent {
  final VisitorPassModel visitor;

  const VisitorPassDeleted(this.visitor);

  @override
  List<Object?> get props => [visitor];
}
