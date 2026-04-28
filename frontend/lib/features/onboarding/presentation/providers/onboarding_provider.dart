import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/features/onboarding/logic/repositories/onboarding_repository.dart';
import 'package:sanad/core/services/error_handling_service.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/l10n/app_localizations.dart';
import 'onboarding_state.dart';

class OnboardingNotifier extends AsyncNotifier<OnboardingState> {
  final OnboardingRepository _repository = getIt<OnboardingRepository>();

  @override
  Future<OnboardingState> build() async {
    return OnboardingState();
  }

  void selectDisability(String id) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(selectedDisabilityId: id));
  }

  Future<void> saveSelection(AppLocalizations l10n) async {
    final oldState = state.value;
    if (oldState == null || oldState.selectedDisabilityId == null) return;

    state = const AsyncLoading();

    final response = await _repository.updateDisabilityType(oldState.selectedDisabilityId!);

    if (response.isSuccess) {
      state = AsyncValue.data(oldState.copyWith(isLoading: false));
    } else {
      final errorMessage = ErrorHandlingService.getMessage(
        response.errorCode ?? Codes.unknown,
        l10n,
      );
      state = AsyncValue.error(errorMessage, StackTrace.current);
      state = AsyncValue.data(oldState);
    }
  }
}

typedef OnboardingProvider = AsyncNotifierProvider<OnboardingNotifier, OnboardingState>;
