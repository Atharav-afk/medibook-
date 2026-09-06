import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/widgets/custom_button.dart';
import '../auth/auth_cubit.dart';
import 'booking_cubit.dart';
import 'booking_state.dart';

/// Steps 4-5: show the booking summary, let the user confirm, and then
/// display the success screen with a generated booking ID.
class BookingConfirmationScreen extends StatelessWidget {
  final BookingCubit bookingCubit;

  const BookingConfirmationScreen({super.key, required this.bookingCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bookingCubit,
      child: const _BookingConfirmationView(),
    );
  }
}

class _BookingConfirmationView extends StatelessWidget {
  const _BookingConfirmationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Booking failed'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == BookingStatus.success) {
            return _SuccessView(state: state);
          }
          return _SummaryView(state: state);
        },
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  final BookingState state;

  const _SummaryView({required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please review your appointment',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _row('Doctor', state.doctor.name),
                    _row('Specialization', state.doctor.specialization),
                    _row('Date', DateTimeUtils.toDisplayFormat(state.selectedDate!)),
                    _row('Time', state.selectedTime ?? ''),
                    _row('Patient', state.patientName),
                    _row('Reason', state.reason),
                    const Divider(height: 24),
                    _row(
                      'Consultation Fee',
                      '₹${state.doctor.fee.toStringAsFixed(0)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            CustomButton(
              label: 'Confirm Appointment',
              isLoading: state.status == BookingStatus.submitting,
              onPressed: () {
                final userId = context.read<AuthCubit>().state.user?.uid;
                if (userId != null) {
                  context.read<BookingCubit>().confirmBooking(userId);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: isBold ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final BookingState state;

  const _SuccessView({required this.state});

  @override
  Widget build(BuildContext context) {
    final appointment = state.confirmedAppointment!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, color: AppColors.success, size: 80),
            const SizedBox(height: 16),
            const Text('Appointment Confirmed!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text(
              'Your appointment has been booked successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _row('Booking ID', appointment.appointmentId, isBold: true),
                    _row('Doctor', appointment.doctorName),
                    _row('Patient', appointment.patientName),
                    _row('Date', DateTimeUtils.toDisplayFromStorage(appointment.date)),
                    _row('Time', appointment.time),
                    _row('Fee', '₹${appointment.fee.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            CustomButton(
              label: 'View Appointment',
              outlined: true,
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Go Home',
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: isBold ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
