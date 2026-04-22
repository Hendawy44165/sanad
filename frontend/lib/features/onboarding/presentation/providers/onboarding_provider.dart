import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'onboarding_state.dart';

class OnboardingNotifier extends AsyncNotifier<OnboardingState> {
  @override
  Future<OnboardingState> build() async {
    return OnboardingState();
  }

  void selectDisability(String id) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(selectedDisabilityId: id));
  }

  Future<void> saveSelection() async {
    if (state.value == null || state.value!.selectedDisabilityId == null) return;
    
    state = const AsyncLoading();
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      await Supabase.instance.client
          .from('profiles')
          .update({'disability_type': state.value!.selectedDisabilityId})
          .eq('id', user.id);
      
      state = AsyncValue.data(state.value!.copyWith(isLoading: false));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

typedef OnboardingProvider = AsyncNotifierProvider<OnboardingNotifier, OnboardingState>;
