import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// A grid of quick action cards on the dashboard for primary features.
///
/// Allows users to quickly navigate to Jobs, Doctors, Books, or the Translator.
class DashboardQuickActions extends StatelessWidget {
  /// Creates a [DashboardQuickActions] instance.
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.quickActions,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: 16),
            GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.2, children: [_buildActionCard(context, AppLocalizations.of(context)!.findJobs, LucideIcons.briefcase, AppColors.secondary, AppColors.primary, '/jobs'), _buildActionCard(context, AppLocalizations.of(context)!.findDoctor, LucideIcons.stethoscope, AppColors.secondary, AppColors.primary, '/doctors'), _buildActionCard(context, AppLocalizations.of(context)!.requestBook, LucideIcons.bookOpen, AppColors.secondary, AppColors.primary, '/books'), _buildActionCard(context, AppLocalizations.of(context)!.signLanguage, LucideIcons.handMetal, AppColors.secondary, AppColors.primary, '/translator')]),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color bgColor, Color iconColor, String route) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text),
            ),
          ],
        ),
      ),
    );
  }
}
