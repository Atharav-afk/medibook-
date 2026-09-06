/// Represents a user document stored at users/{userId} in Firestore.
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String mobile;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }

  UserModel copyWith({String? name, String? email, String? mobile}) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
    );
  }
}
