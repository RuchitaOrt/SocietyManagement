import 'package:flutter/material.dart';
import '../screens/admin_main_screen.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;
  final bool isDown;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
    this.isDown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AdminColors.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5C3150).withOpacity(.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 23),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AdminColors.text,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    )),
                const SizedBox(height: 3),
                Text(title,
                    maxLines: 2,
                    style: const TextStyle(
                      color: AdminColors.muted,
                      fontSize: 11,
                      height: 1.2,
                    )),
                const SizedBox(height: 4),
                Text(
                  '${isDown ? '↓' : '↑'} $trend',
                  style: TextStyle(
                    color: isDown ? AdminColors.red : AdminColors.green,
                    fontSize: 11,
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
}

class SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AdminColors.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5C3150).withOpacity(.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                      color: AdminColors.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    )),
              ),
              if (actionText != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: AdminColors.blue,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(actionText!,
                      style: const TextStyle(fontSize: 12,color: AdminColors.blue,)),
                ),
            ],
          ),
          Text(subtitle ?? "",
              maxLines: 2,
              style: const TextStyle(
                color: AdminColors.muted,
                fontSize: 11,
                height: 1.2,
              )),
          const SizedBox(height: 13),

          child,
        ],
      ),
    );
  }
}

class QuickActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickActionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(.075),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: color.withOpacity(.13),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 7),
            Text(title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  color: AdminColors.text,
                  fontSize: 11,
                  height: 1.15,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}
