import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:graphx/graphx.dart';

class UserModel extends BaseModel {
  Timestamp dateCreated;
  String id;
  String username;
  String password;
  String email;
  List<UserModel> friends;

  UserModel({
    this.dateCreated,
    this.id,
    this.username,
    this.password,
    this.friends,
    this.email,
  });

//fromDocumentSnapshot
  UserModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    trace(documentSnapshot.data());
    id = documentSnapshot.id;
    dateCreated = documentSnapshot.data()["dateCreated"];
    username = documentSnapshot.data()["username"];
    password = documentSnapshot.data()["password"];
    email = documentSnapshot.data()["email"];
    friends = documentSnapshot.data()["friends"];
  }

//fromJson
  UserModel.fromJson(Map<String, dynamic> json) {
    dateCreated = json['dateCreated'];
    id = json['id'];
    username = json['username'];
    password = json['password'];
  }
//toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dateCreated'] = this.dateCreated;
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}

class UserCrud {
  final FirebaseService<UserModel> firebaseService =
      Get.put(FirebaseService<UserModel>());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String Collection = FirebaseCollections.USER;
  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection(FirebaseCollections.USER).doc(uid).get();
      return UserModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser({UserModel user}) async {
    final Map<String, dynamic> _data = {
      "dateCreated": Timestamp.now(),
      "username": user.username,
      "email": user.email,
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

  void updateuser({UserModel user}) {
    final Map<String, dynamic> _data = {
      "username": user.username,
      "email": user.email,
    };
    firebaseService.crud(
      CrudState.update,
      data: _data,
      wantLoading: false,
      collection: Collection,
      model: UserModel(),
    );
  }

  void deleteUser({String id}) {
    firebaseService.crud(
      CrudState.delete,
      wantLoading: false,
      collection: Collection,
      model: UserModel(),
    );
  }
}
