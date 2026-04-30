import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/entities/doctor_entity.dart';

class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorCard({super.key, required this.doctor});

  Future<void> _handleBook(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    String? contactUrl;
    if (doctor.contactEmail != null && doctor.contactEmail!.isNotEmpty) {
      contactUrl = 'mailto:${doctor.contactEmail}';
    } else if (doctor.contactPhone != null && doctor.contactPhone!.isNotEmpty) {
      contactUrl = 'tel:${doctor.contactPhone}';
    }
    
    if (contactUrl == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.noContactEmail)));
      }
      return;
    }
    
    final uri = Uri.tryParse(contactUrl);
    if (uri != null) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.couldNotOpenLink)));
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.couldNotOpenLink)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                  image: doctor.imageUrl != null
                      ? DecorationImage(image: NetworkImage(doctor.imageUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: doctor.imageUrl == null
                    ? const Icon(LucideIcons.user, color: AppColors.primary, size: 30)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
                    ),
                    Text(doctor.specialty, style: const TextStyle(fontSize: 14, color: AppColors.textLight)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${doctor.rating} (${AppLocalizations.of(context)!.reviews(doctor.ratingCount)})',
                          style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (doctor.description != null && doctor.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              doctor.description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: AppColors.textLight, height: 1.5),
            ),
          ],
          const SizedBox(height: 16),
          _buildTags(context),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleBook(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(AppLocalizations.of(context)!.bookAppointment, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    final tags = [
      if (doctor.city != null) doctor.city!,
      if (doctor.contactPhone != null) doctor.contactPhone!,
    ];

    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(20)),
              child: Text(tag, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
            ),
          )
          .toList(),
    );
  }
}
