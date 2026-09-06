/// Represents a doctor category, e.g. "Cardiologist", "Dentist".
class CategoryModel {
  final String id;
  final String name;
  final String iconName; // e.g. 'favorite', used to map to a Material icon

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      iconName: map['iconName'] ?? 'medical_services',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconName': iconName,
    };
  }
}
