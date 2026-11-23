import 'complaint_model.dart';

class ComplaintState {
  final List<ComplaintModel> complaints;
  final bool isLoading;
  final String? errorMessage;

  const ComplaintState({
    this.complaints = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  int get totalComplaints => complaints.length;

  int get openComplaints =>
      complaints.where((c) => c.status == 'Open').length;

  int get inProgressComplaints =>
      complaints.where((c) => c.status == 'In Progress').length;

  int get closedComplaints =>
      complaints.where((c) => c.status == 'Closed').length;

  ComplaintState copyWith({
    List<ComplaintModel>? complaints,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ComplaintState(
      complaints: complaints ?? this.complaints,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}