import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_time_utils.dart';
import 'booking_cubit.dart';
import 'booking_state.dart';

/// Step 2: choose from the doctor's available time slots.
/// Already-booked slots (doctorId + date + time) are shown disabled.
class SelectTimeScreen extends StatelessWidget {
  final BookingCubit bookingCubit;

  const SelectTimeScreen({super.key, required this.bookingCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bookingCubit,
      child: const _SelectTimeView(),
    );
  }
}

class _SelectTimeView extends StatelessWidget {
  const _SelectTimeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Time')),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStatus.enteringDetails) {
            Navigator.of(context).pushNamed(
              AppRoutes.bookingDetails,
              arguments: context.read<BookingCubit>(),
            );
          }
        },
        builder: (context, state) {
          final slots = state.doctor.timeSlots.isNotEmpty
              ? state.doctor.timeSlots
              : AppConstants.defaultTimeSlots;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateTimeUtils.toDisplayFormat(state.selectedDate!),
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text('with ${state.doctor.name}',
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                const Text('Available time slots',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: slots.map((slot) {
                    final isBooked = state.bookedSlots.contains(slot);
                    final isSelected = state.selectedTime == slot;
                    return _TimeSlotChip(
                      label: slot,
                      isBooked: isBooked,
                      isSelected: isSelected,
                      onTap: isBooked
                          ? null
                          : () => context.read<BookingCubit>().selectTime(slot),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _legendDot(AppColors.divider, 'Booked'),
                    const SizedBox(width: 16),
                    _legendDot(AppColors.primary, 'Selected'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  final String label;
  final bool isBooked;
  final bool isSelected;
  final VoidCallback? onTap;

  const _TimeSlotChip({
    required this.label,
    required this.isBooked,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color textColor = AppColors.textPrimary;
    Color border = AppColors.divider;

    if (isBooked) {
      bg = AppColors.divider.withOpacity(0.4);
      textColor = AppColors.textSecondary;
    } else if (isSelected) {
      bg = AppColors.primary;
      textColor = Colors.white;
      border = AppColors.primary;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            decoration: isBooked ? TextDecoration.lineThrough : null,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
