/// Represents a doctor document stored in the doctors collection.
class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final int experience;
  final double rating;
  final String location;
  final double fee;
  final String description;
  final String imageUrl;
  final List<String> availableDays;
  final List<String> timeSlots;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.location,
    required this.fee,
    required this.description,
    required this.imageUrl,
    required this.availableDays,
    required this.timeSlots,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map, String id) {
    return DoctorModel(
      id: id,
      name: map['name'] ?? '',
      specialization: map['specialization'] ?? '',
      experience: (map['experience'] ?? 0) is int
          ? map['experience'] ?? 0
          : (map['experience'] as num).toInt(),
      rating: (map['rating'] ?? 0).toDouble(),
      location: map['location'] ?? '',
      fee: (map['fee'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      availableDays: List<String>.from(map['availableDays'] ?? []),
      timeSlots: List<String>.from(map['timeSlots'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialization': specialization,
      'experience': experience,
      'rating': rating,
      'location': location,
      'fee': fee,
      'description': description,
      'imageUrl': imageUrl,
      'availableDays': availableDays,
      'timeSlots': timeSlots,
    };
  }
}
