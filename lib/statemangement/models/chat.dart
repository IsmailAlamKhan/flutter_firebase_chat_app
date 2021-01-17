import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:get/get.dart';

class Chat extends BaseModel {
  String id;
  Timestamp dateCreated;
  String uidFrom;
  String uidTo;
  String messege;

  Chat({
    this.id,
    this.dateCreated,
    this.uidFrom,
    this.uidTo,
    this.messege,
  });

//fromDocumentSnapshot
  Chat.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    dateCreated = documentSnapshot.data()["dateCreated"];
    uidFrom = documentSnapshot.data()["uidFrom"];
    uidTo = documentSnapshot.data()["uidTo"];
    messege = documentSnapshot.data()["messege"];
  }

//toString
  @override
  String toString() {
    return '''Chat: {dateCreated = ${this.dateCreated},uidFrom = ${this.uidFrom},uidTo = ${this.uidTo},messege = ${this.messege}}''';
  }

//fromJson
  Chat.fromJson(Map<String, dynamic> json) {
    dateCreated = json['dateCreated'];
    uidFrom = json['uidFrom'];
    uidTo = json['uidTo'];
    messege = json['messege'];
  }

//toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dateCreated'] = this.dateCreated;
    data['uidFrom'] = this.uidFrom;
    data['uidTo'] = this.uidTo;
    data['messege'] = this.messege;
    return data;
  }
}

class ChatCrud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _firebase = Get.put(FirebaseService<Chat>());

  static const Collection = FirebaseCollections.CHAT;

  Stream<List<Chat>> chatStream() {
    return _firebase.getListStream(
      collection: Collection,
      returnVal: (query) {
        List<Chat> retVal = List();
        query.docs.forEach((element) async {
          retVal.add(
            Chat.fromDocumentSnapshot(
              documentSnapshot: element,
            ),
          );
        });
        return retVal;
      },
    );
  }

  Future<String> addchat({Chat chat}) {
    final _data = {
      "dateCreated": Timestamp.now(),
      "uidFrom": chat.uidFrom,
      "uidTo": chat.uidTo,
      "messege": chat.messege,
    };
    return _firebase.crud(
      CrudState.add,
      collection: Collection,
      model: chat,
      wantLoading: false,
      data: _data,
    );
  }

  void updatechat({Chat chat}) {
    _firestore
        .collection("chat")
        .doc(chat.id)
        .update({
          "uidFrom": chat.uidFrom,
          "uidTo": chat.uidTo,
          "messege": chat.messege,
        })
        .then((value) => print('success'))
        .catchError((err) {
          print(err.message);
          print(err.code);
        });
  }

  void deleteChat({String id}) {
    _firestore
        .collection("chat")
        .doc(id)
        .delete()
        .then((value) => print('success'))
        .catchError((err) {
      print(err.message);
      print(err.code);
    });
  }
}
