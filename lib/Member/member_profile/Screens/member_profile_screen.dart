
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:society_management/Member/member_profile/model/member_profile_model.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

import '../bloc/member_profile_bloc.dart';
import '../bloc/member_profile_event.dart';
import '../bloc/member_profile_state.dart';
import 'package:file_picker/file_picker.dart';
class _NavItem {
  final String title;
  final IconData icon;

  const _NavItem(this.title, this.icon);
}
class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key});

  static const Color pink = Color(0xFFEC268F);
  static const Color orange = Color(0xFFFFA23A);
  static const Color navy = Color(0xFF142D70);
  static const Color background = Color(0xFFF7F6FC);
  static const Color secondaryText = Color(0xFF7583A8);
  static const Color blue = Color(0xFF3569E8);
  static const Color green = Color(0xFF16BD70);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MemberProfileBloc()..add(LoadMemberProfile()),
      child: const _MemberProfileView(),
    );
  }
}

class _MemberProfileView extends StatelessWidget {
  const _MemberProfileView();

  static const Color pink = MemberProfileScreen.pink;
  static const Color orange = MemberProfileScreen.orange;
  static const Color navy = MemberProfileScreen.navy;
  static const Color background = MemberProfileScreen.background;
  static const Color secondaryText =
      MemberProfileScreen.secondaryText;
  static const Color blue = MemberProfileScreen.blue;
  static const Color green = MemberProfileScreen.green;
Widget _profileBottomNavigation(BuildContext context) {
  final items = [
    _NavItem('Home', Icons.home_rounded),
    _NavItem('My Profile', Icons.person_outline_rounded),
    _NavItem('Settings', Icons.settings_outlined),
    _NavItem('More', Icons.more_horiz_rounded),
  ];

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(26),
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF9673AD).withOpacity(.12),
          blurRadius: 16,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 69,
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == 1;

            return Expanded(
              child: InkWell(
                onTap: () {
                  if (index == 0) {
                    Navigator.pop(context);
                  } else if (index == 1) {
                    // Already on My Profile
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 25,
                      color: isSelected ? pink : secondaryText,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected ? pink : secondaryText,
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      width: isSelected ? 50 : 0,
                      decoration: BoxDecoration(
                        color: pink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemberProfileBloc, MemberProfileState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
           bottomNavigationBar: _profileBottomNavigation(context),
            backgroundColor: AdminColors.page,
          appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  const LinearGradient(
                colors: [
                  Color(0xFFEC4899),
                  Color(0xFFF97316),
                ],
              ).createShader(bounds),
              child: const Text(
                'My Profile',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Your member and flat information | Ruchita | Flat 201 | A',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        backgroundColor: AdminColors.page,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.logout,
              color: Color(0xFFEC4899),
              size: 25,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
          body: SafeArea(
            bottom: false,
            child: state.status == MemberProfileStatus.loading ||
                    state.status == MemberProfileStatus.initial
                ? const Center(
                    child: CircularProgressIndicator(
                      color: pink,
                    ),
                  )
                : state.status == MemberProfileStatus.failure
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Unable to load profile'),
                            TextButton(
                              onPressed: () {
                                context.read<MemberProfileBloc>().add(
                                      LoadMemberProfile(),
                                    );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _buildProfile(context, state),
          ),
        
        );
      },
    );
  }

  Widget _buildProfile(
    BuildContext context,
    MemberProfileState state,
  ) {
    final profile = state.profile!;

    return CustomScrollView(
      slivers: [
       
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Transform.translate(
                offset: const Offset(0, -8),
                child: _buildMemberCard(context, profile),
              ),
              const SizedBox(height: 12),
              _buildSection(
                title: 'Account Information',
                child: _buildAccountInformation(profile),
              ),
              const SizedBox(height: 12),
              _buildSection(
                title: 'Society Information',
                child: _buildSocietyInformation(profile),
              ),
              const SizedBox(height: 12),
              _buildDocumentsSection(context, state.documents),
              const SizedBox(height: 20),
             
            ]),
          ),
        ),
      ],
    );
  }

  // HEADER


  Widget _headerIcon(IconData icon, {String? badge}) {
    return Container(
      width: 43,
      height: 43,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(icon, color: navy, size: 22),
          if (badge != null)
            Positioned(
              right: -3,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: pink,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // MEMBER CARD

  Widget _buildMemberCard(
  BuildContext context,
  MemberProfileModel profile,
) {
    return _whiteCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: navy,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF9FC8),
                    width: 4,
                  ),
                ),
                child: Text(
                  profile.name.isNotEmpty
                      ? profile.name[0].toUpperCase()
                      : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      profile.designation.toUpperCase(),
                      style: const TextStyle(
                        color: pink,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: green,
                          size: 10,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${profile.accountStatus} Member',
                          style: const TextStyle(
                            color: green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _smallActionButton(
                LucideIcons.pencil,
                'Edit',
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0xFFEAEAF5)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _memberDetail(
                  LucideIcons.contact,
                  'ID REF',
                  profile.memberId,
                ),
              ),
              Container(
                width: 1,
                height: 45,
                color: const Color(0xFFE3E4F3),
              ),
              Expanded(
                child: _memberDetail(
                  LucideIcons.clock,
                  'LOCAL TIME',
                TimeOfDay.now().format(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ACCOUNT INFORMATION

  Widget _buildAccountInformation(MemberProfileModel profile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _infoTile(
                LucideIcons.hash,
                'User ID',
                profile.userId,
                color: blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _infoTile(
                LucideIcons.user,
                'Username',
                profile.username,
                color: blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: _infoTile(
                LucideIcons.mail,
                'Email Address',
                profile.email,
                color: blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _infoTile(
                LucideIcons.phone,
                'Contact Number',
                profile.contactNumber,
                color: blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: _infoTile(
                LucideIcons.activity,
                'Designation',
                profile.designation,
                color: blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _infoTile(
                LucideIcons.accessibility,
                'Account Status',
                profile.accountStatus,
                color: green,
                valueColor: green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // SOCIETY INFORMATION

  Widget _buildSocietyInformation(MemberProfileModel profile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _infoTile(
                LucideIcons.building2,
                'Registered Society',
                profile.registeredSociety,
                color: pink,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _infoTile(
                LucideIcons.fileText,
                'Registration Certificate No.',
                profile.registrationCertificate,
                color: pink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        _infoTile(
          LucideIcons.mapPin,
          'Registered Municipal Office Address',
          profile.municipalAddress,
          color: pink,
          fullWidth: true,
        ),
      ],
    );
  }

  // DOCUMENTS
Widget _buildDocumentsSection(
  BuildContext context,
  List<ProfileDocumentModel> documents,
) {
  String? selectedCategory;
  PlatformFile? selectedFile;

  const documentCategories = [
    'Aadhaar Card',
    'PAN Card',
    'Identity Proof',
    'Address Proof',
    'Ownership Proof',
    'Agreement',
    'Other',
  ];

  return StatefulBuilder(
    builder: (context, setLocalState) {
      return _whiteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                _sectionIndicator(),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'My Documents',
                    style: TextStyle(
                      color: navy,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${documents.length} files',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // CHOOSE DOCUMENT
            const Text(
              'Choose Document',
              style: TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Select document type',
                prefixIcon: const Icon(
                  LucideIcons.fileText,
                  color: pink,
                  size: 20,
                ),
                filled: true,
                fillColor: const Color(0xFFF8F8FD),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFEAEAF5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFEAEAF5),
                  ),
                ),
              ),
              items: documentCategories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setLocalState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // CHOOSE FILE
            const Text(
              'Choose File',
              style: TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            InkWell(
              onTap: () async {
                try {
                  final result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [
                      'pdf',
                      'jpg',
                      'jpeg',
                      'png',
                    ],
                  );

                  if (result != null &&
                      result.files.isNotEmpty) {
                    setLocalState(() {
                      selectedFile = result.files.first;
                    });
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Unable to select file: $e'),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFFB5D5),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      LucideIcons.uploadCloud,
                      color: pink,
                      size: 30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedFile == null
                          ? 'Tap here to choose a file'
                          : selectedFile!.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'PDF, JPG, JPEG or PNG',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 11,
                      ),
                    ),
                    if (selectedFile != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${(selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                        style: const TextStyle(
                          color: green,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // UPLOAD BUTTON
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please choose a document type'),
                      ),
                    );
                    return;
                  }

                  if (selectedFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please choose a file'),
                      ),
                    );
                    return;
                  }

                  // Connect this to your actual upload API/BLoC event.
                  context.read<MemberProfileBloc>().add(
                    ProfileActionRequested(
                      'Upload document: $selectedCategory | '
                      '${selectedFile!.name} | '
                      '${selectedFile!.path ?? selectedFile!.name}',
                    ),
                  );
                },
                icon: const Icon(
                  LucideIcons.upload,
                  size: 18,
                ),
                label: const Text(
                  'Upload Document',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(color: Color(0xFFEAEAF5)),
            const SizedBox(height: 12),

            // EXISTING DOCUMENT LIST
            const Text(
              'Uploaded Documents',
              style: TextStyle(
                color: navy,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (documents.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No documents uploaded',
                    style: TextStyle(color: secondaryText),
                  ),
                ),
              )
            else
              ...documents.map(
                (document) => _documentItem(context, document),
              ),
          ],
        ),
      );
    },
  );
}
  // Widget _buildDocumentsSection(
  //   BuildContext context,
  //   List<ProfileDocumentModel> documents,
  // ) {
  //   return _whiteCard(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             _sectionIndicator(),
  //             const SizedBox(width: 9),
  //             const Expanded(
  //               child: Text(
  //                 'My Documents',
  //                 style: TextStyle(
  //                   color: navy,
  //                   fontSize: 17,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 11,
  //                 vertical: 6,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFF0F0FF),
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: Text(
  //                 '${documents.length} files',
  //                 style: const TextStyle(
  //                   color: navy,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 14),
  //         if (documents.isEmpty)
  //           const Center(
  //             child: Padding(
  //               padding: EdgeInsets.all(20),
  //               child: Text(
  //                 'No documents uploaded',
  //                 style: TextStyle(color: secondaryText),
  //               ),
  //             ),
  //           )
  //         else
  //           ...documents.map(
  //             (document) => _documentItem(context, document),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _documentItem(
    BuildContext context,
    ProfileDocumentModel document,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDECF6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  document.category,
                  style: const TextStyle(
                    color: pink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _statusBadge(document.status),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            document.fileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              const Icon(
                LucideIcons.calendarDays,
                size: 14,
                color: secondaryText,
              ),
              const SizedBox(width: 5),
              Text(
                document.uploadedDate,
                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              _documentAction(
                icon: LucideIcons.eye,
                color: blue,
                background: const Color(0xFFEAF0FF),
                onTap: () {
                  context.read<MemberProfileBloc>().add(
                        ProfileActionRequested(
                          'Connect document preview: ${document.fileName}',
                        ),
                      );
                },
              ),
              const SizedBox(width: 8),
              _documentAction(
                icon: LucideIcons.trash2,
                color: const Color(0xFFE53955),
                background: const Color(0xFFFFE9ED),
                onTap: () => _confirmDelete(context, document),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.circle,
            size: 7,
            color: Color(0xFFFFA000),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: const TextStyle(
              color: Color(0xFFB66A00),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentAction({
    required IconData icon,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          color: color,
          size: 17,
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    ProfileDocumentModel document,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Document'),
        content: const Text(
          'Are you sure you want to delete this document?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<MemberProfileBloc>().add(
                    DeleteProfileDocument(document.id),
                  );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // COMMON WIDGETS

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _sectionIndicator(),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _sectionIndicator() {
    return Container(
      width: 4,
      height: 23,
      decoration: BoxDecoration(
        color: pink,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A397F).withValues(alpha: 0.055),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _infoTile(
    IconData icon,
    String label,
    String value, {
    required Color color,
    Color? valueColor,
    bool fullWidth = false,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 78),
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FD),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 19,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: fullWidth ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: secondaryText,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: valueColor ?? navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberDetail(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEFF6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: pink, size: 20),
        ),
        const SizedBox(width: 9),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: navy,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _smallActionButton(IconData icon, String text) {
    return OutlinedButton.icon(
      onPressed: () {
        // Connect your existing profile edit flow here.
      },
      icon: Icon(icon, size: 15),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: pink,
        side: const BorderSide(color: Color(0xFFFFB5D5)),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // LOGOUT

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Logout'),
            content: const Text(
              'Are you sure you want to logout?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<MemberProfileBloc>().add(
                        ProfileActionRequested(
                          'Connect your logout flow here',
                        ),
                      );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: pink),
                ),
              ),
            ],
          ),
        );
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: pink, width: 1.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.logOut, color: pink, size: 22),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(
                color: pink,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


}


