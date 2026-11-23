
import 'package:society_management/Member/member_profile/model/member_profile_model.dart';


enum MemberProfileStatus {
  initial,
  loading,
  loaded,
  failure,
}

class MemberProfileState {
  final MemberProfileStatus status;
  final MemberProfileModel? profile;
  final List<ProfileDocumentModel> documents;
  final String? message;

  const MemberProfileState({
    this.status = MemberProfileStatus.initial,
    this.profile,
    this.documents = const [],
    this.message,
  });

  MemberProfileState copyWith({
    MemberProfileStatus? status,
    MemberProfileModel? profile,
    List<ProfileDocumentModel>? documents,
    String? message,
    bool clearMessage = false,
  }) {
    return MemberProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      documents: documents ?? this.documents,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
