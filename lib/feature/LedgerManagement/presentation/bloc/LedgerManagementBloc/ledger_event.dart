import 'package:flutter_bloc/flutter_bloc.dart';
import 'ledger_model.dart';

abstract class LedgerEvent {}

class LedgerCreated extends LedgerEvent {
  final LedgerModel ledger;

  LedgerCreated(this.ledger);
}

class LedgerDeleted extends LedgerEvent {
  final String id;

  LedgerDeleted(this.id);
}

class LedgerStatusChanged extends LedgerEvent {
  final String id;
  final bool isActive;

  LedgerStatusChanged({
    required this.id,
    required this.isActive,
  });
}

class LedgerSearchChanged extends LedgerEvent {
  final String query;

  LedgerSearchChanged(this.query);
}