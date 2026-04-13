import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/doctors/data/models/doctor.dart';

/// Card widget to display a doctor's information.
class DoctorCard extends StatelessWidget {
  /// The doctor to display.
  final Doctor doctor;

  /// Creates a [DoctorCard].
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAvatar(),
          const SizedBox(height: 16),
          _buildNameText(),
          const SizedBox(height: 4),
          _buildSpecialtyText(),
          const SizedBox(height: 8),
          _buildLocationRow(),
          const SizedBox(height: 16),
          _buildStatsRow(),
          const Spacer(),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 40,
      backgroundImage: doctor.imageUrl != null
          ? NetworkImage(doctor.imageUrl!)
          : null,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      child: doctor.imageUrl == null
          ? Text(
              doctor.name.isNotEmpty ? doctor.name[0] : '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            )
          : null,
    );
  }

  Widget _buildNameText() {
    return Text(
      doctor.name,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSpecialtyText() {
    return Text(
      doctor.specialty ?? '',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildLocationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, size: 14, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(
          doctor.hospital ?? '',
          style: const TextStyle(fontSize: 14, color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRatingBadge(),
        const SizedBox(width: 8),
        _buildAvailabilityBadge(),
      ],
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, size: 14, color: AppColors.warning),
          const SizedBox(width: 4),
          Text(
            '${doctor.rating} (${doctor.reviewsCount})',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: doctor.isAvailable
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: doctor.isAvailable
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        doctor.isAvailable ? 'Available' : 'Busy',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: doctor.isAvailable ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _handleContact(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.text,
              side: const BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 18),
                SizedBox(width: 8),
                Text('Chat'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: doctor.isAvailable
                ? () => _handleContact(context)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Book'),
          ),
        ),
      ],
    );
  }

  void _handleContact(BuildContext context) {
    if (doctor.contactEmail != null && doctor.contactEmail!.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: doctor.contactEmail!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied ${doctor.contactEmail} to clipboard'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No contact email available for this doctor'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
