import 'package:flutter/material.dart';

enum AppButtonType {
  primary,
  secondary,
  outlined,
  inverted,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final (
      backgroundColor,
      foregroundColor,
      borderSide,
    ) = _resolveColors(colorScheme);

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: backgroundColor.withValues(
        alpha: 0.5,
      ),
      disabledForegroundColor: foregroundColor.withValues(
        alpha: 0.7,
      ),
      elevation: 0,
      side: borderSide,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );

    final child = _buildChild(
      foregroundColor: foregroundColor,
    );

    final button = ElevatedButton(
      onPressed: isLoading || onPressed == null
          ? null
          : onPressed,
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

  (
    Color,
    Color,
    BorderSide?,
  ) _resolveColors(ColorScheme colorScheme) {
    switch (type) {
      case AppButtonType.primary:
        return (
          colorScheme.primary,
          colorScheme.onPrimary,
          null,
        );

      case AppButtonType.secondary:
        return (
          colorScheme.secondary,
          colorScheme.onSecondary,
          null,
        );

      case AppButtonType.outlined:
        return (
          Colors.transparent,
          colorScheme.primary,
          BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        );

      case AppButtonType.inverted:
        return (
          colorScheme.surface,
          colorScheme.primary,
          null,
        );
    }
  }

  Widget _buildChild({
    required Color foregroundColor,
  }) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: foregroundColor,
        ),
      );
    }

    final labelWidget = Text(
      label,
      style: TextStyle(
        color: foregroundColor,
        fontWeight: FontWeight.w600,
      ),
    );

    if (icon == null) {
      return labelWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon!,
        const SizedBox(width: 8),
        labelWidget,
      ],
    );
  }
}