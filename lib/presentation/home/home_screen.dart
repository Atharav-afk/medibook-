import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/doctor_card.dart';
import '../../core/widgets/state_widgets.dart';
import '../../data/models/doctor_model.dart';
import '../appointments/my_appointments_screen.dart';
import '../auth/auth_cubit.dart';
import '../auth/auth_state.dart';
import '../profile/profile_screen.dart';
import 'home_cubit.dart';
import 'home_state.dart';

/// Root screen after login. Hosts three tabs: Home, Appointments, Profile,
/// so the user can reach every part of the app without deep navigation.
class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex = widget.initialIndex;

  final _screens = const [
    _HomeTab(),
    MyAppointmentsScreen(embedded: true),
    ProfileScreen(embedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: 'Appointments'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..loadHome(),
      child: const _HomeTabBody(),
    );
  }
}

class _HomeTabBody extends StatelessWidget {
  const _HomeTabBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => context.read<HomeCubit>().loadHome(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildSearchBar(context)),
            SliverToBoxAdapter(child: _buildCategoriesSection(context)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              sliver: SliverToBoxAdapter(
                child: Text('Recommended Doctors',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            _buildDoctorsList(context),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final name = state.user?.name.split(' ').first ?? 'there';
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome back 👋',
                        style: TextStyle(color: AppColors.textSecondary)),
                    Text(name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryLight,
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.search),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: AppColors.textSecondary),
              SizedBox(width: 10),
              Text('Search doctors or specialization',
                  style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.categories.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 92,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.search,
                  arguments: category.name,
                ),
                child: SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.medical_services_outlined,
                            color: AppColors.primary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDoctorsList(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading ||
            state.status == HomeStatus.initial) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: LoadingWidget(),
            ),
          );
        }
        if (state.status == HomeStatus.failure) {
          return SliverToBoxAdapter(
            child: ErrorStateWidget(
              message: state.errorMessage ?? 'Something went wrong',
              onRetry: () => context.read<HomeCubit>().loadHome(),
            ),
          );
        }
        if (state.doctors.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyStateWidget(
              message: 'No doctors available right now.',
              icon: Icons.medical_services_outlined,
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.separated(
            itemCount: state.doctors.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final DoctorModel doctor = state.doctors[index];
              return DoctorCard(
                doctor: doctor,
                onTap: () => Navigator.of(context)
                    .pushNamed(AppRoutes.doctorDetails, arguments: doctor),
              );
            },
          ),
        );
      },
    );
  }
}
