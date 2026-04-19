import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for SharedPreferences instance.
/// Must be overridden in ProviderScope in main.dart.
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
