import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import 'profile_card.dart';
import 'profile_icon_box.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsSection extends ConsumerWidget {
  final bool enabled;

  const NotificationsSection({super.key, required this.enabled});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ProfileCard(
      child: Row(
        children: [
          ProfileIconBox(icon: LucideIcons.bell, bg: AppColors.secondary, fg: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.notifications,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text),
                ),
                Text(enabled ? l10n.notificationsOn : l10n.notificationsOff, style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
              ],
            ),
          ),
          Switch.adaptive(value: enabled, activeThumbColor: AppColors.primary, onChanged: (val) => ref.read(getIt<ProfileProvider>().notifier).toggleNotifications(val)),
        ],
      ),
    );
  }
}
