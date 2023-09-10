import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kpopchat/business_logic/virtual_friends_cubit/virtual_friends_list_cubit.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/main.dart';

class AuthCheckerCubit extends Cubit<AuthStates> {
  AuthCheckerCubit() : super(AuthStates.loadingState);
  GoogleSignIn googleSignIn = locator<GoogleSignIn>();
  FirebaseAuth firebaseAuth = locator<FirebaseAuth>();

  /// Emits loggedOutState if firebase currentUser is null,
  /// otherwise emits loggedInState
  void checkUserAuth() async {
    await Future.delayed(Duration.zero);
    final User? loggedInUser = firebaseAuth.currentUser;

    emit(loggedInUser != null
        ? AuthStates.loggedInState
        : AuthStates.loggedOutState);
  }

  /// Sign out from google and navigate to sign in screen
  void signOutUser() async {
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    emit(AuthStates.loggedOutState);
    Navigator.of(navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil(AppRoutes.signInScreen, (route) => false);
    BlocProvider.of<VirtualFriendsListCubit>(navigatorKey.currentContext!)
        .resetVirtualFriendsListState();
  }
}

enum AuthStates { loadingState, loggedInState, loggedOutState }
