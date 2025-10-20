class Profile {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String city;
  final String country;
  final String imageUrl;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.city,
    required this.country,
    required this.imageUrl,
  });

  String get fullName => '$firstName $lastName';

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['login']?['uuid'] ?? '',
      firstName: json['name']?['first'] ?? '',
      lastName: json['name']?['last'] ?? '',
      age: (json['dob']?['age'] ?? 0) as int,
      city: json['location']?['city'] ?? '',
      country: json['location']?['country'] ?? '',
      imageUrl: json['picture']?['large'] ?? '',
    );
  }
}
