import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/utils/index.dart';
import 'package:get/get.dart';
import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:graphx/graphx.dart';

class UserModel extends BaseModel {
  Timestamp dateCreated;
  String id;
  String displayName;
  String photoURL;
  String email;
  List<UserModel> friends;
  bool emailVerified;

  UserModel({
    this.dateCreated,
    this.id,
    this.photoURL,
    this.displayName,
    this.friends,
    this.email,
    this.emailVerified = false,
  });

//fromDocumentSnapshot
  UserModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    trace(documentSnapshot.data());
    id = documentSnapshot.id;
    dateCreated = documentSnapshot.data()["dateCreated"];
    displayName = documentSnapshot.data()["username"];
    email = documentSnapshot.data()["email"];
    friends = documentSnapshot.data()["friends"];
    emailVerified = documentSnapshot.data()["emailVerified"];
    photoURL = documentSnapshot.data()["photoURL"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dateCreated'] = this.dateCreated;
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    data['photoURL'] = this.photoURL;
    data['email'] = this.email;
    if (this.friends != null) {
      data['friends'] = this.friends.map((v) => v.toJson()).toList();
    }
    data['emailVerified'] = this.emailVerified;
    return data;
  }
}

class UserCrud {
  final FirebaseService<UserModel> firebaseService =
      Get.put(FirebaseService<UserModel>());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String Collection = FirebaseCollections.USER;
  Stream<UserModel> getUser(String uid) {
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
    };
    return await firebaseService.crud(
      CrudState.update,
      data: _data,
      wantLoading: false,
      collection: Collection,
      model: user,
    );
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
