import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:course/core/widgets/shared_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;

  bool _authChecked = false;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();

    // Khởi chạy ngầm preload cache từ màn hình Splash
    SharedLoadingWidget.preloadCaches();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addListener(_onProgressChanged);

    _progressController.animateTo(
      0.95,
      curve: Curves.easeInOut,
    );
  }

  void _onProgressChanged() {
    if (!mounted) return;

    if (_progressController.value >= 0.95 && !_authChecked) {
      _checkAuth();
    }

    setState(() {});
  }

  void _checkAuth() {
    if (_authChecked) return;

    _authChecked = true;

    context.read<AuthCubit>().checkAuthStatus();
  }

  void _completeSplash() {
    if (!mounted || _isCompleting) return;

    _isCompleting = true;

    _progressController
        .animateTo(
          1.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        )
        .then((_) {
      if (!mounted) return;

      setState(() {});
    });
  }

  @override
  void dispose() {
    _progressController
      ..removeListener(_onProgressChanged)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated ||
            state is AuthUnauthenticated) {
          _completeSplash();
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                _buildLogo(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  tagline: l10n.splashTagline,
                ),

                const Spacer(flex: 4),

                _buildProgress(
                  textTheme: textTheme,
                  loadingText: l10n.splashLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required String tagline,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.0,
        end: 1.0,
      ),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Icon(
              Icons.language_rounded,
              size: 80,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Zenith Lingua',
            style: textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              tagline,
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress({
    required TextTheme textTheme,
    required String loadingText,
  }) {
    final progress = _progressController.value;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 50,
      ),
      child: Column(
        children: [
          Text(
            loadingText,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.6),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${(progress * 100).toInt()}%',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}