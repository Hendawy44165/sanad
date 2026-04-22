import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../l10n/app_localizations.dart';

class DashboardBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const DashboardBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemSelected,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF004D40),
        unselectedItemColor: const Color(0xFF94A3B8),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.layoutGrid),
            label: AppLocalizations.of(context)!.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.briefcase),
            label: AppLocalizations.of(context)!.jobs,
          ),
          const BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.stethoscope),
            label: AppLocalizations.of(context)!.doctors,
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.bookOpen),
            label: AppLocalizations.of(context)!.books,
          ),
        ],
      ),
    );
  }
}
