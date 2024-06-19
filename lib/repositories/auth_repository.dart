import 'package:hive/hive.dart';

class AuthRepository {
  final Box box;

  AuthRepository(this.box);

  Future<void> login(String email, String password) async {
    box.put('user', {'email': email});
  }

  Future<void> logout() async => box.delete('user');

  bool isLoggedIn() => box.containsKey('user');
}
