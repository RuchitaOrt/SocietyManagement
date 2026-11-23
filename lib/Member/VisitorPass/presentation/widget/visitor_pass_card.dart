
import 'package:flutter/material.dart';

import 'package:society_management/Member/VisitorPass/presentation/bloc/VisitorPassModel.dart';

class VisitorPassCard extends StatelessWidget {
  final VisitorPassModel visitor;

  const VisitorPassCard({
    super.key,
    required this.visitor,
  });

  static const pink = Color(0xFFE93691);
  static const navy = Color(0xFF202B43);
  static const grey = Color(0xFF91A0B8);

  String get formattedDate {
    final date = visitor.expectedAt;

    final hour = date.hour % 12 == 0
        ? 12
        : date.hour % 12;

    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day} ${_month(date.month)}, '
        '$hour:$minute $period';
  }

  String _month(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr',
      'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final approved =
        visitor.status.toLowerCase() == 'approved';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEAEAF0),
        ),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: pink,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visitor.visitorName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      visitor.type,
                      style: const TextStyle(
                        fontSize: 11,
                        color: grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: approved
                      ? const Color(0xFFD9F9EA)
                      : const Color(0xFFFFEDEA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  visitor.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: approved
                        ? const Color(0xFF009C65)
                        : Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _info(
                Icons.phone_outlined,
                visitor.mobileNumber,
              ),
              _info(
                Icons.access_time_rounded,
                formattedDate,
              ),
            ],
          ),

          if (visitor.vehicleNumber.isNotEmpty) ...[
            const SizedBox(height: 10),
            _info(
              Icons.directions_car_outlined,
              visitor.vehicleNumber,
            ),
          ],

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F8),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: const Color(0xFFFFB6D7),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: pink,
                ),
                const SizedBox(width: 7),
                Text(
                  visitor.otp.split('').join(' '),
                  style: const TextStyle(
                    color: pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: grey, size: 13),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF61738F),
            ),
          ),
        ],
      ),
    );
  }
}
