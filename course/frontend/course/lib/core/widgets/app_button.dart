import 'package:flutter/material.dart';

/// Các kiểu button được hỗ trợ trong ứng dụng.
enum AppButtonType {
  primary,
  secondary,
  outlined,
  inverted,
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (type) {
      case AppButtonType.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;

      case AppButtonType.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        break;

      case AppButtonType.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderSide = BorderSide(
          color: colorScheme.primary,
          width: 1.5,
        );
        break;

      case AppButtonType.inverted:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.primary;
        break;
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      side: borderSide,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
    );

    final textStyle = theme.textTheme.labelLarge;

    Widget child;

    if (isLoading) {
      child = SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: foregroundColor,
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(label, style: textStyle),
        ],
      );
    } else {
      child = Text(label, style: textStyle);
    }

    final button = ElevatedButton(
      onPressed: (isLoading || onPressed == null) ? null : onPressed,
      style: buttonStyle,
      child: child,
    );

    if (!isFullWidth) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}