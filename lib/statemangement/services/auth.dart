import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/ui/index.dart';
import 'package:firebase_chat_app/utils/index.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';
import '../index.dart';

class AuthService extends GetxService {
  final FirebaseService _firebaseService = Get.find();
  final UserController userController = Get.find();
  static AuthService to = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  Rx<User> user = Rx<User>();
  User get currentUser => user.value;

  @override
  void onInit() {
    user.bindStream(auth.authStateChanges());
    user.bindStream(auth.userChanges());
    super.onInit();
  }

  Future<void> verifyEmail() async {
    currentUser.reload();

    if (!currentUser.emailVerified) {
      try {
        await currentUser.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        showErrorSnackBar(body: _firebaseService.firebaseErrors(e.code));
      }
    } else {
      try {
        final String msg = await UserCrud().updateuser(
          user: UserModel(
            email: currentUser.email,
            id: currentUser.uid,
            displayName: currentUser.displayName,
            emailVerified: true,
          ),
        );
        showSuccessSnackBar(body: msg);
      } catch (e) {
        showErrorSnackBar(body: e.toString());
      }
    }
  }

  Future<void> confirmDeleteUser() async {
    final obscure = true.obs;
    final TextEditingController tec = TextEditingController();

    openDialog(
      child: AlertDialog(
        title: Text(
          'Please enter your pasword and confirm to ${'Delete your profile'}',
        ),
        scrollable: true,
        content: Column(
          children: [
            DefaultTextField.password(
              false,
              tec: tec,
              obscure: obscure.value,
              showPass: () => obscure(false),
              hidePass: () => obscure(true),
              mandatory: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (tec.text == '' || tec.text == null) {
                showErrorSnackBar(body: 'Please enter your password');
                return;
              }
              Get.back();
              AuthCredential credential = EmailAuthProvider.credential(
                email: currentUser.email,
                password: tec.text,
              );
              try {
                await auth.currentUser.reauthenticateWithCredential(credential);

                _deleteUser();
              } on FirebaseAuthException catch (e) {
                showErrorSnackBar(
                  body: _firebaseService.firebaseErrors(e.code),
                );
              }
            },
            child: Text('Confirm'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateFirebaseUser(UserModel val) async {
    if (val.displayName != null && val.displayName != currentUser.displayName) {
      await currentUser.updateProfile(
        displayName: val.displayName,
      );
    } else if (val.photoURL != null &&
        val.photoURL != '' &&
        val.photoURL != currentUser.photoURL) {
      await _firebaseService.uploadFile(
        child: 'profileimages',
        fileName: currentUser.uid,
        fileURL: val.photoURL,
      );
      await currentUser.updateProfile(
        photoURL: await _firebaseService.getDownloadURL(
          child: 'profileimages',
          fileName: currentUser.uid,
        ),
      );
    } else if (val.email != null && val.email != currentUser.email) {
      await currentUser.updateEmail(
        val.email,
      );
    }
  }

  Future<void> updateUser(UserModel val) async {
    if (val == null) return;

    if (val.displayName == currentUser.displayName &&
        val.email == currentUser.email &&
        val.photoURL == currentUser.photoURL) {
      showInfoSnackBar(body: 'Nothing to update');
      return;
    }

    await showLoadingWithProggress(
      wantProggress: false,
    );
    try {
      await _updateFirebaseUser(val);
      await currentUser.reload();
      final _user = UserModel(
        displayName: currentUser.displayName,
        email: currentUser.email,
        emailVerified: currentUser.emailVerified,
        photoURL: currentUser.photoURL,
        id: currentUser.uid,
      );
      final String msg = await UserCrud().updateuser(user: _user);
      Get.back();
      showSuccessSnackBar(body: msg);
      Get.find<UserProfileController>().image = null;
      Get.find<UserProfileController>().imagePicked = false;
      Get.find<UserProfileController>().counter += 1;
    } on FirebaseAuthException catch (e) {
      Get.back();
      showErrorSnackBar(body: _firebaseService.firebaseErrors(e.code));
    } catch (e) {
      Get.back();
      showErrorSnackBar(body: e.toString());
    }
  }

  Worker userWorker;
  @override
  void onReady() {
    userWorker = ever(userController.user, (UserModel val) {
      if (currentUser?.displayName != val.displayName) {
        currentUser.updateProfile(
          displayName: val.displayName,
        );
        currentUser.reload();
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    userWorker?.dispose();
  }

  Future<String> doAuth(
    AuthState authState, {
    @required String email,
    @required String password,
    @required String username,
  }) async {
    try {
      UserCredential authResult;
      trace(authState);
      switch (authState) {
        case AuthState.Login:
          authResult = await auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          break;
        case AuthState.Registration:
          authResult = await auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          final currentUser = auth.currentUser;
          await currentUser.updateProfile(displayName: username);
          final user = UserModel(
            id: currentUser.uid,
            email: currentUser.email,
            displayName: username,
            emailVerified: false,
          );
          verifyEmail();
          await UserCrud().createUser(
            user: user,
          );
          break;
        default:
      }
      currentUser.reload();
      userController.fillUser(UserCrud().getUser(authResult.user.uid));
      return 'Sucessful';
    } on FirebaseAuthException catch (e) {
      trace(e);
      return Future.error(_firebaseService.firebaseErrors(e.code));
    } on FirebaseException catch (e) {
      return Future.error(_firebaseService.firebaseErrors(e.code));
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
      userController.user(UserModel());
      Auth(
        authState: AuthState.Login,
      ).offAll(AuthBinding());
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(body: _firebaseService.firebaseErrors(e.code));
    }
  }

  Future<void> _deleteUser() async {
    try {
      await _firebaseService.deleteFile(
        child: 'profileimages',
        fileName: currentUser.uid,
      );
      final String msg = await UserCrud().deleteUser(
        id: currentUser.uid,
      );
      await currentUser.delete();
      showSuccessSnackBar(body: msg);
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(body: _firebaseService.firebaseErrors(e.code));
    } on FirebaseException catch (e) {
      showErrorSnackBar(body: _firebaseService.firebaseErrors(e.code));
    }
  }
}
