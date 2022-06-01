class UserModel {
  UserModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  factory UserModel.fromJson({Map<String, dynamic>? json}) {
    return UserModel(
      id: json?['id'] as int,
      name: json?['name'] as String,
      username: json?['username'] as String,
      email: json?['email'] as String,
      address: json?['address'] as Map<String, String>,
      phone: json?['phone'] as String,
      website: json?['website'] as String,
      company: json?['company'] as Map<String, String>,
    );
  }

  int? id;
  String? name;
  String? username;
  String? email;
  Map<String, String>? address;
  String? phone;
  String? website;
  Map<String, String>? company;
}
