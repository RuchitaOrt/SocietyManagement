
import 'package:flutter/material.dart';

class WingSetupSection extends StatelessWidget {
  final List<String> wings;
  final ValueChanged<String> onRemove;

  const WingSetupSection({
    super.key,
    required this.wings,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Wings Added',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDF5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${wings.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 1,
            color: const Color(0xFFE8EDF4),
          ),

          // Empty State
          if (wings.isEmpty)
            SizedBox(
              height: 185,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.apartment_outlined,
                    size: 38,
                    color: Color(0xFFE0E7F0),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No Wings Added',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Add wings to organize your society buildings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB8C6D9),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              itemCount: wings.length,
              separatorBuilder: (_, __) => const Divider(
                height: 20,
                color: Color(0xFFE8EDF4),
              ),
              itemBuilder: (context, index) {
                final wing = wings[index];

                return Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: primaryColor,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        wing,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => onRemove(wing),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                        size: 21,
                      ),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
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
