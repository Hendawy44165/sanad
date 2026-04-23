import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_welcome_header.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_opportunities.dart';
import '../widgets/dashboard_medical_network.dart';
import '../widgets/dashboard_learn_and_grow.dart';
import '../widgets/dashboard_sign_language_banner.dart';
import '../widgets/dashboard_bottom_navigation_bar.dart';
import '../widgets/sanad_floating_button.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(getIt<DashboardProvider>());
    final dashboardNotifier = ref.read(getIt<DashboardProvider>().notifier);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: dashboardState.when(
          data: (state) => CustomScrollView(
            slivers: [
              const DashboardAppBar(),
              const DashboardWelcomeHeader(),
              const DashboardQuickActions(),
              const DashboardOpportunities(),
              const DashboardMedicalNetwork(),
              const DashboardLearnAndGrow(),
              const DashboardSignLanguageBanner(),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('${l10n.errorPrefix}$err')),
        ),
      ),
      floatingActionButton: const SanadFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: dashboardState.maybeWhen(
        data: (state) => DashboardBottomNavigationBar(
          selectedIndex: state.selectedIndex,
          onItemSelected: (index) => dashboardNotifier.setSelectedIndex(index),
        ),
        orElse: () => null,
      ),
    );
  }
}
