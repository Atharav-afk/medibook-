import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/doctor_card.dart';
import '../../core/widgets/state_widgets.dart';
import 'search_cubit.dart';
import 'search_state.dart';

/// Dedicated search screen: search by name/specialization plus simple
/// category chips. Results update dynamically as the user types.
class SearchScreen extends StatelessWidget {
  final String? initialCategory;

  const SearchScreen({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit()..init(initialCategory: initialCategory),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Doctor')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _controller,
              onChanged: (value) => context.read<SearchCubit>().search(value),
              decoration: InputDecoration(
                hintText: 'Search by name or specialization',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchCubit>().search('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state.categories.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    final selected = state.selectedCategory == category.name;
                    return ChoiceChip(
                      label: Text(category.name),
                      selected: selected,
                      onSelected: (_) => context
                          .read<SearchCubit>()
                          .selectCategory(category.name),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                          color: selected ? Colors.white : AppColors.primary),
                      backgroundColor: AppColors.primaryLight,
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state.status == SearchStatus.loading) {
                  return const LoadingWidget();
                }
                if (state.status == SearchStatus.failure) {
                  return ErrorStateWidget(
                    message: state.errorMessage ?? 'Something went wrong',
                    onRetry: () => context.read<SearchCubit>().init(),
                  );
                }
                if (state.results.isEmpty) {
                  return const EmptyStateWidget(
                    message: 'No doctors match your search.',
                    icon: Icons.search_off,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: state.results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doctor = state.results[index];
                    return DoctorCard(
                      doctor: doctor,
                      onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.doctorDetails,
                          arguments: doctor),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
