import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/utils/index.dart';
import 'package:get/get.dart';
import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:graphx/graphx.dart';

enum UserStatus { Active, Inactive, None }

extension on String {
  UserStatus get getuserStatus {
    switch (this) {
      case 'Active':
        return UserStatus.Active;
        break;
      case 'Inactive':
        return UserStatus.Inactive;
        break;
      default:
        return UserStatus.None;
        break;
    }
  }
}

extension ExtendedUserStatus on UserStatus {
  bool get active => this == UserStatus.Active;
  bool get inactive => this == UserStatus.Inactive;
  bool get none => this == UserStatus.None;
  String get getuserStatus {
    switch (this) {
      case UserStatus.Active:
        return 'Active';
        break;
      case UserStatus.Inactive:
        return 'Inactive';
        break;
      default:
        return 'None';
        break;
    }
  }
}

class UserModel extends BaseModel {
  Timestamp dateCreated;
  String id;
  String displayName;
  String photoURL;
  String email;
  List<UserModel> friends;
  bool emailVerified;
  UserStatus userStatus;

  UserModel({
    this.userStatus = UserStatus.Inactive,
    this.dateCreated,
    this.id,
    this.photoURL,
    this.displayName,
    this.friends,
    this.email,
    this.emailVerified = false,
  });
  @override
  String toString() {
    return '''UserModel: {dateCreated = ${this.dateCreated},id = ${this.id},displayName = ${this.displayName},photoURL = ${this.photoURL},email = ${this.email},friends = ${this.friends},emailVerified = ${this.emailVerified},userStatus = ${this.userStatus}}''';
  }

//fromDocumentSnapshot
  UserModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    final _userStatus = (documentSnapshot.data().containsKey('userStatus'))
        ? (documentSnapshot.data()["userStatus"] as String).getuserStatus
        : UserStatus.None;
    trace('User Status', _userStatus, 'as String',
        (documentSnapshot.data()["userStatus"]));
    id = documentSnapshot.id;
    dateCreated = documentSnapshot.data()["dateCreated"];
    displayName = documentSnapshot.data()["username"];
    email = documentSnapshot.data()["email"];
    friends = documentSnapshot.data()["friends"];
    emailVerified = documentSnapshot.data()["emailVerified"];
    photoURL = documentSnapshot.data()["photoURL"];
    userStatus = _userStatus;
  }
}

class UserCrud {
  final FirebaseService<UserModel> firebaseService =
      Get.put(FirebaseService<UserModel>());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String Collection = FirebaseCollections.USER;
  Stream<List<UserModel>> get getUsers {
    return firebaseService.getListStream(
      collection: Collection,
      returnVal: (query) {
        final retVal = <UserModel>[];
        query.docs.forEach((element) {
          retVal.add(UserModel.fromDocumentSnapshot(documentSnapshot: element));
        });
        return retVal;
      },
    );
  }

  Stream<String> getPhotoUrl(String uid) {
    return _firestore
        .collection(Collection)
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot element) {
      final _user = UserModel.fromDocumentSnapshot(
        documentSnapshot: element,
      );
      return _user.photoURL;
    });
  }

  Stream<UserModel> getUser(String uid) {
    trace('getUser', uid);
    return _firestore
        .collection(Collection)
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot element) {
      return UserModel.fromDocumentSnapshot(
        documentSnapshot: element,
      );
    });
  }

  Future<void> createUser({UserModel user}) async {
    final Map<String, dynamic> _data = {
      "dateCreated": Timestamp.now(),
      "username": user.displayName,
      "email": user.email,
      "userStatus": user.userStatus.toString(),
    };
    try {
      await _firestore
          .collection(FirebaseCollections.USER)
          .doc(user.id)
          .set(_data);
    } on FirebaseException catch (e) {
      showErrorSnackBar(body: firebaseService.firebaseErrors(e.code));
    }
  }

  Future<String> updateuser({UserModel user}) async {
    final Map<String, dynamic> _data = {
      "username": user.displayName,
      "email": user.email,
      "emailVerified": user.emailVerified,
      "photoURL": user.photoURL,
      "userStatus": user.userStatus.toString(),
    };
    return await firebaseService.crud(
      CrudState.update,
      data: _data,
      wantLoading: false,
      collection: Collection,
      model: user,
    );
  }

  Future<String> updateUserStatus({UserStatus userStatus}) async {
    trace('updateUserStatus');
    final Map<String, dynamic> _data = {
      "userStatus": userStatus.getuserStatus,
    };
    try {
      await _firestore
          .collection(Collection)
          .doc(AuthService.to.currentUser?.uid)
          .update(_data);
      return 'Succesfully updated';
    } on FirebaseException catch (e) {
      return firebaseService.firebaseErrors(e.code);
    }
  }

  Future<String> deleteUser({String id}) async {
    return await firebaseService.crud(
      CrudState.delete,
      wantLoading: false,
      collection: Collection,
      model: UserModel(),
      id: id,
    );
  }
}
