import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:sanad/core/services/error_handling_service.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/language_section.dart';
import '../widgets/cv_section.dart';
import '../widgets/logout_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(getIt<ProfileProvider>());
    final profileNotifier = ref.read(getIt<ProfileProvider>().notifier);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(getIt<ProfileProvider>(), (previous, next) {
      final error = next.value?.error;
      if (error != null) {
        final errorMessage = ErrorHandlingService.getMessage(error, l10n);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
        ref.read(getIt<ProfileProvider>().notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: profileState.when(
          data: (profile) => CustomScrollView(
            slivers: [
              _buildAppBar(context),
              ProfileHeader(profile: profile, profileNotifier: profileNotifier),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(child: LanguageSection()),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: CvSection(
                    cvUploaded: profile.cvUploaded,
                    onUpload: (cvPath) async {
                      return await profileNotifier.uploadCv(cvPath);
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(child: LogoutSection(profileNotifier: profileNotifier)),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('${l10n.errorPrefix}$err')),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: IconButton(
                icon: const Icon(LucideIcons.arrowLeft, color: AppColors.text),
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              l10n.profileTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
          ],
        ),
      ),
    );
  }
}
