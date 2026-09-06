import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/widgets/state_widgets.dart';
import '../../data/models/appointment_model.dart';
import '../auth/auth_cubit.dart';
import '../auth/auth_state.dart';
import 'appointments_cubit.dart';
import 'appointments_state.dart';

/// Shows the signed-in user's appointments split into Upcoming, Completed,
/// and Cancelled tabs. [embedded] controls whether an AppBar is shown —
/// false when pushed as its own route, true when hosted inside HomeScreen's
/// bottom navigation.
class MyAppointmentsScreen extends StatelessWidget {
  final bool embedded;

  const MyAppointmentsScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().state.user?.uid;
    return BlocProvider(
      create: (_) => AppointmentsCubit()
        ..loadAppointments(userId ?? ''),
      child: _MyAppointmentsView(embedded: embedded),
    );
  }
}

class _MyAppointmentsView extends StatelessWidget {
  final bool embedded;

  const _MyAppointmentsView({required this.embedded});

  @override
  Widget build(BuildContext context) {
    final content = DefaultTabController(
      length: 3,
      child: Column(
        children: [
          if (!embedded)
            AppBar(title: const Text('My Appointments')),
          Material(
            color: AppColors.background,
            child: const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<AppointmentsCubit, AppointmentsState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == AppointmentsStatus.loading ||
                    state.status == AppointmentsStatus.initial) {
                  return const LoadingWidget();
                }
                if (state.status == AppointmentsStatus.failure &&
                    state.appointments.isEmpty) {
                  final userId = context.read<AuthCubit>().state.user?.uid;
                  return ErrorStateWidget(
                    message: state.errorMessage ?? 'Something went wrong',
                    onRetry: () => context
                        .read<AppointmentsCubit>()
                        .loadAppointments(userId ?? ''),
                  );
                }
                return TabBarView(
                  children: [
                    _AppointmentsList(
                      appointments: state.upcoming,
                      emptyMessage: 'No upcoming appointments yet.',
                      showCancel: true,
                      cancellingId: state.cancellingId,
                    ),
                    _AppointmentsList(
                      appointments: state.completed,
                      emptyMessage: 'No completed appointments yet.',
                      showCancel: false,
                      cancellingId: state.cancellingId,
                    ),
                    _AppointmentsList(
                      appointments: state.cancelled,
                      emptyMessage: 'No cancelled appointments.',
                      showCancel: false,
                      cancellingId: state.cancellingId,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );

    if (embedded) return SafeArea(child: content);
    return Scaffold(body: SafeArea(child: content));
  }
}

class _AppointmentsList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final String emptyMessage;
  final bool showCancel;
  final String? cancellingId;

  const _AppointmentsList({
    required this.appointments,
    required this.emptyMessage,
    required this.showCancel,
    required this.cancellingId,
  });

  Future<void> _confirmCancel(BuildContext context, AppointmentModel appt) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
            'Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes, Cancel',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final userId = context.read<AuthCubit>().state.user?.uid ?? '';
      await context
          .read<AppointmentsCubit>()
          .cancelAppointment(appt.appointmentId, userId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment cancelled successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return EmptyStateWidget(
        message: emptyMessage,
        icon: Icons.event_busy_outlined,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final appt = appointments[index];
        final isCancelling = cancellingId == appt.appointmentId;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(appt.doctorName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    _StatusBadge(status: appt.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(appt.specialization,
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(DateTimeUtils.toDisplayFromStorage(appt.date)),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(appt.time),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.confirmation_number_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(appt.appointmentId),
                    const Spacer(),
                    Text('₹${appt.fee.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary)),
                  ],
                ),
                if (showCancel) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isCancelling
                          ? null
                          : () => _confirmCancel(context, appt),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        minimumSize: const Size(0, 42),
                      ),
                      child: isCancelling
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Cancel Appointment'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'completed':
        color = AppColors.success;
        break;
      case 'cancelled':
        color = AppColors.error;
        break;
      default:
        color = AppColors.secondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
