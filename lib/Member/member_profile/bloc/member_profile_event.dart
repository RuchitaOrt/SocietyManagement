


abstract class MemberProfileEvent {}

class LoadMemberProfile extends MemberProfileEvent {}

class DeleteProfileDocument extends MemberProfileEvent {
  final String documentId;

  DeleteProfileDocument(this.documentId);
}

class ProfileActionRequested extends MemberProfileEvent {
  final String message;

  ProfileActionRequested(this.message);
}
