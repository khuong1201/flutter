import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/core/widgets/language_picker.dart';
import 'package:course/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:course/features/auth/presentation/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String _selectedLanguage = 'ja';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          LanguagePicker(),
          SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: _handleAuthState,
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: RegisterForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isPasswordVisible: _isPasswordVisible,
                  selectedLanguage: _selectedLanguage,
                  isLoading: state is AuthLoading,
                  onPasswordVisibilityChanged: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  onLanguageChanged: (language) {
                    setState(() {
                      _selectedLanguage = language;
                    });
                  },
                  onRegister: _register,
                  onBackToLogin: () => Navigator.pop(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAuthState(
    BuildContext context,
    AuthState state,
  ) {
    if (state is AuthRegisterSuccess) {
      _showSuccessMessage(context);
      Navigator.pop(context);
      return;
    }

    if (state is AuthError) {
      _showErrorMessage(context, state.message);
    }
  }

  void _showSuccessMessage(BuildContext context) {
    final l10n = context.l10n;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.registerSuccess),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showErrorMessage(
    BuildContext context,
    String message,
  ) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.isNotEmpty
              ? message
              : l10n.registerFailed,
        ),
        backgroundColor: theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _register() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.read<AuthCubit>().register(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
          _selectedLanguage,
        );
  }
}