import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AnimatedInputField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AnimatedInputField({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false,
    required this.controller,
    this.validator,
  });

  @override
  State<AnimatedInputField> createState() => _AnimatedInputFieldState();
}

class _AnimatedInputFieldState extends State<AnimatedInputField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused
              ? AppColors.primary
              : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
        child: TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          style: const TextStyle(color: AppColors.text),
          validator: widget.validator,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            labelText: widget.label,
            labelStyle: TextStyle(
              color: AppColors.text.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              widget.icon,
              color: AppColors.text.withValues(alpha: 0.5),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.text.withValues(alpha: 0.5),
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
