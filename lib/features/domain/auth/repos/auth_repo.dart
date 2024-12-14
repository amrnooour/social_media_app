import 'package:dartz/dartz.dart';
import 'package:social_media_app/features/data/auth/models/user_creation.dart';
import 'package:social_media_app/features/data/auth/models/user_signin.dart';

abstract class AuthRepo {
  Future<Either> signin(UserSignin userSignin);
  Future<Either> signup(UserCreation userCreation);
  Future<void> logout();
  Future<Either> getCurrentUser();
}