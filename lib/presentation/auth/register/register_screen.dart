import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'register_cubit.dart';
import 'register_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterCubit>().register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            mobile: _mobileController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Registration failed'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          if (state.status == RegisterStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
            // The app-wide AuthCubit will detect the new session and the
            // root widget will route to Home automatically.
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Let\'s get you started',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Fill in your details to create an account',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    prefixIcon: Icons.person_outline,
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: Validators.mobile,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    validator: (value) => Validators.confirmPassword(
                        value, _passwordController.text),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      return CustomButton(
                        label: 'Register',
                        isLoading: state.status == RegisterStatus.loading,
                        onPressed: _submit,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Already have an account? Log in'),
                    ),
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
