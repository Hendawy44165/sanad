import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  final String baseUrl;
  final AuthEndpoints auth;
  final ProfileEndpoints profile;

  ApiConfig(this.baseUrl)
      : auth = AuthEndpoints(baseUrl),
        profile = ProfileEndpoints(baseUrl);

  factory ApiConfig.fromDotEnv() {
    return ApiConfig(dotenv.env['API_BASE_URL']!);
  }
}

class AuthEndpoints {
  final String syncProfile;

  AuthEndpoints(String baseUrl) : syncProfile = '$baseUrl/auth/sync-profile';
}

class ProfileEndpoints {
  final String me;

  ProfileEndpoints(String baseUrl) : me = '$baseUrl/profile/me';
}
