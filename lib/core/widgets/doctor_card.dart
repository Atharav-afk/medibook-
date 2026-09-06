import 'package:flutter/material.dart';
import '../../data/models/doctor_model.dart';
import '../theme/app_colors.dart';

/// Reusable card used on Home and Search screens to display a doctor summary.
class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const DoctorCard({super.key, required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: doctor.imageUrl.isNotEmpty
                    ? Image.network(
                        doctor.imageUrl,
                        width: 84,
                        height: 84,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholderAvatar(),
                      )
                    : _placeholderAvatar(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialization,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: AppColors.rating),
                        const SizedBox(width: 4),
                        Text(doctor.rating.toStringAsFixed(1)),
                        const SizedBox(width: 12),
                        const Icon(Icons.work_outline,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('${doctor.experience} yrs'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doctor.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${doctor.fee.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    onPressed: onTap,
                    child: const Text('View'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderAvatar() {
    return Container(
      width: 84,
      height: 84,
      color: AppColors.primaryLight,
      child: const Icon(Icons.person, color: AppColors.primary, size: 40),
    );
  }
}
