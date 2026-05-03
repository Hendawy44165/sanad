import 'package:get_it/get_it.dart';
import 'package:sanad/core/providers/locale_provider.dart';
import 'package:sanad/features/auth/presentation/providers/auth_provider.dart';
import 'package:sanad/features/auth/logic/repositories/auth_repository.dart';
import 'package:sanad/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sanad/core/constants/api_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/books/presentation/providers/books_provider.dart';
import 'package:sanad/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:sanad/features/doctors/presentation/providers/doctors_provider.dart';
import 'package:sanad/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:sanad/features/jobs/presentation/providers/jobs_provider.dart';
import 'package:sanad/features/profile/presentation/providers/profile_provider.dart';
import 'package:sanad/features/profile/logic/repositories/profile_repository.dart';
import 'package:sanad/features/translator/data/datasources/translator_remote_data_source.dart';
import 'package:sanad/features/translator/logic/repositories/translator_repository.dart';
import 'package:sanad/features/translator/presentation/providers/translator_provider.dart';
import 'package:sanad/features/onboarding/data/datasources/onboarding_datasource.dart';
import 'package:sanad/features/books/data/datasources/books_remote_data_source.dart';
import 'package:sanad/features/books/logic/repositories/books_repository.dart';
import 'package:sanad/features/onboarding/logic/repositories/onboarding_repository.dart';
import 'package:sanad/features/doctors/data/datasources/doctors_remote_data_source.dart';
import 'package:sanad/features/doctors/logic/repositories/doctors_repository.dart';
import 'package:sanad/features/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:sanad/features/jobs/logic/repositories/jobs_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

/// Initializes and registers all singleton and lazy singleton dependencies.
///
/// This includes third-party packages, datasources, repositories, and providers.
/// Must be called before [runApp] in [main].
Future<void> configureDependencies() async {
  //! Packages Instances
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  final dio = Dio();
  getIt.registerLazySingleton<Dio>(() => dio);

  getIt.registerLazySingleton<ApiConfig>(() => ApiConfig.fromDotEnv());

  //! Datasources
  //? Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(Supabase.instance.client, getIt<Dio>(), getIt<ApiConfig>()));

  //? Onboarding
  getIt.registerLazySingleton<OnboardingRemoteDataSource>(() => OnboardingRemoteDataSource(Supabase.instance.client, getIt<Dio>(), getIt<ApiConfig>()));

  //? Jobs
  getIt.registerLazySingleton<JobsRemoteDataSource>(() => JobsRemoteDataSource(Supabase.instance.client, getIt<Dio>(), getIt<ApiConfig>()));

  //? Doctors
  getIt.registerLazySingleton<DoctorsRemoteDataSource>(() => DoctorsRemoteDataSource(getIt<Dio>(), getIt<ApiConfig>()));

  //? Books
  getIt.registerLazySingleton<BooksRemoteDataSource>(() => BooksRemoteDataSource(getIt<Dio>(), getIt<ApiConfig>()));

  //? Translator
  getIt.registerLazySingleton<TranslatorRemoteDataSource>(() => TranslatorRemoteDataSource(getIt<Dio>(), getIt<ApiConfig>()));

  //! Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt<AuthRemoteDataSource>()));

  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository(getIt<AuthRemoteDataSource>(), getIt<JobsRemoteDataSource>()));

  getIt.registerLazySingleton<OnboardingRepository>(() => OnboardingRepository(getIt<OnboardingRemoteDataSource>()));

  getIt.registerLazySingleton<JobsRepository>(() => JobsRepository(getIt<JobsRemoteDataSource>()));

  getIt.registerLazySingleton<DoctorsRepository>(() => DoctorsRepository(getIt<DoctorsRemoteDataSource>()));

  getIt.registerLazySingleton<BooksRepository>(() => BooksRepository(getIt<BooksRemoteDataSource>()));

  getIt.registerLazySingleton<TranslatorRepository>(() => TranslatorRepository(getIt<TranslatorRemoteDataSource>()));

  //! Providers
  //? Locale
  getIt.registerLazySingleton<LocaleProvider>(() => LocaleProvider(() => LocaleNotifier(getIt<SharedPreferences>())));

  getIt.registerLazySingleton<AuthProvider>(() => AuthProvider(() => AuthNotifier(getIt<AuthRepository>())));
  //? Profile
  getIt.registerLazySingleton<ProfileProvider>(() => ProfileProvider(() => ProfileNotifier(getIt<ProfileRepository>(), getIt<SharedPreferences>())));
  //? Books
  getIt.registerLazySingleton<BooksProvider>(() => BooksProvider(() => BooksNotifier(getIt<BooksRepository>())));
  //? Dashboard
  getIt.registerLazySingleton<DashboardProvider>(() => DashboardProvider(() => DashboardNotifier(getIt<JobsRepository>(), getIt<DoctorsRepository>(), getIt<BooksRepository>())));
  //? Doctors
  getIt.registerLazySingleton<DoctorsProvider>(() => DoctorsProvider(() => DoctorsNotifier(getIt<DoctorsRepository>())));
  //? Onboarding
  getIt.registerLazySingleton<OnboardingProvider>(() => OnboardingProvider(() => OnboardingNotifier(getIt<OnboardingRepository>())));
  //? Jobs
  getIt.registerLazySingleton<JobsProvider>(() => JobsProvider(() => JobsNotifier(getIt<JobsRepository>())));
  //? Translator
  getIt.registerLazySingleton<TranslatorProvider>(() => TranslatorProvider(() => TranslatorNotifier(getIt<TranslatorRepository>())));
}
