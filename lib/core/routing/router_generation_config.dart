import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/di/dependency_injection.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/features/add_order_screen/add_order_screen.dart';
import 'package:order_tracking/features/add_order_screen/place_picker_screen.dart';
import 'package:order_tracking/features/auth/cubit/auth_cubit.dart';
import 'package:order_tracking/features/auth/login_screen.dart';
import 'package:order_tracking/features/auth/models/user_model.dart';
import 'package:order_tracking/features/auth/register_screen.dart';
import 'package:order_tracking/features/home_screen/home_screen_page.dart';
import 'package:order_tracking/features/splash_screen/splash_screen.dart';

class RouterGenerationConfig {
  const RouterGenerationConfig._();
  static final GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.registerScreen,
        path: AppRoutes.registerScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        builder: (context, state) {
          final String? email = state.extra as String?;
          return BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: LoginScreen(email: email),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.homeScreen,
        path: AppRoutes.homeScreen,
        builder: (context, state) {
          UserModel userModel = state.extra as UserModel;
          return BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: HomeScreen(userModel: userModel),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.addOrderScreen,
        path: AppRoutes.addOrderScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const AddOrderScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.placePickerScreen,
        path: AppRoutes.placePickerScreen,
        builder: (context, state) => const PlacePickerScreen(),
      ),
    ],
  );
}
