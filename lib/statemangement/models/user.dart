import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_chat_app/statemangement/statemangement.dart';

class UserModel extends BaseModel {
  Timestamp dateCreated;
  String id;
  String username;
  String password;

  UserModel({
    this.dateCreated,
    this.id,
    this.username,
    this.password,
  });

//fromDocumentSnapshot
  UserModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    dateCreated = documentSnapshot.data()["dateCreated"];
    username = documentSnapshot.data()["username"];
    password = documentSnapshot.data()["password"];
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
  final FirebaseService<UserModel> firebaseService = Get.find();
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

  void createUser({UserModel user}) {
    final Map<String, dynamic> _data = {
      "dateCreated": Timestamp.now(),
      "id": user.id,
      "username": user.username,
      "password": user.password,
    };
    firebaseService.crud(
      CrudState.add,
      data: _data,
      collection: Collection,
      model: UserModel(),
    );
  }

  void updateuser({UserModel user}) {
    final Map<String, dynamic> _data = {
      "username": user.username,
      "password": user.password,
    };
    firebaseService.crud(
      CrudState.update,
      data: _data,
      collection: Collection,
      model: UserModel(),
    );
  }

  void deleteUser({String id}) {
    firebaseService.crud(
      CrudState.delete,
      collection: Collection,
      model: UserModel(),
    );
  }
}
