import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

/// Header widget for the dashboard displaying a welcome message.
/// 
/// Presents the page title and a brief subtitle to the user.
class DashboardWelcomeHeader extends StatelessWidget {
  /// Creates a [DashboardWelcomeHeader] instance.
  const DashboardWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.dashboard,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.dashboardSubtitle,
              style: const TextStyle(fontSize: 16, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}
