import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/core/validators/app_validator.dart';
import 'package:course/core/widgets/app_button.dart';
import 'package:course/features/auth/presentation/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onPasswordVisibilityChanged,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onRegister,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool isPasswordVisible;
  final bool isLoading;

  final VoidCallback onPasswordVisibilityChanged;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;
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
          const SizedBox(height: 24),

          Text(
            l10n.loginTitle,
            style: text.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            l10n.loginWelcome,
            style: text.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          _buildEmailField(theme, l10n),

          const SizedBox(height: 16),

          _buildPasswordField(theme, l10n),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onForgotPassword,
              child: Text(
                l10n.forgotPassword,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          AppButton(
            label: l10n.loginButton,
            isLoading: isLoading,
            onPressed: onLogin,
          ),

          const SizedBox(height: 32),

          _buildSocialDivider(theme, text, l10n),

          const SizedBox(height: 24),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialButton(
                icon: Icons.g_mobiledata_rounded,
              ),
              SizedBox(width: 16),
              SocialButton(
                icon: Icons.apple_rounded,
              ),
            ],
          ),

          const SizedBox(height: 32),

          _buildRegisterNavigation(context, l10n),
        ],
      ),
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
      onFieldSubmitted: (_) => onLogin(),
    );
  }

  Widget _buildSocialDivider(
    ThemeData theme,
    TextTheme text,
    dynamic l10n,
  ) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.orContinueWith,
            style: text.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterNavigation(
    BuildContext context,
    dynamic l10n,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.noAccountPrompt),
        TextButton(
          onPressed: () => context.push('/register'),
          child: Text(
            l10n.registerNow,
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