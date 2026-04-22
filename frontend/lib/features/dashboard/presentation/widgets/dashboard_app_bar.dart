import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                icon: const Icon(LucideIcons.menu, color: Color(0xFF1E293B)),
                onPressed: () {},
              ),
            ),
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004D40),
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/profile'),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'A',
                  style: TextStyle(
                    color: Color(0xFF065F46),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
