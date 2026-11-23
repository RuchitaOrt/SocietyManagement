
import 'package:equatable/equatable.dart';
import 'package:society_management/Member/VisitorPass/presentation/bloc/VisitorPassModel.dart';

class VisitorState extends Equatable {
  final List<VisitorPassModel> visitors;
  final bool isLoading;
  final String? errorMessage;

  const VisitorState({
    this.visitors = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  int get totalVisitors => visitors.length;

  int get pendingVisitors => visitors
      .where((v) => v.status.toLowerCase() == 'pending')
      .length;

  int get approvedVisitors => visitors
      .where((v) => v.status.toLowerCase() == 'approved')
      .length;

  int get insideNow => visitors
      .where((v) => v.status.toLowerCase() == 'inside')
      .length;

  bool get hasVisitors => visitors.isNotEmpty;

  VisitorState copyWith({
    List<VisitorPassModel>? visitors,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VisitorState(
      visitors: visitors ?? this.visitors,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        visitors,
        isLoading,
        errorMessage,
      ];
}
