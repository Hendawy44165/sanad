import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/repositories/supabase_repository.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/events/data/models/event.dart';
import '../widgets/event_card.dart';

/// Screen that displays a list of upcoming community events.
class EventsScreen extends ConsumerWidget {
  /// Creates an [EventsScreen].
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(eventsProvider.future),
        child: _buildBody(eventsAsync),
      ),
    );
  }

  /// Builds the application bar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Upcoming Events'), centerTitle: false);
  }

  /// Builds the main body content.
  Widget _buildBody(AsyncValue<List<Event>> eventsAsync) {
    return eventsAsync.when(
      data: (events) => _buildEventsList(events),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  /// Builds the list of events.
  Widget _buildEventsList(List<Event> events) {
    if (events.isEmpty) {
      return const Center(child: Text('No upcoming events'));
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        return EventCard(event: events[index]);
      },
    );
  }
}
