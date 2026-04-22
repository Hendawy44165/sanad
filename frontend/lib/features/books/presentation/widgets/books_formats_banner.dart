import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../l10n/app_localizations.dart';

class BooksFormatsBanner extends StatelessWidget {
  const BooksFormatsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF004D40),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.bookOpen, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.availableFormats,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D40),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.availableFormatsSubtitle,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF065F46)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
