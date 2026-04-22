import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanad/features/profile/presentation/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'profile_card.dart';

class LogoutSection extends StatelessWidget {
  const LogoutSection({super.key, required this.profileNotifier});

  final ProfileNotifier profileNotifier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ProfileCard(
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: profileNotifier.logout,
          icon: const Icon(
            LucideIcons.logOut,
            size: 18,
            color: AppColors.error,
          ),
          label: Text(
            l10n.logout,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
