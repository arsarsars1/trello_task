import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 4)
class Contact extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String email;

  Contact({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      email: json['email'],
    );
  }
}
