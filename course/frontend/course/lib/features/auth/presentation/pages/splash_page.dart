import 'package:course/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primary,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async{

          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) return;
          
          if (state is AuthAuthenticated) {
            // TODO: Navigate to HomePage.
          } else if (state is AuthUnauthenticated) {
            // TODO: Navigate to LoginPage.
          }
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.language_rounded,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}