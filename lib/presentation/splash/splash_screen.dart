import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_cubit.dart';
import '../auth/auth_state.dart';

/// Shows the app logo/name briefly, then routes to Home or Login based
/// on the current Firebase authentication state.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home, (route) => false);
        } else if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.login, (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.local_hospital,
                    color: AppColors.primary, size: 52),
              ),
              const SizedBox(height: 20),
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your health, one tap away',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 36),
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
