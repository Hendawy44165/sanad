import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../l10n/app_localizations.dart';

class DoctorsSearchSection extends StatelessWidget {
  final Function(String)? onChanged;

  const DoctorsSearchSection({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
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
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchSpecialists,
              border: InputBorder.none,
              icon: const Icon(LucideIcons.search, color: Color(0xFF64748B)),
              hintStyle: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
        ),
      ),
    );
  }
}
