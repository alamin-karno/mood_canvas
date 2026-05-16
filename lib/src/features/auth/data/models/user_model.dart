import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  AppUser toEntity() {
    return AppUser(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
    );
  }
}
