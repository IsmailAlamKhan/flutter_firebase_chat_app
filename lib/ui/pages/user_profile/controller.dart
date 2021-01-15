import 'dart:io';

import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileController extends GetxController {
  final _userHasPicture = false.obs;
  final _imagePicked = false.obs;

  String photoUrl = '';

  bool get userHasPicture => _userHasPicture.value;
  bool get imagePicked => _imagePicked.value;
  set imagePicked(bool val) => _imagePicked(val);

  File image;

  var _counter = (0).obs;
  int get counter => _counter.value;
  set counter(int value) => _counter(value);

  final AuthService authController = Get.find();
  TextEditingController displayNameTEC;
  TextEditingController emailTEC;
  final TextEditingController passwordTEC = TextEditingController();

  Future<void> onSave() async {
    final _user = UserModel(
      displayName: displayNameTEC.text,
      email: emailTEC.text,
      id: authController.currentUser.uid,
      emailVerified: authController.currentUser.emailVerified,
      photoURL: photoUrl,
    );
    trace(_user.id);
    await authController.updateUser(_user);
  }

  @override
  void onInit() {
    _userHasPicture(
      (authController.currentUser?.photoURL != null &&
              authController.currentUser?.photoURL != '') ??
          false,
    );
    displayNameTEC = TextEditingController(
      text: authController.currentUser?.displayName,
    );
    emailTEC = TextEditingController(
      text: authController.currentUser?.email,
    );
    super.onInit();
  }

  void pickPhoto() {
    final ImagePicker _picker = ImagePicker();
    openDialog(
      barrierDismissible: true,
      child: AlertDialog(
        title: Text('Choose a source'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              Get.back();
              try {
                final PickedFile _pickedImage =
                    await _picker.getImage(source: ImageSource.camera);
                if (_pickedImage != null) {
                  image = File(_pickedImage.path);
                  _imagePicked(true);
                  photoUrl = _pickedImage.path;
                  _counter++;
                }
              } on PlatformException catch (e) {
                showErrorSnackBar(body: e.message);
              }
            },
            icon: Icon(Icons.camera),
            label: Text('Camera'),
          ),
          TextButton.icon(
            onPressed: () async {
              Get.back();
              try {
                final PickedFile _pickedImage =
                    await _picker.getImage(source: ImageSource.gallery);
                if (_pickedImage != null) {
                  image = File(_pickedImage.path);
                  _imagePicked(true);
                  photoUrl = _pickedImage.path;
                  _counter++;
                }
              } on PlatformException catch (e) {
                showErrorSnackBar(body: e.message);
              }
            },
            icon: Icon(Icons.photo),
            label: Text('Gallery'),
          ),
        ],
      ),
    );
  }

  ImageProvider profilePic() {
    if (imagePicked) {
      return FileImage(image);
    }
    if (authController.currentUser.photoURL != null &&
        authController.currentUser.photoURL != '') {
      return NetworkImage(
        authController.currentUser.photoURL,
      );
    }
    return AssetImage('$ImagePath/defaultDark.png');
  }
}
