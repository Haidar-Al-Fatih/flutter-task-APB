class User {
  final String name;
  final String email;
  final String npm;

  User({required this.name, required this.email, required this.npm});
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    name: json['name'],
    email: json['email'],
    npm: json['npm'] ?? '', // Mapping data NPM dari JSON
  );
}
}
