import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sanad/features/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:sanad/features/jobs/logic/entities/job_entity.dart';
import 'package:sanad/features/jobs/logic/entities/jobs_list_entity.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';

/// Repository responsible for handling Jobs-related data operations.
///
/// This class serves as the single source of truth for job data,
/// coordinating between the remote data source and the presentation layer.
/// It maps raw data models to clean business entities and handles pagination.
class JobsRepository {
  final JobsRemoteDataSource _remoteDataSource;

  /// Creates a [JobsRepository] with the required data source.
  ///
  /// Variables: [_remoteDataSource] used for API network calls.
  JobsRepository(this._remoteDataSource);

  /// Retrieves a paginated list of jobs based on search criteria.
  ///
  /// Description: Fetches job models from the remote source and converts them to entities.
  /// Side Effects: Makes a GET request to the backend.
  /// Variables:
  ///   [query] optional search text.
  ///   [isRemote] optional location filter.
  ///   [page] the page number to fetch.
  /// Assumptions: The backend returns a valid JSON matching the [JobModel] schema.
  Future<ResponseModel<JobsListEntity>> getJobs({String? query, bool? isRemote, int page = 1, int limit = 20}) async {
    try {
      final response = await _remoteDataSource.getJobs(query: query, isRemote: isRemote, page: page, limit: limit);

      final entities = response.jobs.map((model) => JobEntity.fromModel(model)).toList();
      return ResponseModel.success(JobsListEntity(jobs: entities, hasNext: response.hasNext));
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } catch (e) {
      return const ResponseModel.failure(Codes.unknown);
    }
  }

  /// Uploads a user's CV file to the dedicated backend.
  ///
  /// Description: Validates the local file before sending a multipart request to the upload endpoint.
  /// Side Effects: Makes a POST request to the backend.
  /// Variables: [filePath] The absolute local path to the file to be uploaded.
  /// Assumptions: The file at [filePath] exists and is in a supported format (PDF, DOC, DOCX).
  Future<ResponseModel<String>> uploadCv(String filePath) async {
    try {
      final file = File(filePath);

      // 1. Check if file exists
      if (!(await file.exists())) {
        return const ResponseModel.failure(Codes.fileNotFound);
      }

      // 2. Check for supported extensions
      final extension = path.extension(filePath).toLowerCase();
      final allowedExtensions = ['.pdf', '.doc', '.docx'];
      if (!allowedExtensions.contains(extension)) {
        return const ResponseModel.failure(Codes.invalidFileType);
      }

      // 3. Attempt to read (check for permissions)
      try {
        await file.openRead(0, 1).first;
      } catch (e) {
        return const ResponseModel.failure(Codes.permissionDenied);
      }

      final url = await _remoteDataSource.uploadCv(filePath);
      return ResponseModel.success(url);
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } catch (e) {
      return const ResponseModel.failure(Codes.unknown);
    }
  }
}
