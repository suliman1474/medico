class UserModel {
  late String id, name, profile;

  UserModel({
    required this.id,
    String? name,
    String? profile,
  })  : name = name ?? '',
        profile = profile ?? '';

  UserModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'] ?? ''; // Provide default value for null name
    profile = map['profile'] ?? ''; // Provide default value for null profile
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile': profile,
    };
  }
}
