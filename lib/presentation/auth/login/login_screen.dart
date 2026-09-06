import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'login_cubit.dart';
import 'login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Login failed'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          // On success, the app-wide AuthCubit (listening to Firebase auth
          // state) will trigger navigation automatically via the root widget.
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.local_hospital,
                        color: AppColors.primary, size: 34),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome back',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Log in to continue booking with ${AppConstants.appName}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 28),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    validator: Validators.password,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(AppRoutes.forgotPassword),
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return CustomButton(
                        label: 'Log In',
                        isLoading: state.status == LoginStatus.loading,
                        onPressed: _submit,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed(AppRoutes.register),
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
