import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class DashboardLearnAndGrow extends StatelessWidget {
  const DashboardLearnAndGrow({super.key});

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
                  AppLocalizations.of(context)!.learnAndGrow,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/books'),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.browseBooks,
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
            _buildBookCard(context, 'The Art of Possibility', 'Rosamund Stone Zander', [
              'Audio Book',
              'Braille',
            ]),
            const SizedBox(height: 16),
            _buildBookCard(context, 'Disability Visibility', 'Alice Wong', [
              'Audio Book',
              'E-Book',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, String title, String author, List<String> types) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.bookOpen,
              color: Color(0xFF065F46),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  author,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: types
                      .map(
                        (type) => Container(
                          margin: const EdgeInsetsDirectional.only(end: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            type,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF065F46),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF004D40)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Text(
              AppLocalizations.of(context)!.requestBook,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF004D40),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
