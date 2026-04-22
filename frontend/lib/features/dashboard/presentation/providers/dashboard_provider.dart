import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_state.dart';

class DashboardNotifier extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() async {
    return DashboardState();
  }

  void setSelectedIndex(int index) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(selectedIndex: index));
  }
}

typedef DashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardState>;
