import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
// TODO: move the providers to the features
import '../../../../core/providers/user_profile_provider.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// Profile screen – shows user info, language toggle, notifications toggle,
/// CV management section, and logout. Opened from the avatar button on the
/// dashboard app-bar.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // ── Local state ────────────────────────────────────────────────────────────
  bool _cvUploaded = false;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _handlePickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        ref.read(userProfileProvider.notifier).updateProfilePicture(image.path);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to pick image: $e', isError: true);
      }
    }
  }

  Future<void> _handleEditName(AppLocalizations l10n) async {
    final userProfile = ref.read(userProfileProvider);
    final controller = TextEditingController(text: userProfile.name);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editName),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.enterName),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004D40),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (newName != null && newName.trim().isNotEmpty) {
      ref.read(userProfileProvider.notifier).updateName(newName.trim());
    }
    controller.dispose();
  }

  Future<void> _handleCvUpload() async {
    setState(() => _isLoading = true);
    try {
      // TODO: wire to real file-picker + Supabase storage
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _cvUploaded = true);
        _showSnackBar(AppLocalizations.of(context)!.cvUploadedSuccess);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(
          AppLocalizations.of(context)!.cvUploadFailed,
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    try {
      // TODO: wire to real Supabase sign-out
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) context.go('/login');
    } catch (e) {
      if (mounted) {
        _showSnackBar('Logout failed: $e', isError: true);
        setState(() => _isLoading = false);
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final userProfile = ref.watch(userProfileProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(l10n),
            _buildProfileHeader(l10n, userProfile),
            _buildSectionDivider(),
            _buildLanguageSection(l10n, currentLocale),
            _buildSectionDivider(),
            _buildNotificationsSection(l10n, settings.notificationsEnabled),
            _buildSectionDivider(),
            _buildCvSection(l10n),
            _buildSectionDivider(),
            _buildLogoutSection(l10n),
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar(AppLocalizations l10n) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  LucideIcons.arrowLeft,
                  color: Color(0xFF1E293B),
                ),
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              l10n.profileTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Profile header ─────────────────────────────────────────────────────────
  Widget _buildProfileHeader(AppLocalizations l10n, UserProfile userProfile) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(24),
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
              // Avatar
              GestureDetector(
                onTap: _handlePickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1FAE5),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      child: userProfile.profilePicturePath != null
                          ? Image.file(
                              File(userProfile.profilePicturePath!),
                              fit: BoxFit.cover,
                              width: 72,
                              height: 72,
                            )
                          : Text(
                              userProfile.name.isNotEmpty
                                  ? userProfile.name[0].toUpperCase()
                                  : 'A',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF065F46),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF004D40),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.camera,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      userProfile.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Email
                    const Text(
                      'ahmed@example.com',
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              // Edit icon
              IconButton(
                icon: const Icon(
                  LucideIcons.pencil,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
                onPressed: () => _handleEditName(l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Divider ────────────────────────────────────────────────────────────────
  Widget _buildSectionDivider() {
    return const SliverToBoxAdapter(child: SizedBox(height: 16));
  }

  // ── Language section ───────────────────────────────────────────────────────
  Widget _buildLanguageSection(AppLocalizations l10n, Locale currentLocale) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel(l10n.language, LucideIcons.globe),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildLanguageChip(
                      label: 'English',
                      isSelected: currentLocale.languageCode == 'en',
                      onTap: () => ref
                          .read(localeProvider.notifier)
                          .setLocale(const Locale('en')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildLanguageChip(
                      label: 'العربية',
                      isSelected: currentLocale.languageCode == 'ar',
                      onTap: () => ref
                          .read(localeProvider.notifier)
                          .setLocale(const Locale('ar')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF004D40) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF004D40).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  // ── Notifications section ──────────────────────────────────────────────────
  Widget _buildNotificationsSection(AppLocalizations l10n, bool enabled) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: _buildCard(
          child: Row(
            children: [
              _buildIconBox(
                LucideIcons.bell,
                const Color(0xFFD1FAE5),
                const Color(0xFF065F46),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.notifications,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      enabled ? l10n.notificationsOn : l10n.notificationsOff,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: enabled,
                activeColor: const Color(0xFF004D40),
                onChanged: (val) => ref
                    .read(settingsProvider.notifier)
                    .toggleNotifications(val),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── CV section ─────────────────────────────────────────────────────────────
  Widget _buildCvSection(AppLocalizations l10n) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel(l10n.myCV, LucideIcons.fileText),
              const SizedBox(height: 16),
              // CV status row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cvUploaded
                      ? const Color(0xFFD1FAE5)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      _cvUploaded
                          ? LucideIcons.checkCircle
                          : LucideIcons.fileUp,
                      color: _cvUploaded
                          ? const Color(0xFF065F46)
                          : const Color(0xFF64748B),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _cvUploaded ? l10n.cvUploaded : l10n.noCvUploaded,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _cvUploaded
                                  ? const Color(0xFF065F46)
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            _cvUploaded
                                ? l10n.cvUploadedSubtitle
                                : l10n.noCvSubtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Upload / Re-upload button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleCvUpload,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(LucideIcons.upload, size: 18),
                  label: Text(
                    _cvUploaded ? l10n.reuploadCV : l10n.uploadCVButton,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Logout section ─────────────────────────────────────────────────────────
  Widget _buildLogoutSection(AppLocalizations l10n) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: _buildCard(
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleLogout,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      LucideIcons.logOut,
                      size: 18,
                      color: AppColors.error,
                    ),
              label: Text(
                l10n.logout,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  Widget _buildCard({required Widget child}) {
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
      child: child,
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        _buildIconBox(icon, const Color(0xFFD1FAE5), const Color(0xFF065F46)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildIconBox(IconData icon, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: fg, size: 20),
    );
  }
}
