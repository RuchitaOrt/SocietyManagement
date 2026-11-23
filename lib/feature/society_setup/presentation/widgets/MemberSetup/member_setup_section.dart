
import 'package:flutter/material.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/feature/auth/presentation/bloc/member_setup_model.dart';

class MemberSetupSection extends StatelessWidget {
  final List<MemberSetupModel> members;
  final ValueChanged<int> onRemove;

  const MemberSetupSection({
    super.key,
    required this.members,
    required this.onRemove,
  });

  static const Color primaryColor = Color(0xFFE93691);
  static const Color textColor = Color(0xFF202B43);
  static const Color hintColor = Color(0xFF91A0B8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 17,
            ),
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 3,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Members Added',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFFFFEDF5),
                  child: Text(
                    '${members.length}',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: Color(0xFFE8EDF4),
          ),

          // Empty state
          if (members.isEmpty)
            SizedBox(
              height: 185,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 38,
                      color: Color(0xFFE0E7F0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No Members Added Yet',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: hintColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Tap Add New Member to add society members.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB8C6D9),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              itemCount: members.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 20),
              itemBuilder: (context, index) {
                final member = members[index];

                return Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: member.ownerName,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          const SizedBox(height: 4),
                          CommonText(
                            text: '${member.wing} - ${member.flatNumber}',
                            fontSize: 11,
                            color: hintColor,
                          ),
                          const SizedBox(height: 3),
                          CommonText(
                            text: member.contact,
                            fontSize: 11,
                            color: hintColor,
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () => onRemove(index),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
