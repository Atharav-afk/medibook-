import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_cubit.dart';
import '../auth/auth_state.dart';
import 'edit_profile_screen.dart';

/// Displays the signed-in user's info with links to Edit Profile,
/// My Appointments, and Logout. [embedded] hides the AppBar when hosted
/// inside HomeScreen's bottom navigation.
class ProfileScreen extends StatelessWidget {
  final bool embedded;

  const ProfileScreen({super.key, this.embedded = false});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().logout();
      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.user;
        if (user == null) return const SizedBox.shrink();

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (!embedded) ...[
                const SizedBox(height: 4),
                const Text('Profile',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
              ],
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.primaryLight,
                      child: const Icon(Icons.person,
                          size: 48, color: AppColors.primary),
                    ),
                    const SizedBox(height: 12),
                    Text(user.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(user.email,
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Card(
                child: Column(
                  children: [
                    _tile(
                      icon: Icons.phone_outlined,
                      title: 'Mobile',
                      subtitle: user.mobile,
                    ),
                    const Divider(height: 1),
                    _actionTile(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profile',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const EditProfileScreen()),
                      ),
                    ),
                    const Divider(height: 1),
                    _actionTile(
                      icon: Icons.calendar_today_outlined,
                      title: 'My Appointments',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.myAppointments),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: _actionTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () => _confirmLogout(context),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (embedded) return body;
    return Scaffold(appBar: AppBar(title: const Text('Profile')), body: body);
  }

  Widget _tile({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(color: AppColors.textSecondary)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
