import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/data/auth/models/user_creation.dart';
import 'package:social_media_app/features/data/auth/models/user_signin.dart';
import 'package:social_media_app/features/domain/auth/entites/app_user.dart';

abstract class FirebaseServices {
  Future<Either> signin(UserSignin userSignin);
  Future<Either> signup(UserCreation userCreation);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}


class FirebaseServicesImpl extends FirebaseServices{
  String message = "";

  @override
  Future<AppUser?> getCurrentUser() async{
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if(firebaseUser == null){
      return null;
    }
    return AppUser(
      uid: firebaseUser.uid,
       email: firebaseUser.email!,
        name: "");
  }

  @override
  Future<void> logout() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<Either> signin(UserSignin userSignin) async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userSignin.email!, password: userSignin.password!);
      return right("Sign in Successfly");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      return left(message);
    }
  }

  @override
  Future<Either> signup(UserCreation userCreation) async{
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userCreation.email!,
        password: userCreation.password!,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(data.user!.uid)
          .set({
        "name": userCreation.name,
        "email": userCreation.email,
      });

      return right("success sign in");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      return left(message);
    }
  }



}