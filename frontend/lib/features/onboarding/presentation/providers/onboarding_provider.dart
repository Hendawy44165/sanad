import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/features/onboarding/logic/repositories/onboarding_repository.dart';
import 'package:sanad/core/constants/codes.dart';
import 'onboarding_state.dart';

class OnboardingNotifier extends AsyncNotifier<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingNotifier(this._repository);

  @override
  Future<OnboardingState> build() async {
    return OnboardingState();
  }

  void selectDisability(String id) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(selectedDisabilityId: id));
  }

  Future<void> saveSelection() async {
    final oldState = state.value;
    if (oldState == null || oldState.selectedDisabilityId == null) return;

    state = const AsyncLoading();

    final response = await _repository.updateDisabilityType(oldState.selectedDisabilityId!);

    if (response.isSuccess) {
      state = AsyncValue.data(oldState.copyWith(isLoading: false));
    } else {
      state = AsyncValue.data(oldState.copyWith(isLoading: false, error: response.errorCode ?? Codes.unknown));
    }
  }

  void clearError() {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(error: null));
  }
}

typedef OnboardingProvider = AsyncNotifierProvider<OnboardingNotifier, OnboardingState>;
