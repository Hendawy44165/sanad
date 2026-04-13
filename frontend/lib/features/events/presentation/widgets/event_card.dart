import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/events/data/models/event.dart';

/// Card widget to display an event's details.
class EventCard extends StatelessWidget {
  /// The event to display.
  final Event event;

  /// Creates an [EventCard].
  const EventCard({super.key, required this.event});

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
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildDateColumn(), _buildContentColumn(context)],
        ),
      ),
    );
  }

  Widget _buildDateColumn() {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: const Border(right: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getMonth(event.date),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            event.date.day.toString(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getWeekday(event.date),
            style: const TextStyle(fontSize: 11, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildContentColumn(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBadges(),
            const SizedBox(height: 12),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildDetails(),
            const SizedBox(height: 12),
            _buildDescription(),
            const SizedBox(height: 16),
            _buildOrganizerAndAction(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildBadge(event.category, isOutline: true),
        ...event.accessibilityFeatures.map((f) => _buildBadge(f)),
      ],
    );
  }

  Widget _buildBadge(String text, {bool isOutline = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : AppColors.secondary,
        borderRadius: BorderRadius.circular(6),
        border: isOutline ? Border.all(color: AppColors.border) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isOutline ? AppColors.text : AppColors.onSecondary,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      event.title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildDetails() {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 14, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(
          event.time,
          style: const TextStyle(fontSize: 12, color: AppColors.textLight),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.location_on, size: 14, color: AppColors.textLight),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            event.location ?? 'Online',
            style: const TextStyle(fontSize: 12, color: AppColors.textLight),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      event.description ?? '',
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textLight,
        height: 1.5,
      ),
    );
  }

  Widget _buildOrganizerAndAction(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'By ${event.organizer}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
        ),
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: () => _handleRegistration(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Register'),
          ),
        ),
      ],
    );
  }

  void _handleRegistration(BuildContext context) {
    if (event.contactEmail != null && event.contactEmail!.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: event.contactEmail!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied ${event.contactEmail} to clipboard'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No contact email available for this event'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _getMonth(DateTime date) {
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    return months[date.month - 1];
  }

  String _getWeekday(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    // DateTime.weekday returns 1 for Monday
    return days[date.weekday - 1];
  }
}
