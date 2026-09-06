import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'forgot_password_cubit.dart';
import 'forgot_password_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ForgotPasswordStatus.success) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mark_email_read_outlined,
                      size: 64, color: AppColors.success),
                  const SizedBox(height: 16),
                  const Text(
                    'Reset link sent!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check ${_emailController.text} for a password reset link.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: 'Back to Login',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Forgot your password?',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter your email and we\'ll send you a reset link.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: 'Send Reset Link',
                    isLoading: state.status == ForgotPasswordStatus.loading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<ForgotPasswordCubit>()
                            .sendResetEmail(_emailController.text.trim());
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
