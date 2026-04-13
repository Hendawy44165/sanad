import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/repositories/supabase_repository.dart';
import 'package:sanad/core/services/notification_service.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/doctors/presentation/screens/doctors_screen.dart';
import 'package:sanad/features/events/presentation/screens/events_screen.dart';
import 'package:sanad/features/medications/data/models/medication_alarm.dart';
import 'package:sanad/features/medications/presentation/screens/add_medication_screen.dart';
import 'package:sanad/features/news/presentation/screens/news_screen.dart';
import 'package:sanad/features/services/presentation/screens/services_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/dashboard_section.dart';

/// The main dashboard screen displaying an overview of the application features.
class DashboardScreen extends ConsumerWidget {
  /// Creates a [DashboardScreen].
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check for disability selection
    ref.listen(userProfileProvider, (previous, next) {
      next.whenData((profile) {
        if (profile != null && profile.disabilityType == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/select_disability');
          });
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(medicationAlarmsProvider.future),
            ref.refresh(eventsProvider.future),
            ref.refresh(servicesProvider.future),
            ref.refresh(newsProvider.future),
            ref.refresh(doctorsProvider.future),
          ]);
        },
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [_buildHeader(context), _buildContent(context, ref)],
          ),
        ),
      ),
    );
  }

  /// Builds the dashboard header with greeting and logout button.
  Widget _buildHeader(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello, Friend! 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Here's what's happening today",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.text.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.logout, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
  }

  /// Builds the main content content list.
  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildAlarmsSection(context, ref),
          const SizedBox(height: 24),
          _buildEntertainmentSection(context, ref),
          const SizedBox(height: 24),
          _buildServicesSection(context, ref),
          const SizedBox(height: 24),
          _buildNewsSection(context, ref),
          const SizedBox(height: 24),
          _buildDoctorsSection(context, ref),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _buildAlarmsSection(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(medicationAlarmsProvider);

    return DashboardSection(
      title: 'Medication Reminders',
      subtitle: alarmsAsync.when(
        data: (alarms) {
          final activeCount = alarms.where((a) => a.isActive).length;
          return '$activeCount active reminder${activeCount != 1 ? 's' : ''}';
        },
        loading: () => 'Loading...',
        error: (err, stack) => 'Error',
      ),
      icon: Icons.notifications_active,
      iconColor: AppColors.accent,
      iconBgColor: AppColors.accent,
      action: IconButton(
        icon: const Icon(Icons.add_circle_outline),
        color: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMedicationScreen(),
            ),
          );
        },
      ),
      child: alarmsAsync.when(
        data: (alarms) {
          if (alarms.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('No reminders set'),
            );
          }
          return Column(
            children: alarms
                .take(2)
                .map(
                  (alarm) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildAlarmItem(alarm: alarm, ref: ref),
                  ),
                )
                .toList(),
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (err, _) => Text('Error: $err'),
      ),
    );
  }

  Widget _buildEntertainmentSection(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return DashboardSection(
      title: 'Entertainment',
      subtitle: 'Events near you',
      icon: Icons.movie,
      iconColor: Colors.purple,
      iconBgColor: Colors.purple,
      action: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EventsScreen()),
          );
        },
        child: const Text('View All'),
      ),
      child: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return const Text('No upcoming events');
          }
          final event = events.first;
          return _buildEventItem(
            title: event.title,
            date:
                '${_getMonth(event.date)} ${event.date.day}, ${event.date.year} • ${event.time}',
            location: event.location ?? 'Online',
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Text('Error: $err'),
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return DashboardSection(
      title: 'Support Services',
      subtitle: 'People ready to help',
      icon: Icons.handshake,
      iconColor: AppColors.success,
      iconBgColor: AppColors.success,
      action: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ServicesScreen()),
          );
        },
        child: const Text('View All'),
      ),
      child: servicesAsync.when(
        data: (services) {
          if (services.isEmpty) {
            return const Text('No services found');
          }
          return Column(
            children: services
                .take(2)
                .map(
                  (service) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildServiceItem(
                      title: service.title,
                      provider: service.provider,
                      rating: service.rating,
                      isAvailable: service.isAvailable,
                    ),
                  ),
                )
                .toList(),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Text('Error: $err'),
      ),
    );
  }

  Widget _buildNewsSection(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return DashboardSection(
      title: 'Latest News',
      subtitle: 'Curated for you',
      icon: Icons.newspaper,
      iconColor: Colors.blue,
      iconBgColor: Colors.blue,
      action: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewsScreen()),
          );
        },
        child: const Text('View All'),
      ),
      child: newsAsync.when(
        data: (news) {
          if (news.isEmpty) {
            return const Text('No news available');
          }
          final item = news.first;
          return _buildNewsItem(
            title: item.title,
            source: item.source ?? 'Unknown Source',
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Text('Error: $err'),
      ),
    );
  }

  Widget _buildDoctorsSection(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorsProvider);

    return DashboardSection(
      title: 'Medical Specialists',
      subtitle: 'Find trusted care',
      icon: Icons.medical_services,
      iconColor: Colors.red,
      iconBgColor: Colors.red,
      action: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DoctorsScreen()),
          );
        },
        child: const Text('View All'),
      ),
      child: doctorsAsync.when(
        data: (doctors) {
          if (doctors.isEmpty) {
            return const Text('No doctors found');
          }
          final doctor = doctors.first;
          return _buildDoctorItem(
            name: doctor.name,
            specialty: doctor.specialty ?? 'General',
            hospital: doctor.hospital ?? 'Unknown',
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Text('Error: $err'),
      ),
    );
  }

  Widget _buildAlarmItem({
    required MedicationAlarm alarm,
    required WidgetRef ref,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alarm.time,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              Text(
                alarm.frequency,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarm.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                if (alarm.dosage != null)
                  Text(
                    alarm.dosage!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: alarm.isActive,
            onChanged: (val) async {
              await ref
                  .read(supabaseRepositoryProvider)
                  .toggleAlarmStatus(alarm.id, val);

              // Toggle notification based on switch state
              final notificationService = ref.read(notificationServiceProvider);
              if (val) {
                // Parse time string 'HH:MM' back to TimeOfDay for scheduling
                final timeParts = alarm.time.split(':');
                final time = TimeOfDay(
                  hour: int.parse(timeParts[0]),
                  minute: int.parse(timeParts[1]),
                );
                await notificationService.scheduleAlarm(
                  id: alarm.id.hashCode,
                  title: 'Medication Reminder',
                  body: "It's time to take ${alarm.title}",
                  time: time,
                );
              } else {
                await notificationService.cancelAlarm(alarm.id.hashCode);
              }

              ref.invalidate(medicationAlarmsProvider);
            },
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem({
    required String title,
    required String date,
    required String location,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.event, color: Colors.purple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({
    required String title,
    required String provider,
    required double rating,
    required bool isAvailable,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? AppColors.success.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAvailable ? 'Available' : 'Busy',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isAvailable ? AppColors.success : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '🚗 Transport • $provider',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textLight),
        ],
      ),
    );
  }

  Widget _buildNewsItem({required String title, required String source}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.text,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            source,
            style: const TextStyle(fontSize: 12, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorItem({
    required String name,
    required String specialty,
    required String hospital,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              name.isNotEmpty ? name[0] : '',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  '$specialty • $hospital',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textLight),
        ],
      ),
    );
  }

  String _getMonth(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }
}
