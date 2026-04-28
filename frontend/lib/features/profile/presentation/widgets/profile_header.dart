import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/profile/presentation/providers/profile_provider.dart';
import 'package:sanad/l10n/app_localizations.dart';
import '../providers/profile_state.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileState profile;
  final ProfileNotifier profileNotifier;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.profileNotifier,
  });

  @override
  Widget build(BuildContext context) {
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
                onTap: () async => await _handlePickImage(context),
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
                      child: profile.profilePicturePath != null
                          ? Image.file(
                              File(profile.profilePicturePath!),
                              fit: BoxFit.cover,
                              width: 72,
                              height: 72,
                            )
                          : Text(
                              profile.name.isNotEmpty
                                  ? profile.name[0].toUpperCase()
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
                      profile.name,
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
                    Text(
                      profile.userEmail,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
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
                onPressed: () => _handleEditName(context, profile.name),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleEditName(BuildContext context, String currentName) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentName);

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
      profileNotifier.updateName(newName.trim());
    }
    controller.dispose();
  }

  Future<void> _handlePickImage(BuildContext context) async {
    final picker = ImagePicker();
    final l10n = AppLocalizations.of(context)!;
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        profileNotifier.updateProfilePicture(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, '${l10n.failedToPickImage}$e', isError: true);
      }
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
