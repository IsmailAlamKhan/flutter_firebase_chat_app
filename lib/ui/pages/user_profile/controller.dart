import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

const double ProfilePicSize = 200;

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
    await authController.updateDeleteUser(true, val: _user);
  }

  Worker userWorker;
  @override
  void onInit() {
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
            icon: Icon(Icons.photo),
            label: Text('Gallery'),
          ),
        ],
      ),
    );
  }

  Widget profilePic() {
    if (imagePicked) {
      return Image.file(
        image,
        fit: BoxFit.cover,
      );
    }
    if (authController.currentUser.photoURL != null &&
        authController.currentUser.photoURL != '') {
      return CachedNetworkImage(
        imageUrl: authController.currentUser.photoURL,
        fit: BoxFit.cover,
        placeholder: (_, __) => Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Image.asset(
      '$ImagePath/defaultDark.png',
      fit: BoxFit.cover,
    );
  }

  void deleteProfile() {
    confirmDialog(
      wantLoading: false,
      onConfirm: (_) {
        Get.back();
        authController.updateDeleteUser(
          false,
        );
      },
    );
  }
}
