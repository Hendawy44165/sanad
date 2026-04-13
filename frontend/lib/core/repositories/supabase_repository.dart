import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/features/auth/data/models/profile.dart';
import 'package:sanad/features/doctors/data/models/doctor.dart';
import 'package:sanad/features/events/data/models/event.dart';
import 'package:sanad/features/medications/data/models/medication_alarm.dart';
import 'package:sanad/features/news/data/models/news_item.dart';
import 'package:sanad/features/services/data/models/service_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  final SupabaseClient _client;

  SupabaseRepository(this._client);

  Future<Profile?> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (response == null) return null;
      return Profile.fromJson(response);
    } catch (e) {
      // If table doesn't exist or other error, return null or rethrow
      return null;
    }
  }

  Future<void> updateProfile(Profile profile) async {
    await _client.from('profiles').upsert(profile.toJson());
  }

  Future<List<Event>> getEvents() async {
    final response = await _client
        .from('events')
        .select()
        .order('date', ascending: true);
    return (response as List).map((e) => Event.fromJson(e)).toList();
  }

  Future<List<ServiceModel>> getServices() async {
    final response = await _client
        .from('services')
        .select()
        .order('created_at', ascending: false);
    return (response as List).map((e) => ServiceModel.fromJson(e)).toList();
  }

  /// Adds a new community service.
  Future<ServiceModel> addService(ServiceModel service) async {
    final serviceJson = service.toJson()..remove('id');
    final response = await _client
        .from('services')
        .insert(serviceJson)
        .select()
        .single();
    return ServiceModel.fromJson(response);
  }

  Future<List<NewsItem>> getNews() async {
    final response = await _client
        .from('news_items')
        .select()
        .order('published_at', ascending: false);
    return (response as List).map((e) => NewsItem.fromJson(e)).toList();
  }

  Future<List<Doctor>> getDoctors() async {
    final response = await _client
        .from('doctors')
        .select()
        .order('rating', ascending: false);
    return (response as List).map((e) => Doctor.fromJson(e)).toList();
  }

  Future<List<MedicationAlarm>> getMedicationAlarms() async {
    final response = await _client
        .from('medication_alarms')
        .select()
        .order('time', ascending: true);
    return (response as List).map((e) => MedicationAlarm.fromJson(e)).toList();
  }

  /// Adds a new medication alarm.
  ///
  /// Returns the saved [MedicationAlarm] with the generated [id].
  Future<MedicationAlarm> addMedicationAlarm(MedicationAlarm alarm) async {
    final alarmJson = alarm.toJson()..remove('id');
    final response = await _client
        .from('medication_alarms')
        .insert(alarmJson)
        .select()
        .single();
    return MedicationAlarm.fromJson(response);
  }

  Future<void> updateMedicationAlarm(MedicationAlarm alarm) async {
    await _client
        .from('medication_alarms')
        .update(alarm.toJson())
        .eq('id', alarm.id);
  }

  Future<void> deleteMedicationAlarm(String id) async {
    await _client.from('medication_alarms').delete().eq('id', id);
  }

  /// Toggles the active status of an alarm.
  Future<void> toggleAlarmStatus(String id, bool isActive) async {
    await _client
        .from('medication_alarms')
        .update({'is_active': isActive})
        .eq('id', id);
  }
}

// Providers
final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});

final supabaseRepositoryProvider = Provider((ref) {
  return SupabaseRepository(ref.watch(supabaseClientProvider));
});

final eventsProvider = FutureProvider((ref) async {
  ref.watch(authStateProvider);
  return ref.watch(supabaseRepositoryProvider).getEvents();
});

final servicesProvider = FutureProvider((ref) async {
  ref.watch(authStateProvider);
  return ref.watch(supabaseRepositoryProvider).getServices();
});

final newsProvider = FutureProvider((ref) async {
  ref.watch(authStateProvider);
  return ref.watch(supabaseRepositoryProvider).getNews();
});

final doctorsProvider = FutureProvider((ref) async {
  ref.watch(authStateProvider);
  return ref.watch(supabaseRepositoryProvider).getDoctors();
});

final medicationAlarmsProvider = FutureProvider((ref) async {
  ref.watch(authStateProvider);
  return ref.watch(supabaseRepositoryProvider).getMedicationAlarms();
});

final userProfileProvider = FutureProvider((ref) async {
  final authState = ref.watch(authStateProvider);
  final user =
      authState.value?.session?.user ??
      ref.watch(supabaseClientProvider).auth.currentUser;

  if (user == null) return null;
  return ref.watch(supabaseRepositoryProvider).getProfile(user.id);
});
