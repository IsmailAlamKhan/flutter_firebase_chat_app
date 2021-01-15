import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/statemangement/models/models.dart';
import 'package:firebase_chat_app/ui/ui.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:graphx/graphx.dart';

enum CrudState { add, update, delete }

typedef List<T> ListQuery<T extends BaseModel>(QuerySnapshot query);
typedef T SingleQuery<T extends BaseModel>(QuerySnapshot query);

class FirebaseService<T extends BaseModel> extends GetxService {
  String firebaseErrors(String errorCode) {
    String message;
    switch (errorCode) {
      case 'invalid-email':
        message = 'The email is badly formatted.';
        break;
      case 'unauthorized-domain':
        message = 'This domain is not authorized for OAuth.';
        break;
      case 'popup-closed-by-user':
        message = 'Cancelled by user.';
        break;
      case 'account-exists-with-different-credential':
        message =
            'You already have an account with this email but with different credential.';
        break;
      case 'wrong-password':
        message = 'Invalid login credentials.';
        break;
      case 'network-request-failed':
        message = 'Please check your internet connection';
        break;
      case 'too-many-requests':
        message =
            'You inserted wrong login credentials several times. Take a break please!';
        break;
      case 'user-disabled':
        message =
            'Your account has been disabled or deleted. Please contact the system administrator.';
        break;
      case 'requires-recent-login':
        message = 'Please login again and try again!';
        break;
      case 'email-already-exists':
      case 'email-already-in-use':
        message = 'Email address is already in use by an existing user.';
        break;
      case 'user-not-found':
        message =
            'We could not find user account associated with the email address or phone number.';
        break;
      case 'phone-number-already-exists':
        message = 'The phone number is already in use by an existing user.';
        break;
      case 'invalid-phone-number':
        message = 'The phone number is not a valid phone number!';
        break;
      case 'invalid-email  ':
        message = 'The email address is not a valid email address!';
        break;
      case 'cannot-delete-own-user-account':
        message = 'You cannot delete your own user account.';
        break;
      case 'aborted':
        message = 'Aborted due to errors.';
        break;
      case 'already-exists':
        message = 'The document already exits.';
        break;
      case 'cancelled':
        message = 'Cancelled.';
        break;
      case 'internal':
        message = 'Internal Server Error.';
        break;
      case 'permission-denied':
        message = 'You don\'t have sufficient permissions. Please login again';
        break;
      case 'unauthenticated':
        message = 'Your session is expired Please relogin.';
        break;
      case 'not-found':
        message = 'The Document is not found.';
        break;
      default:
        message = 'Oops! Something went wrong. Try again later.';
        break;
    }

    return message;
  }

  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> crud(
    CrudState crudState, {
    Map<String, dynamic> data,
    @required String collection,
    @required T model,
    bool wantLoading = true,
    bool wantNotification = true,
  }) async {
    if (crudState != CrudState.delete && data == null)
      throw Exception('You need to provide data if you are updating or adding');
    if (wantLoading) {
      trace(wantLoading);
      await showLoadingWithProggress(
        wantProggress: false,
      );
      await _crud(
        crudState,
        collection,
        data,
        model,
        wantNotification,
      );
    } else {
      await _crud(crudState, collection, data, model, wantNotification);
    }
  }

  Future _crud(
    CrudState crudState,
    String collection,
    Map<String, dynamic> data,
    T model,
    bool wantNotification,
  ) async {
    try {
      String _crudMessege = '';
      switch (crudState) {
        case CrudState.add:
          _crudMessege = 'Added';
          await _firestore.collection(collection).add(data);
          break;
        case CrudState.update:
          _crudMessege = 'Updated';
          await _firestore.collection(collection).doc(model.id).update(data);
          break;
        case CrudState.delete:
          _crudMessege = 'Deleted';
          await _firestore.collection(collection).doc(model.id).delete();
          break;
        default:
      }
      showSuccessSnackBar(
        body:
            "${model.runtimeType?.convertToString} Successfully $_crudMessege",
      );
    } on FirebaseException catch (e) {
      showErrorSnackBar(body: firebaseErrors(e.code));
    }
  }

  Stream<List<T>> getListStream([ListQuery<T> returnVal, String collection]) =>
      _firestore
          .collection(collection)
          .orderBy('dateCreated')
          .snapshots()
          .map((QuerySnapshot query) => returnVal(query));

  Stream<T> getSingleStream([SingleQuery<T> returnVal, String collection]) =>
      _firestore
          .collection(collection)
          .snapshots()
          .map((QuerySnapshot query) => returnVal(query));
}

abstract class FirebaseCollections {
  static const USER = 'users';
}
