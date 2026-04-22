import 'package:get_it/get_it.dart';
import 'package:sanad/core/providers/locale_provider.dart';
import 'package:sanad/features/profile/presentation/providers/profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  //! Packages Instances
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  //! Providers
  //? Locale
  getIt.registerLazySingleton<LocaleProvider>(
    () => LocaleProvider(LocaleNotifier.new),
  );
  //? Profile
  getIt.registerLazySingleton<ProfileProvider>(
    () => ProfileProvider(ProfileNotifier.new),
  );
}
