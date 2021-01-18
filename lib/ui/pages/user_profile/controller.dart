import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/ui/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:firebase_chat_app/utils/index.dart';

class UserProfileController extends BaseController {
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
    await authController.updateUser(_user);
  }

  Worker userWorker;
  @override
  void onInit() {
    displayNameTEC = TextEditingController(
      text: authController.currentUser?.displayName,
    );
    emailTEC = TextEditingController(
      text: authController.currentUser?.email,
    );
    userWorker = ever(authController.user, (User user) {
      _userHasPicture(
        (user?.photoURL != null && user?.photoURL != '') ?? false,
      );
      displayNameTEC = TextEditingController(
        text: user?.displayName,
      );
      emailTEC = TextEditingController(
        text: user?.email,
      );
    });
    super.onInit();
  }

  @override
  void onClose() {
    userWorker?.dispose();
  }

  Future<File> _crop(PickedFile _pickedImage, BuildContext context) async {
    return await ImageCropper.cropImage(
      sourcePath: _pickedImage.path,
      aspectRatio: CropAspectRatio(
        ratioX: ProfilePicSize,
        ratioY: ProfilePicSize,
      ),
      cropStyle: CropStyle.circle,
      androidUiSettings: AndroidUiSettings(
        cropFrameColor: Colors.transparent,
        toolbarTitle: 'Adjust image',
        toolbarWidgetColor: Colors.white,
        showCropGrid: false,
        activeControlsWidgetColor: context.theme.primaryColor,
        toolbarColor: context.theme.primaryColor,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Adjust image',
      ),
    );
  }

  void pickPhoto(BuildContext context) {
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
                  File croppedFile = await _crop(_pickedImage, context);
                  if (croppedFile == null) {
                    image = File(_pickedImage.path);
                    photoUrl = _pickedImage.path;
                  } else {
                    image = File(croppedFile.path);
                    photoUrl = croppedFile.path;
                  }

                  _imagePicked(true);
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
            icon: DefaultIcon(Icons.photo),
            label: Text('Gallery'),
          ),
        ],
      ),
    );
  }

  void deleteProfile() {
    confirmDialog(
      wantLoading: false,
      onConfirm: (_) {
        Get.back();
        authController.confirmDeleteUser();
      },
    );
  }
}
