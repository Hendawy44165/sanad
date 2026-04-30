import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class DoctorsAppBar extends StatelessWidget {
  const DoctorsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: IconButton(
                icon: const Icon(LucideIcons.arrowLeft, color: AppColors.text),
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              AppLocalizations.of(context)!.findDoctor,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
          ],
        ),
      ),
    );
  }
}
