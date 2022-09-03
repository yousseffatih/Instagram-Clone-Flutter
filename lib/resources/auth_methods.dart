import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../model/user.dart' as model;
import 'package:insta_flutter_clone/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<model.User> getUsersDetails() async
  {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //sing up user
  Future<String> singUpUser(
    {
      required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file,
    }
  ) async
  {
    String res = "Some error occurred";
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty )
      {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage("ProfilePic", file, false);
        //add user to our database
        
        model.User user = model.User(
          username: username,
          uid : cred.user!.uid,
          email:email,
          bio : bio,
          followers:[],
          following :[],
          PhotoUrl : photoUrl
        ) ;

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = "success";
      }
    } 
    
    catch(err) 
    {
      res = err.toString();
    }
    return res;
  }
  
  // loggin user
  Future<String> loginUser({
    required String email ,
    required String password,
  }) async
  {
    String res = 'Some error occurred';
    try
    {
      if(email.isNotEmpty || password.isNotEmpty)
      {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res ="success";
      } else 
      {
        res = "Please enter all fields";
      }
    } 
    // on FirebaseAuthException catch(e) {
    //   if(e.code == "wrrong-password")
    //   {
    //     res = "";
    //   }
    // } 
    catch (err)
    {
      res = err.toString();
    }
    return res;
  } 

  Future<void> singout() async
  {
    await _auth.signOut();
  }
}