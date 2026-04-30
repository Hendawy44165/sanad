import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  final String baseUrl;
  final AuthEndpoints auth;
  final ProfileEndpoints profile;
  final JobsEndpoints jobs;
  final DoctorsEndpoints doctors;
  final StoreEndpoints store;

  ApiConfig(this.baseUrl)
      : auth = AuthEndpoints(baseUrl),
        profile = ProfileEndpoints(baseUrl),
        jobs = JobsEndpoints(baseUrl),
        doctors = DoctorsEndpoints(baseUrl),
        store = StoreEndpoints(baseUrl);

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

class JobsEndpoints {
  final String list;
  final String uploadCv;

  JobsEndpoints(String baseUrl)
      : list = '$baseUrl/jobs',
        uploadCv = '$baseUrl/uploads/cv';
}

class DoctorsEndpoints {
  final String list;

  DoctorsEndpoints(String baseUrl) : list = '$baseUrl/doctors';
}

class StoreEndpoints {
  final String products;

  StoreEndpoints(String baseUrl) : products = '$baseUrl/store/products';
}
