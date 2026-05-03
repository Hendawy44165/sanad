import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import 'profile_card.dart';
import 'profile_section_label.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LanguageSection extends ConsumerWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(getIt<LocaleProvider>());

    final l10n = AppLocalizations.of(context)!;

    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionLabel(label: l10n.language, icon: LucideIcons.globe),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _LanguageChip(
                  label: 'English',
                  isSelected: state.languageCode == 'en',
                  onTap: () {
                    final localeProvider = getIt<LocaleProvider>();
                    final profileProvider = getIt<ProfileProvider>();
                    ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                    ref.read(profileProvider.notifier).updateLanguage('en');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LanguageChip(
                  label: 'العربية',
                  isSelected: state.languageCode == 'ar',
                  onTap: () {
                    final localeProvider = getIt<LocaleProvider>();
                    final profileProvider = getIt<ProfileProvider>();
                    ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                    ref.read(profileProvider.notifier).updateLanguage('ar');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isSelected ? AppColors.onPrimary : AppColors.textLight),
        ),
      ),
    );
  }
}
