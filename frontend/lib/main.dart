import 'package:flutter/material.dart';
import 'package:sanad/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["SUPABASE_ANON_KEY"]!,
  );

  await configureDependencies();

  runApp(ProviderScope(child: SanadApp()));
}
