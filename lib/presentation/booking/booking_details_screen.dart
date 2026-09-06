import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../auth/auth_cubit.dart';
import '../auth/auth_state.dart';
import 'booking_cubit.dart';

/// Step 3: collect patient details, pre-filled from the user's profile
/// where possible, before showing the booking summary.
class BookingDetailsScreen extends StatelessWidget {
  final BookingCubit bookingCubit;

  const BookingDetailsScreen({super.key, required this.bookingCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bookingCubit,
      child: const _BookingDetailsView(),
    );
  }
}

class _BookingDetailsView extends StatefulWidget {
  const _BookingDetailsView();

  @override
  State<_BookingDetailsView> createState() => _BookingDetailsViewState();
}

class _BookingDetailsViewState extends State<_BookingDetailsView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  final _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _mobileController = TextEditingController(text: user?.mobile ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<BookingCubit>().setPatientDetails(
            name: _nameController.text.trim(),
            mobile: _mobileController.text.trim(),
            email: _emailController.text.trim(),
            reason: _reasonController.text.trim(),
          );
      Navigator.of(context).pushNamed(
        AppRoutes.bookingConfirmation,
        arguments: context.read<BookingCubit>(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tell us who this appointment is for',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _nameController,
                  label: 'Patient Name',
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
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _reasonController,
                  label: 'Reason for Appointment',
                  prefixIcon: Icons.notes_outlined,
                  maxLines: 3,
                  validator: (value) =>
                      Validators.required(value, field: 'Reason'),
                ),
                const SizedBox(height: 28),
                CustomButton(label: 'Review Booking', onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
