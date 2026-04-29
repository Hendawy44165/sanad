import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// A search input field section for the Jobs feature.
/// 
/// This widget provides a stylized text field that triggers the [onChanged]
/// callback. It uses the app's standard shadow and border styles.
class JobsSearchSection extends StatelessWidget {
  /// Callback triggered whenever the search text changes.
  final Function(String)? onChanged;

  /// Creates a [JobsSearchSection] instance.
  /// 
  /// Variables: [onChanged] The handler for query updates.
  const JobsSearchSection({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            onChanged: onChanged,
            style: const TextStyle(color: AppColors.text),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchJobs,
              border: InputBorder.none,
              icon: const Icon(LucideIcons.search, color: AppColors.textLight),
              hintStyle: const TextStyle(color: AppColors.textLight),
            ),
          ),
        ),
      ),
    );
  }
}
