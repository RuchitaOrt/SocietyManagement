
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/Member/member_profile/model/member_profile_model.dart';


import 'member_profile_event.dart';
import 'member_profile_state.dart';

class MemberProfileBloc
    extends Bloc<MemberProfileEvent, MemberProfileState> {
  MemberProfileBloc() : super(const MemberProfileState()) {
    on<LoadMemberProfile>(_onLoadProfile);
    on<DeleteProfileDocument>(_onDeleteDocument);
    on<ProfileActionRequested>(_onProfileAction);
  }

  Future<void> _onLoadProfile(
    LoadMemberProfile event,
    Emitter<MemberProfileState> emit,
  ) async {
    emit(state.copyWith(
      status: MemberProfileStatus.loading,
      clearMessage: true,
    ));

    try {
      // Replace with API call later.
      await Future.delayed(const Duration(milliseconds: 500));

      emit(state.copyWith(
        status: MemberProfileStatus.loaded,
        profile: MemberProfileModel.dummy(),
        documents: ProfileDocumentModel.dummyList(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MemberProfileStatus.failure,
        message: 'Unable to load profile',
      ));
    }
  }

  void _onDeleteDocument(
    DeleteProfileDocument event,
    Emitter<MemberProfileState> emit,
  ) {
    final updatedDocuments = state.documents
        .where((document) => document.id != event.documentId)
        .toList();

    emit(state.copyWith(
      documents: updatedDocuments,
      message: 'Document deleted successfully',
    ));
  }

  void _onProfileAction(
    ProfileActionRequested event,
    Emitter<MemberProfileState> emit,
  ) {
    emit(state.copyWith(message: event.message));
  }
}
