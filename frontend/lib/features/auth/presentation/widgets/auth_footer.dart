import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.dataSecure,
      style: const TextStyle(color: AppColors.textLight, fontSize: 14),
    );
  }
}
