import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

/// Screen for the user to select their primary need/disability type.
class SelectDisabilityScreen extends StatefulWidget {
  /// Creates a [SelectDisabilityScreen].
  const SelectDisabilityScreen({super.key});

  @override
  State<SelectDisabilityScreen> createState() => _SelectDisabilityScreenState();
}

class _SelectDisabilityScreenState extends State<SelectDisabilityScreen> {
  String? _selectedId;

  final List<Map<String, dynamic>> _options = [
    {
      'id': 'visual',
      'label': 'Visual',
      'description': 'Blindness, low vision, or color blindness',
      'icon': Icons.visibility,
    },
    {
      'id': 'hearing',
      'label': 'Hearing',
      'description': 'Deafness or hard of hearing',
      'icon': Icons.hearing,
    },
    {
      'id': 'mobility',
      'label': 'Mobility',
      'description': 'Difficulty with movement or physical tasks',
      'icon': Icons.accessible,
    },
    {
      'id': 'cognitive',
      'label': 'Cognitive',
      'description': 'Learning, memory, or concentration challenges',
      'icon': Icons.psychology,
    },
    {
      'id': 'chronic',
      'label': 'Chronic Illness',
      'description': 'Long-term health conditions',
      'icon': Icons.favorite,
    },
    {
      'id': 'other',
      'label': 'Other',
      'description': 'Another type of disability or multiple',
      'icon': Icons.help_outline,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _buildBackgroundDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildWelcomeHeader(),
                      const SizedBox(height: 32),
                      _buildOptionsList(),
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.background, AppColors.secondary],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        const Text(
          'Welcome, Friend!',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'How can we best support you?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Select your primary need so we can personalize your experience and show relevant resources.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textLight,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final option = _options[index];
        return _buildOptionCard(
          id: option['id'],
          label: option['label'],
          description: option['description'],
          icon: option['icon'],
        );
      },
    );
  }

  Widget _buildOptionCard({
    required String id,
    required String label,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedId == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedId = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 2,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: AppColors.text.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.onSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Continue',
              onPressed: _selectedId != null ? _handleContinue : null,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You can change this anytime in settings',
            style: TextStyle(color: AppColors.textLight, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _handleContinue() async {
    if (_selectedId == null) return;

    try {
      // Get current user
      final user = Supabase.instance.client.auth.currentUser;
      await Supabase.instance.client
          .from('profiles')
          .update({'disability_type': _selectedId})
          .eq('id', user!.id);
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving selection: $e')));
      }
    }
  }
}
