import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../auth/auth_cubit.dart';
import '../auth/auth_state.dart';
import 'profile_cubit.dart';
import 'profile_state.dart';

/// Lets the user update their name and mobile number.
/// Email is intentionally read-only since it's tied to the Firebase Auth
/// account and changing it is out of scope for this project.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _mobileController = TextEditingController(text: user?.mobile ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = context.read<AuthCubit>().state.user!;
      context.read<ProfileCubit>().updateProfile(
            currentUser: user,
            name: _nameController.text.trim(),
            mobile: _mobileController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if (state.status == ProfileUpdateStatus.success) {
            await context.read<AuthCubit>().refreshProfile();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.of(context).pop();
            }
          } else if (state.status == ProfileUpdateStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Update failed'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      validator: Validators.name,
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
                      controller: TextEditingController(text: user?.email ?? ''),
                      label: 'Email',
                      prefixIcon: Icons.email_outlined,
                      enabled: false,
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      label: 'Save Changes',
                      isLoading: state.status == ProfileUpdateStatus.loading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
