import '../models/category_model.dart';
import '../models/doctor_model.dart';
import '../services/firestore_service.dart';

/// Handles all reads related to doctors and categories.
class DoctorRepository {
  final FirestoreService _firestoreService;

  DoctorRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  Future<List<DoctorModel>> getAllDoctors() async {
    final snapshot = await _firestoreService.doctors.get();
    return snapshot.docs
        .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _firestoreService.categories.get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<DoctorModel> getDoctorById(String doctorId) async {
    final doc = await _firestoreService.doctors.doc(doctorId).get();
    if (!doc.exists) throw 'Doctor not found.';
    return DoctorModel.fromMap(doc.data()!, doc.id);
  }

  /// Client-side filtering keeps this simple for a college project —
  /// no need for a search index with a small doctors collection.
  List<DoctorModel> filterDoctors({
    required List<DoctorModel> doctors,
    String query = '',
    String? category,
  }) {
    return doctors.where((doctor) {
      final matchesQuery = query.isEmpty ||
          doctor.name.toLowerCase().contains(query.toLowerCase()) ||
          doctor.specialization.toLowerCase().contains(query.toLowerCase());

      final matchesCategory = category == null ||
          category.isEmpty ||
          doctor.specialization.toLowerCase() == category.toLowerCase();

      return matchesQuery && matchesCategory;
    }).toList();
  }
}
