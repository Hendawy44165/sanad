import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class DashboardOpportunities extends StatelessWidget {
  const DashboardOpportunities({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.opportunities,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/jobs'),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.viewAllJobs,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Color(0xFF004D40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildOpportunityCard(
              context,
              'Senior UX Researcher',
              'TechFlow Innovations',
              ['Remote', 'Full-Time'],
              true,
            ),
            const SizedBox(height: 16),
            _buildOpportunityCard(
              context,
              'Accessibility Specialist',
              'Global Health Corp',
              ['Hybrid', 'Contract'],
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(
    BuildContext context,
    String title,
    String company,
    List<String> tags,
    bool isVerified,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      company,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: Color(0xFF065F46),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.verifiedAccessible,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: tags
                .map(
                  (tag) => Container(
                    margin: const EdgeInsetsDirectional.only(end: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF004D40)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                AppLocalizations.of(context)!.viewDetails,
                style: const TextStyle(
                  color: Color(0xFF004D40),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
