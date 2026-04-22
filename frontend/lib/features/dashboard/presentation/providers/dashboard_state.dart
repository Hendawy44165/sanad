class DashboardState {
  final int selectedIndex;

  DashboardState({
    this.selectedIndex = 0,
  });

  DashboardState copyWith({
    int? selectedIndex,
  }) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
