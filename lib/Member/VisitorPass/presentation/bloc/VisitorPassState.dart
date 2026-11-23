
import 'VisitorPassModel.dart';

enum VisitorPassStatus {
  initial,
  loading,
  success,
  failure,
}

class VisitorPassState {
  final VisitorPassStatus status;
  final List<VisitorPassModel> visitors;
  final bool isAdding;
  final String? errorMessage;

  const VisitorPassState({
    this.status = VisitorPassStatus.initial,
    this.visitors = const [],
    this.isAdding = false,
    this.errorMessage,
  });

  VisitorPassState copyWith({
    VisitorPassStatus? status,
    List<VisitorPassModel>? visitors,
    bool? isAdding,
    String? errorMessage,
  }) {
    return VisitorPassState(
      status: status ?? this.status,
      visitors: visitors ?? this.visitors,
      isAdding: isAdding ?? this.isAdding,
      errorMessage: errorMessage,
    );
  }
}
