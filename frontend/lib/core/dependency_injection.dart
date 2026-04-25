import 'package:get_it/get_it.dart';
import 'package:sanad/core/providers/locale_provider.dart';
import 'package:sanad/features/auth/presentation/providers/auth_provider.dart';
import 'package:sanad/features/auth/logic/repositories/auth_repository.dart';
import 'package:sanad/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/books/presentation/providers/books_provider.dart';
import 'package:sanad/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:sanad/features/doctors/presentation/providers/doctors_provider.dart';
import 'package:sanad/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:sanad/features/jobs/presentation/providers/jobs_provider.dart';
import 'package:sanad/features/profile/presentation/providers/profile_provider.dart';
import 'package:sanad/features/profile/logic/repositories/profile_repository.dart';
import 'package:sanad/features/translator/presentation/providers/translator_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  //! Packages Instances
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  final dio = Dio();
  getIt.registerLazySingleton<Dio>(() => dio);

  //! Datasources
  //? Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(Supabase.instance.client, getIt<Dio>()),
  );

  //! Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(getIt<AuthRemoteDataSource>()),
  );

  //! Providers
  //? Locale
  getIt.registerLazySingleton<LocaleProvider>(
    () => LocaleProvider(LocaleNotifier.new),
  );

  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(AuthNotifier.new),
  );
  //? Profile
  getIt.registerLazySingleton<ProfileProvider>(
    () => ProfileProvider(ProfileNotifier.new),
  );
  //? Books
  getIt.registerLazySingleton<BooksProvider>(
    () => BooksProvider(BooksNotifier.new),
  );
  //? Dashboard
  getIt.registerLazySingleton<DashboardProvider>(
    () => DashboardProvider(DashboardNotifier.new),
  );
  //? Doctors
  getIt.registerLazySingleton<DoctorsProvider>(
    () => DoctorsProvider(DoctorsNotifier.new),
  );
  //? Onboarding
  getIt.registerLazySingleton<OnboardingProvider>(
    () => OnboardingProvider(OnboardingNotifier.new),
  );
  //? Jobs
  getIt.registerLazySingleton<JobsProvider>(
    () => JobsProvider(JobsNotifier.new),
  );
  //? Translator
  getIt.registerLazySingleton<TranslatorProvider>(
    () => TranslatorProvider(TranslatorNotifier.new),
  );
}
