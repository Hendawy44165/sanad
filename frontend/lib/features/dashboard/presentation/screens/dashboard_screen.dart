import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_welcome_header.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_opportunities.dart';
import '../widgets/dashboard_medical_network.dart';
import '../widgets/dashboard_learn_and_grow.dart';
import '../widgets/dashboard_sign_language_banner.dart';

/// The main dashboard screen of the application.
/// 
/// This screen provides a summary of all major features including jobs,
/// doctors, and educational resources.
class DashboardScreen extends ConsumerWidget {
  /// Creates a [DashboardScreen] instance.
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(getIt<DashboardProvider>());
    final dashboardNotifier = ref.read(getIt<DashboardProvider>().notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => dashboardNotifier.refresh(),
          color: AppColors.primary,
          child: dashboardState.when(
            data: (state) => CustomScrollView(
              slivers: [
                const DashboardAppBar(),
                const DashboardWelcomeHeader(),
                const DashboardQuickActions(),
                DashboardOpportunities(jobs: state.featuredJobs),
                DashboardMedicalNetwork(doctors: state.featuredDoctors),
                DashboardLearnAndGrow(books: state.featuredBooks),
                const DashboardSignLanguageBanner(),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('${l10n.errorPrefix}$err'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => dashboardNotifier.refresh(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
