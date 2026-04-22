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

  OnboardingState({
    this.selectedDisabilityId,
    this.isLoading = false,
  });

  OnboardingState copyWith({
    String? selectedDisabilityId,
    bool? isLoading,
  }) {
    return OnboardingState(
      selectedDisabilityId: selectedDisabilityId ?? this.selectedDisabilityId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
