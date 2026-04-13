import 'package:mocktail/mocktail.dart';
import 'package:sanad/core/repositories/supabase_repository.dart';
import 'package:sanad/features/doctors/data/models/doctor.dart';
import 'package:sanad/features/events/data/models/event.dart';
import 'package:sanad/features/medications/data/models/medication_alarm.dart';
import 'package:sanad/features/news/data/models/news_item.dart';
import 'package:sanad/features/services/data/models/service_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/auth/data/models/profile.dart';

class MockSupabaseRepository extends Mock implements SupabaseRepository {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

// --- Mock Data ---

final mockEvents = [
  Event(
    id: '1',
    title: 'Community Gathering',
    date: DateTime.now().add(const Duration(days: 2)),
    time: '10:00 AM',
    location: 'Community Center',
    category: 'Social',
  ),
];

final mockServices = [
  ServiceModel(
    id: '1',
    title: 'Medical Transport',
    provider: 'Red Cross',
    category: 'Transport',
    rating: 4.8,
    reviewsCount: 120,
    isAvailable: true,
  ),
];

final mockNews = [
  NewsItem(
    id: '1',
    title: 'New Health Guidelines',
    category: 'Health',
    publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    source: 'Ministry of Health',
  ),
];

final mockDoctors = [
  Doctor(
    id: '1',
    name: 'Dr. Smith',
    specialty: 'Cardiologist',
    hospital: 'City Hospital',
    rating: 4.9,
    reviewsCount: 200,
    isAvailable: true,
  ),
];

final mockAlarms = [
  MedicationAlarm(
    id: '1',
    userId: 'user1',
    title: 'Aspirin',
    dosage: '100mg',
    time: '08:00',
    isActive: true,
  ),
];

final mockProfile = Profile(
  id: 'user1',
  email: 'test@example.com',
  fullName: 'Test User',
  disabilityType: 'None',
);
