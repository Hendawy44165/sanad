import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import 'profile_card.dart';
import 'profile_icon_box.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsSection extends ConsumerWidget {
  final bool enabled;

  const NotificationsSection({
    super.key,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ProfileCard(
      child: Row(
        children: [
          ProfileIconBox(
            icon: LucideIcons.bell,
            bg: const Color(0xFFD1FAE5),
            fg: const Color(0xFF065F46),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.notifications,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  enabled ? l10n.notificationsOn : l10n.notificationsOff,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            activeColor: const Color(0xFF004D40),
            onChanged: (val) =>
                ref.read(profileProvider.notifier).toggleNotifications(val),
          ),
        ],
      ),
    );
  }
}
