import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_tracking/features/auth/models/user_model.dart';
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';

class AuthRepo {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  AuthRepo({required this.firebaseAuth, required this.firebaseFirestore});
  Future<ResultDart<String, String>> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await setUserData(
        email: user.user!.email!,
        userId: user.user!.uid,
        username: username,
      );
      log('account created successfully in repo');
      return successOf('account created successfully');
    } on FirebaseAuthException catch (e) {
      return failureOf(e.message!);
    } catch (e) {
      return failureOf("error");
    }
  }

  Future<ResultDart<UserModel, String>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userModel = await getUserData(user.user!.uid);
      log(" account logged in successfully in repo");
      return successOf(userModel);
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());
      return Failure(e.code);
    } catch (_) {
      return Failure("error occurred");
    }
  }

  Future<void> setUserData({
    required String email,
    required String userId,
    required String username,
  }) async {
    await firebaseFirestore.collection("users").doc(userId).set({
      "userId": userId,
      "email": email,
      "username": username,
    });
  }

  Future<UserModel> getUserData(String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection("users")
        .where("userId", isEqualTo: userId)
        .get();
    UserModel userModel = UserModel.fromJson(querySnapshot.docs.first.data());
    return userModel;
  }

  void logout() {
    firebaseAuth.signOut();
  }
}
