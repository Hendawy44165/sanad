import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/l10n/app_localizations.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/disability_option_card.dart';
import '../widgets/onboarding_footer.dart';

class SelectDisabilityScreen extends ConsumerWidget {
  const SelectDisabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(getIt<OnboardingProvider>());
    final onboardingNotifier = ref.read(getIt<OnboardingProvider>().notifier);

    final l10n = AppLocalizations.of(context)!;

    final List<Map<String, dynamic>> options = [
      {
        'id': 'visual',
        'label': l10n.visualLabel,
        'description': l10n.visualDesc,
        'icon': Icons.visibility,
      },
      {
        'id': 'hearing',
        'label': l10n.hearingLabel,
        'description': l10n.hearingDesc,
        'icon': Icons.hearing,
      },
      {
        'id': 'mobility',
        'label': l10n.mobilityLabel,
        'description': l10n.mobilityDesc,
        'icon': Icons.accessible,
      },
      {
        'id': 'cognitive',
        'label': l10n.cognitiveLabel,
        'description': l10n.cognitiveDesc,
        'icon': Icons.psychology,
      },
      {
        'id': 'chronic',
        'label': l10n.chronicLabel,
        'description': l10n.chronicDesc,
        'icon': Icons.favorite,
      },
      {
        'id': 'other',
        'label': l10n.otherLabel,
        'description': l10n.otherDesc,
        'icon': Icons.help_outline,
      },
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.secondary],
          ),
        ),
        child: SafeArea(
          child: onboardingState.when(
            data: (state) => Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        const OnboardingHeader(),
                        const SizedBox(height: 32),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: options.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final option = options[index];
                            return DisabilityOptionCard(
                              id: option['id'],
                              label: option['label'],
                              description: option['description'],
                              icon: option['icon'],
                              isSelected: state.selectedDisabilityId == option['id'],
                              onTap: () => onboardingNotifier.selectDisability(option['id']),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                OnboardingFooter(
                  isLoading: state.isLoading,
                  onContinue: state.selectedDisabilityId != null
                      ? () async {
                          await onboardingNotifier.saveSelection(l10n);
                          if (context.mounted) {
                            context.go('/');
                          }
                        }
                      : null,
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('${l10n.errorPrefix}$err')),
          ),
        ),
      ),
    );
  }
}
