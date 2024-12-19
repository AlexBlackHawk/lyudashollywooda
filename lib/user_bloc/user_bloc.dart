import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../configs/constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<UserPurchasesRestored>(_onPurchasesRestored);
    on<UserConfigurationsSet>(_onConfigurationsSet);
    on<UserPlatformStateInitialized>(_onPlatformStateInitialized);
    on<UserInformationFetched>(_onInformationFetched);
    on<UserLogoutPressed>(_onLogoutPressed);
    on<UserLogInWithGoogle>(_onLogInWithGoogle);
    on<UserLogInWithApple>(_onLogInWithApple);
    on<UserOnlineStatusChanged>(_onOnlineStatusChanged);
    on<UserSubscriptionPackagePurchased>(_onSubscriptionPackagePurchased);
    on<UserLogInWithFacebook>(_onLogInWithFacebook);
    on<UserDBDeleted>(_onDBDeleted);
    on<UserAuthDeleted>(_onAuthDeleted);
  }

  final authInstance = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> _onDBDeleted(UserDBDeleted event, Emitter<UserState> emit) async {
    final userRequests = await db.collection("Requests").where("user", isEqualTo: state.userCredential!.user!.uid).get();
    userRequests.docs.map((elem) async {
      await elem.reference.delete();
    });

    final userAnswers = await db.collectionGroup("Replies").where("user", isEqualTo: state.userCredential!.user!.uid).get();
    userAnswers.docs.map((elem) async {
      await elem.reference.delete();
    });

    final userComments = await db.collectionGroup("Comments").where("user", isEqualTo: state.userCredential!.user!.uid).get();
    userComments.docs.map((elem) async {
      await elem.reference.delete();
    });

    final userChats = await db.collection("Chat rooms").where("users", arrayContains: state.userCredential!.user!.uid).get();
    userChats.docs.map((elem) async {
      final userMessages = await elem.reference.collection("Messages").get();
      userMessages.docs.map((message) async {
        await message.reference.delete();
      });
      await elem.reference.delete();
    });

    await db.collection("Users").doc(state.userCredential!.user!.uid).delete();
  }

  Future<void> _onAuthDeleted(UserAuthDeleted event, Emitter<UserState> emit) async {
    await state.userCredential!.user?.delete();
  }

  void _onOnlineStatusChanged(UserOnlineStatusChanged event, Emitter<UserState> emit) async {
    await db.collection("Users").doc(state.userId).update(
        {
          "isOnline": event.isOnline,
          "last online": event.isOnline ? null : FieldValue.serverTimestamp(),
        }
    );
  }

  void _onSubscriptionPackagePurchased(UserSubscriptionPackagePurchased event, Emitter<UserState> emit) async {
    CustomerInfo customerInfo = await Purchases.purchasePackage(state.productList[event.subscriptionIndex]);
    EntitlementInfo? entitlement = customerInfo.entitlements.all[entitlementID];
    emit(
        state.copyWith(
          customerInfo: customerInfo,
          entitlementIsActive: entitlement?.isActive ?? false,
          showAds: entitlement?.isActive ?? false,
        )
    );
  }

  Future<void> _onLogInWithGoogle(UserLogInWithGoogle event, Emitter<UserState> emit) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email',"https://www.googleapis.com/auth/userinfo.profile"]);
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    Map<String, dynamic> userInfo = <String, dynamic>{};
    String userId = userCredential.user!.uid;

    bool localShowAds = state.showAds;

    DocumentSnapshot<Map<String, dynamic>> fetchedUsers = await db.collection('Users').doc(userId).get();

    if (!fetchedUsers.exists) {
      userInfo = <String, dynamic>{
        "email": userCredential.user!.email!,
        "name": userCredential.user!.displayName!,
        "phone number": userCredential.user!.phoneNumber == null ? "" : userCredential.user!.phoneNumber!,
        "avatar": userCredential.user!.photoURL!,
        "role": "user",
        "isOnline": true,
        "last online": null,
      };

      await db.collection("Users").doc(userId).set(userInfo);
    }
    else {
      await db.collection("Users").doc(userId).update(
        {
          "isOnline": true,
          "last online": null,
        }
      );
      DocumentSnapshot<Map<String, dynamic>> user = await db.collection('Users').doc(userId).get();
      userInfo = user.data() as Map<String, dynamic>;
    }

    String chatId = "";
    bool haveChat = false;
    if (userInfo["role"] == "user") {
      final chatSnapshot = await db.collection("Chat rooms").where("users", arrayContains: userId).get();
      haveChat = chatSnapshot.docs.isNotEmpty;
      if (haveChat) {
        chatId = chatSnapshot.docs[0].id;
      }
    }

    emit(
      state.copyWith(
        haveChat: haveChat,
        chatId: chatId,
        userInfo: userInfo,
        userId: userId,
        showAds: localShowAds,
        googleSignIn: googleSignIn,
        provider: "google",
        showDialog: true,
      )
    );
  }

  // ----------------------------------------------------
  Future<void> _onLogInWithFacebook(UserLogInWithFacebook event, Emitter<UserState> emit) async {
    // final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email',"https://www.googleapis.com/auth/userinfo.profile"]);
    // final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    //
    // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    //
    // final credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth?.accessToken,
    //   idToken: googleAuth?.idToken,
    // );

    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential('${loginResult.accessToken?.tokenString}');

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    Map<String, dynamic> userInfo = <String, dynamic>{};
    String userId = userCredential.user!.uid;

    bool localShowAds = state.showAds;

    DocumentSnapshot<Map<String, dynamic>> fetchedUsers = await db.collection('Users').doc(userId).get();

    if (!fetchedUsers.exists) {
      userInfo = <String, dynamic>{
        "email": userCredential.user!.email!,
        "name": userCredential.user!.displayName!,
        "phone number": userCredential.user!.phoneNumber == null ? "" : userCredential.user!.phoneNumber!,
        "avatar": userCredential.user!.photoURL!,
        "role": "user",
        "isOnline": true,
        "last online": null,
      };

      await db.collection("Users").doc(userId).set(userInfo);
    }
    else {
      await db.collection("Users").doc(userId).update(
          {
            "isOnline": true,
            "last online": null,
          }
      );
      DocumentSnapshot<Map<String, dynamic>> user = await db.collection('Users').doc(userId).get();
      userInfo = user.data() as Map<String, dynamic>;
    }

    String chatId = "";
    bool haveChat = false;
    if (userInfo["role"] == "user") {
      final chatSnapshot = await db.collection("Chat rooms").where("users", arrayContains: userId).get();
      haveChat = chatSnapshot.docs.isNotEmpty;
      if (haveChat) {
        chatId = chatSnapshot.docs[0].id;
      }
    }

    emit(
        state.copyWith(
          haveChat: haveChat,
          chatId: chatId,
          userInfo: userInfo,
          userId: userId,
          showAds: localShowAds,
          provider: "facebook",
          showDialog: true,
        )
    );
  }
  // ----------------------------------------------------

  Future<void> _onLogInWithApple(UserLogInWithApple event, Emitter<UserState> emit) async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    appleProvider.addScope('name');

    UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);

    Map<String, dynamic> userInfo = <String, String>{};
    String? userId = userCredential.user!.uid;

    bool localShowAds = state.showAds;

    DocumentSnapshot<Map<String, dynamic>> fetchedUsers = await db.collection('Users').doc(userId).get();

    if (!fetchedUsers.exists) {
      userInfo = <String, dynamic>{
        "email": userCredential.user!.email!,
        "name": userCredential.user!.displayName!,
        "phone number": userCredential.user!.phoneNumber == null ? "" : userCredential.user!.phoneNumber!,
        "avatar": userCredential.user!.photoURL == null ? "https://firebasestorage.googleapis.com/v0/b/lyudashollywooda-48c11.appspot.com/o/Avatars%2Fno-avatar-25359d55aa3c93ab3466622fd2ce712d1.jpg?alt=media&token=943f997f-7c21-4c03-b9c8-ab72a5dadab3" : userCredential.user!.photoURL!,
        "role": "user",
        "isOnline": true,
        "last online": null,
      };

      await db.collection("Users").doc(userId).set(userInfo);
    }
    else {
      await db.collection("Users").doc(userId).update(
          {
            "isOnline": true,
            "last online": null,
          }
      );
      DocumentSnapshot<Map<String, dynamic>> user = await db.collection('Users').doc(userId).get();
      userInfo = user.data() as Map<String, dynamic>;
    }

    String chatId = "";
    bool haveChat = false;
    if (userInfo["role"] == "user") {
      final chatSnapshot = await db.collection("Chat rooms").where("users", arrayContains: userId).get();
      haveChat = chatSnapshot.docs.isNotEmpty;
      if (haveChat) {
        chatId = chatSnapshot.docs[0].id;
      }
    }

    emit(
      state.copyWith(
        haveChat: haveChat,
        chatId: chatId,
        userInfo: userInfo,
        userId: userId,
        provider: "apple",
        showAds: localShowAds,
        showDialog: true,
      )
    );
  }

  void _onLogoutPressed(UserLogoutPressed event, Emitter<UserState> emit) async {
    await db.collection("Users").doc(state.userId).update(
      {
        "isOnline": false,
        "last online": FieldValue.serverTimestamp(),
      }
    );
    if (state.provider == "google") {
      await state.googleSignIn!.disconnect();
      await state.googleSignIn!.signOut();
    }
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _onInformationFetched(UserInformationFetched event, Emitter<UserState> emit) async {
    var currentUser = authInstance.currentUser;
    if (currentUser != null) {
      emit(state.copyWith(isLoadingUserInfo: true));
      Map<String, dynamic> userInfo = <String, String>{};

      bool localShowAds = state.showAds;

      await db.collection("Users").doc(currentUser.uid).update(
          {
            "isOnline": true,
            "last online": null,
          }
      );
      DocumentSnapshot<Map<String, dynamic>> user = await db.collection('Users').doc(currentUser.uid).get();
      userInfo = user.data() as Map<String, dynamic>;

      String chatId = "";
      bool haveChat = false;
      if (userInfo["role"] == "user") {
        final chatSnapshot = await db.collection("Chat rooms").where("users", arrayContains: currentUser.uid).get();
        haveChat = chatSnapshot.docs.isNotEmpty;
        if (haveChat) {
          chatId = chatSnapshot.docs[0].id;
        }
      }

      emit(
          state.copyWith(
            haveChat: haveChat,
            chatId: chatId,
            userInfo: userInfo,
            userId: currentUser.uid,
            showAds: localShowAds,
            showDialog: true,
            isLoadingUserInfo: false,
          )
      );
    }
  }

  void _onPurchasesRestored(UserPurchasesRestored event, Emitter<UserState> emit) async {
    await Purchases.restorePurchases();
    emit(
        state.copyWith(
          appUserID: await Purchases.appUserID,
        )
    );
  }

  void _onConfigurationsSet(UserConfigurationsSet event, Emitter<UserState> emit) async {
    Offerings? offerings = await Purchases.getOfferings();
    emit(
        state.copyWith(
          productList: offerings.current!.availablePackages,
        )
    );
  }

  void _onPlatformStateInitialized(UserPlatformStateInitialized event, Emitter<UserState> emit) async {
    String appUserID = await Purchases.appUserID;
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    emit(
        state.copyWith(
          appUserID: appUserID,
          customerInfo: customerInfo,
          showAds: !(customerInfo.entitlements.all[entitlementID] != null &&
              customerInfo.entitlements.all[entitlementID]?.isActive == true),
          showDialog: true,
        )
    );
  }
}
