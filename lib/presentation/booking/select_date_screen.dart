import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_time_utils.dart';
import '../../data/models/doctor_model.dart';
import 'booking_cubit.dart';
import 'booking_state.dart';

/// Step 1: pick an appointment date using Flutter's built-in date picker.
/// Past dates are disabled via [firstDate].
class SelectDateScreen extends StatelessWidget {
  final DoctorModel doctor;

  const SelectDateScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit(doctor: doctor),
      child: const _SelectDateView(),
    );
  }
}

class _SelectDateView extends StatelessWidget {
  const _SelectDateView();

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // prevents selecting a past date
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null && context.mounted) {
      context.read<BookingCubit>().selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Date')),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStatus.selectingTime) {
            Navigator.of(context).pushNamed(
              AppRoutes.selectTime,
              arguments: context.read<BookingCubit>(),
            );
          }
          if (state.errorMessage != null &&
              state.status != BookingStatus.selectingTime) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking with ${state.doctor.name}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(state.doctor.specialization,
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 32),
                const Text('Choose an appointment date',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _pickDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.divider),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text(
                          state.selectedDate != null
                              ? DateTimeUtils.toDisplayFormat(state.selectedDate!)
                              : 'Tap to choose a date',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (state.status == BookingStatus.loadingSlots)
                  const Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      ),
                      SizedBox(width: 12),
                      Text('Loading available time slots...'),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
