import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashapp_free/utils/localization_helper.dart';
import 'package:cashapp_free/providers/index.dart';

/// Custom AppBar with Material 3 styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      actions: actions,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

/// Reusable loading dialog
void showLoadingDialog(BuildContext context, {String? message}) {
  final lang = Provider.of<SettingsProvider>(context, listen: false).language;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message ?? t('common.loading', lang)),
        ],
      ),
    ),
  );
}

/// Reusable error dialog
void showErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? buttonText,
}) {
  final lang = Provider.of<SettingsProvider>(context, listen: false).language;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(buttonText ?? t('common.confirm', lang)),
        ),
      ],
    ),
  );
}

/// Reusable confirm dialog
Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
}) {
  final lang = Provider.of<SettingsProvider>(context, listen: false).language;
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText ?? t('common.cancel', lang)),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText ?? t('common.confirm', lang)),
        ),
      ],
    ),
  );
}
