import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/utils/locale_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(
          value: sl<AuthCubit>(),
        ),
        BlocProvider<LocaleCubit>.value(
          value: sl<LocaleCubit>(),
        ),
      ],
      child: const ZenithLinguaApp(),
    ),
  );
}