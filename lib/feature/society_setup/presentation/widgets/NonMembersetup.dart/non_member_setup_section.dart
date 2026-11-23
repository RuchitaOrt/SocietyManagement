import 'package:flutter/material.dart';
import '../../bloc/NonMemberModel.dart';

class NonMemberSetupSection extends StatelessWidget {
  final List<NonMemberModel> nonMembers;
  final Function(int) onRemove;

  const NonMemberSetupSection({
    super.key,
    required this.nonMembers,
    required this.onRemove,
  });

  static const Color primaryColor = Color(0xFFE93691);

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
                    'Non-Members Added',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFFFFEDF5),
                  child: Text(
                    '${nonMembers.length}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8EDF4)),
          if (nonMembers.isEmpty)
            SizedBox(
              height: 185,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 38,
                      color: Color(0xFFE0E7F0),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No Non-Members Yet',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF91A0B8),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'You can skip this step and add them later',
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
              itemCount: nonMembers.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 20),
              itemBuilder: (context, index) {
                final member = nonMembers[index];

                return Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFFFEDF5),
                      child: Text(
                        member.name.isNotEmpty
                            ? member.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${member.contactNumber} • ${member.email}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF91A0B8),
                            ),
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