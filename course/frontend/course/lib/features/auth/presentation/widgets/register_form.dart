import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/core/validators/app_validator.dart';
import 'package:course/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onPasswordVisibilityChanged,
    required this.onRegister,
    required this.onBackToLogin,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool isPasswordVisible;
  final bool isLoading;
  final VoidCallback onPasswordVisibilityChanged;
  final VoidCallback onRegister;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final l10n = context.l10n;

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.registerTitle,
            style: text.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            l10n.registerWelcome,
            style: text.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          _buildNameField(theme, l10n),

          const SizedBox(height: 16),

          _buildEmailField(theme, l10n),

          const SizedBox(height: 16),

          _buildPasswordField(theme, l10n),

          const SizedBox(height: 32),

          AppButton(
            label: l10n.registerButton,
            isLoading: isLoading,
            onPressed: onRegister,
          ),

          const SizedBox(height: 32),

          _buildLoginNavigation(context, l10n),
        ],
      ),
    );
  }

  Widget _buildNameField(
    ThemeData theme,
    dynamic l10n,
  ) {
    return TextFormField(
      controller: nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        theme,
        labelText: l10n.fullNameLabel,
        icon: Icons.person_outline_rounded,
      ),
      validator: (value) {
        return AppValidator.fullName(
          value,
          emptyMessage: l10n.emptyFullNameError,
          invalidMessage: l10n.invalidFullNameError,
        );
      },
    );
  }

  Widget _buildEmailField(
    ThemeData theme,
    dynamic l10n,
  ) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        theme,
        labelText: l10n.emailLabel,
        icon: Icons.email_outlined,
      ),
      validator: (value) => AppValidator.email(
        value,
        emptyMessage: l10n.emptyEmailError,
        invalidMessage: l10n.invalidEmailError,
      ),
    );
  }

  Widget _buildPasswordField(
    ThemeData theme,
    dynamic l10n,
  ) {
    return TextFormField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      textInputAction: TextInputAction.done,
      decoration: _inputDecoration(
        theme,
        labelText: l10n.passwordLabel,
        icon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: onPasswordVisibilityChanged,
        ),
      ),
      validator: (value) => AppValidator.password(
        value,
        emptyMessage: l10n.emptyPasswordError,
        invalidMessage: l10n.invalidPasswordError,
      ),
      onFieldSubmitted: (_) => onRegister(),
    );
  }

  Widget _buildLoginNavigation(
    BuildContext context,
    dynamic l10n,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.haveAccountPrompt),
        TextButton(
          onPressed: () {
            onBackToLogin();
          },
          child: Text(
            l10n.loginButton,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
    ThemeData theme, {
    required String labelText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.3,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
    );
  }
}