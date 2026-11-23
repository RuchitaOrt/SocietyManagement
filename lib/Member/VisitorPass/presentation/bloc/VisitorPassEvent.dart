
import 'VisitorPassModel.dart';

abstract class VisitorPassEvent {}

class LoadVisitorPasses extends VisitorPassEvent {}

class AddVisitorPass extends VisitorPassEvent {
  final VisitorPassModel visitor;

  AddVisitorPass(this.visitor);
}

class RefreshVisitorPasses extends VisitorPassEvent {}
