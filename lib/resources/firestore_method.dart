import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insta_flutter_clone/model/Post.dart';
import 'package:insta_flutter_clone/model/user.dart';
import 'package:insta_flutter_clone/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // upload Post 
  Future<String> uploadPost (
    String description,
    Uint8List file , 
    String uid,
    String username,
    String ProfilImage,
    ) async 
  {
    String res = "Some Error occurred";
    try{
      String PhotoUrl = await StorageMethods().uploadImageToStorage("Posts", file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description, 
        username: username, 
        uid: uid, 
        postId: postId, 
        datePublished: DateTime.now(), 
        PostUrl: PhotoUrl, 
        ProfilImage: ProfilImage, 
        Likes: []
      );

      _firestore.collection("Posts").doc(postId).set(post.toJson(),);
      res ="success";
    }
    catch(error)
    {
      res = error.toString();
    }
    return res;
  }

  Future<void> LikePost(String postId , String uid , List likes) async 
  {
    try
    {
      if(likes.contains(uid))
      {
        await _firestore.collection("Posts").doc(postId).update({
          'Likes' : FieldValue.arrayRemove([uid]),
        });
      }
      else{
        await _firestore.collection("Posts").doc(postId).update({
          'Likes' : FieldValue.arrayUnion([uid]),
        });
      }
    }catch (e)
    {
      print(e.toString());
    }
  }
  Future<void> postComment (String postId ,String text,String uid ,String name , String profilePic) async 
  {
    try 
    {
      if(text.isNotEmpty)
      {
        String commentid = const Uuid().v1(); 
        await _firestore.collection('Posts').doc(postId).collection('Comments').doc(commentid).set({
          'ProfilePic':profilePic,
          'datepublshed' : DateTime.now(),
          'name':name,
          'text':text,
          'uid' :uid,
        }
        );
      } 
      else{
        print("Text is empty");
      }
    }
    catch (e)
    {
      print(e.toString());
    }
  }
  // delete post 
  Future<void> deletePost(String postId) async
  {
    try
    {
      _firestore.collection('Posts').doc(postId).delete();
    }
    catch(e)
    {
      print(e.toString());
    }
  }
  Future<void> followerUser(
    String uid,
    String followId
  ) async
  {
    try
    {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following =(snap.data() as dynamic)['following'];

      if(following.contains(followId))
      {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([uid])
        });
      }
      else
      {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([uid])
        });
      }
    }
    catch(e)
    {
      print(e.toString());
    }
  }
}