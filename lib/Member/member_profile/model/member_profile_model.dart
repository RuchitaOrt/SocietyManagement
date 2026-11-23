
class MemberProfileModel {
  final String name;
  final String memberId;
  final String userId;
  final String username;
  final String email;
  final String contactNumber;
  final String designation;
  final String accountStatus;
  final String registeredSociety;
  final String registrationCertificate;
  final String municipalAddress;

  const MemberProfileModel({
    required this.name,
    required this.memberId,
    required this.userId,
    required this.username,
    required this.email,
    required this.contactNumber,
    required this.designation,
    required this.accountStatus,
    required this.registeredSociety,
    required this.registrationCertificate,
    required this.municipalAddress,
  });

  factory MemberProfileModel.dummy() {
    return const MemberProfileModel(
      name: 'Ruchita',
      memberId: 'MEM-0071',
      userId: '59',
      username: 'ruchita_5257',
      email: 'ruchitarane0924@gmail.com',
      contactNumber: '9029635257',
      designation: 'Member',
      accountStatus: 'Active',
      registeredSociety: 'Jainam',
      registrationCertificate: 'Jainam001',
      municipalAddress: 'Janiam Bhandup',
    );
  }
}

class ProfileDocumentModel {
  final String id;
  final String category;
  final String fileName;
  final String uploadedDate;
  final String status;

  const ProfileDocumentModel({
    required this.id,
    required this.category,
    required this.fileName,
    required this.uploadedDate,
    required this.status,
  });

  static List<ProfileDocumentModel> dummyList() {
    return const [
      ProfileDocumentModel(
        id: '1',
        category: 'Share Certificate',
        fileName: 'Society Management Certificate.pdf',
        uploadedDate: '21 Nov 2026',
        status: 'Pending',
      ),
      ProfileDocumentModel(
        id: '2',
        category: 'Share Certificate',
        fileName: 'Society Management Certificate.pdf',
        uploadedDate: '21 Nov 2026',
        status: 'Pending',
      ),
    ];
  }
}
