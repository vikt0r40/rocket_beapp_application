import 'package:be_app_mobile/models/be_user.dart';
import 'package:be_app_mobile/models/localization.dart';
import 'package:be_app_mobile/service/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FacebookLogin();
  final gg = GoogleSignIn();
  Localization localize = Localization();

  AuthService();

  //Create user based on Firebase User
  BeUser? _userFromFirebaseUser(User? user) {
    return user != null ? BeUser(uid: user.uid, email: user.email ?? "", displayName: user.displayName ?? "") : null;
  }

  //auth change user stream
  Stream<BeUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
  }

  Future signOut() async {
    try {
      await fb.logOut();
      await gg.signOut();
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future signInWithEmail(String email, String pass) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      return null;
    }
  }

  Future forgotPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      var snackBar = SnackBar(content: Text(localize.authResetEmail));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      var snackBar = SnackBar(content: Text(localize.authEmailNotFound));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future registerWithEmail(String email, String pass, String displayName) async {
    debugPrint("registering");
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      User? firebaseUser = result.user;
      print(result.user?.email);
      firebaseUser?.updateDisplayName(displayName);
      await APIService().registerUser(firebaseUser!, "Email", displayName);
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential> signInWithCredentials(AuthCredential credential) => _auth.signInWithCredential(credential);

  Future signInFacebook(BuildContext context) async {
    try {
      final res = await fb.logIn(permissions: [FacebookPermission.publicProfile, FacebookPermission.email]);
      switch (res.status) {
        case FacebookLoginStatus.success:
          //Get Token
          final FacebookAccessToken? fbToken = res.accessToken;

          //Convert to Auth Credential
          final AuthCredential credential = FacebookAuthProvider.credential(fbToken?.token ?? "");

          //User Credential to sign in with Firebase
          final result = await _auth.signInWithCredential(credential);

          //Update photo and display name of Firebase User
          User? firebaseUser = result.user;

          final profile = await fb.getUserProfile();
          final imageUrl = await fb.getProfileImageUrl(width: 100);

          firebaseUser?.updateDisplayName(profile?.name);
          firebaseUser?.updatePhotoURL(imageUrl);

          //Return the new user of type ViUser
          await APIService().registerUser(firebaseUser!, "Facebook", "");
          return _userFromFirebaseUser(firebaseUser);

        case FacebookLoginStatus.cancel:
          return null;

        case FacebookLoginStatus.error:
          return null;
      }
    } catch (e) {
      var snackBar = SnackBar(content: Text(localize.authAccountExist));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }

  Future signInGoogle(BuildContext context) async {
    try {
      final user = await gg.signIn();
      if (user == null) {
        return null;
      } else {
        final googleAuth = await user.authentication;

        final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final result = await _auth.signInWithCredential(credential);

        //Update photo and display name of Firebase User
        User? firebaseUser = result.user;

        firebaseUser?.updateDisplayName(user.displayName);
        //Return the new user of type ViUser
        await APIService().registerUser(firebaseUser!, "Google", "");

        return _userFromFirebaseUser(firebaseUser);
      }
    } catch (e) {
      var snackBar = SnackBar(content: Text(localize.authAccountExist));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }
}
