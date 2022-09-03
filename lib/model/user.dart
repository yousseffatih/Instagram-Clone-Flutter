
import 'package:cloud_firestore/cloud_firestore.dart';

class User 
{
  final String username;
  final String uid;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final String PhotoUrl;

  User(
    {
        required this.username, 
        required this.uid, 
        required this.email, 
        required this.bio, 
        required this.followers, 
        required this.following, 
        required this.PhotoUrl
      }
    );
  
  Map<String , dynamic> toJson() => {
    "username" : username,
    "uid" :uid,
    "email" :email,
    "bio" :bio,
    "followers" :followers,
    "following" :following,
    "PhotoUrl" : PhotoUrl
  };

  static User fromSnap(DocumentSnapshot snap)
  {
    var snapshot = snap.data() as Map<String , dynamic>;
    return User(
      username: snapshot["username"], 
      uid: snapshot["uid"], 
      email: snapshot["email"], 
      bio: snapshot["bio"], 
      followers: snapshot["followers"], 
      following: snapshot["following"], 
      PhotoUrl: snapshot["PhotoUrl"]
      );
  }
}