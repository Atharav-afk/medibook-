import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/models/doctor_model.dart';

/// Displays full details for a single doctor plus a "Book Appointment"
/// action that kicks off the booking flow.
class DoctorDetailsScreen extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: doctor.imageUrl.isNotEmpty
                        ? Image.network(
                            doctor.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(doctor.specialization,
                            style:
                                const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 18, color: AppColors.rating),
                            const SizedBox(width: 4),
                            Text(doctor.rating.toStringAsFixed(1)),
                            const SizedBox(width: 16),
                            const Icon(Icons.work_outline,
                                size: 18, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text('${doctor.experience} yrs'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _infoRow(Icons.location_on_outlined, doctor.location),
              const SizedBox(height: 10),
              _infoRow(Icons.currency_rupee,
                  'Consultation fee: ₹${doctor.fee.toStringAsFixed(0)}'),
              const SizedBox(height: 20),
              const Text('About',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                doctor.description.isNotEmpty
                    ? doctor.description
                    : 'No description provided.',
                style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),
              const Text('Available Days',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: doctor.availableDays
                    .map((day) => Chip(label: Text(day)))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text('Time Slots',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: doctor.timeSlots
                    .map((slot) => Chip(
                          label: Text(slot),
                          backgroundColor: AppColors.primaryLight,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Book Appointment',
                onPressed: () => Navigator.of(context)
                    .pushNamed(AppRoutes.selectDate, arguments: doctor),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      width: 100,
      height: 100,
      color: AppColors.primaryLight,
      child: const Icon(Icons.person, color: AppColors.primary, size: 48),
    );
  }
}
