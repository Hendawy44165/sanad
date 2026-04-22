import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class BooksAppBar extends StatelessWidget {
  const BooksAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  LucideIcons.arrowLeft,
                  color: Color(0xFF1E293B),
                ),
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              AppLocalizations.of(context)!.requestBook,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
