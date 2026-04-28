import 'package:sanad/core/constants/codes.dart';

class OnboardingOption {
  final String id;
  final String label;
  final String description;
  final dynamic icon;

  OnboardingOption({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
  });
}

class OnboardingState {
  final String? selectedDisabilityId;
  final bool isLoading;
  final Codes? error;

  OnboardingState({
    this.selectedDisabilityId,
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    String? selectedDisabilityId,
    bool? isLoading,
    Codes? error,
  }) {
    return OnboardingState(
      selectedDisabilityId: selectedDisabilityId ?? this.selectedDisabilityId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
