import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/services/data/models/service_model.dart';

/// Card widget to display service details.
class ServiceCard extends StatelessWidget {
  /// The service to display.
  final ServiceModel service;

  /// Creates a [ServiceCard].
  const ServiceCard({super.key, required this.service});

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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildTitleAndProvider(),
          const SizedBox(height: 12),
          _buildDescription(),
          const SizedBox(height: 20),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildCategoryBadge(), if (service.rating > 0) _buildRating()],
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        service.category.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.onSecondary,
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        const Icon(Icons.star, size: 16, color: AppColors.warning),
        const SizedBox(width: 4),
        Text(
          service.rating.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTitleAndProvider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          service.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.person_outline,
              size: 16,
              color: AppColors.textLight,
            ),
            const SizedBox(width: 4),
            Text(
              service.provider,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      service.description ?? '',
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textLight,
        height: 1.5,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: service.isAvailable
            ? () => _handleRequestHelp(context)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          service.isAvailable ? 'Request Help' : 'Currently Unavailable',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _handleRequestHelp(BuildContext context) {
    if (service.contactEmail != null && service.contactEmail!.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: service.contactEmail!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied ${service.contactEmail} to clipboard'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No contact email available for this service'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
