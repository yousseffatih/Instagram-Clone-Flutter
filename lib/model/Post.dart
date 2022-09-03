
import 'package:cloud_firestore/cloud_firestore.dart';

class Post 
{
  final String description;
  final String username;
  final String uid;
  final String postId;
  final datePublished;
  final String PostUrl;
  final String ProfilImage;
  final Likes;

  Post(
    {
        required this.description,
        required this.username, 
        required this.uid, 
        required this.postId, 
        required this.datePublished, 
        required this.PostUrl, 
        required this.ProfilImage, 
        required this.Likes
      }
    );
  
  Map<String , dynamic> toJson() => {
    "description" :description,
    "username" : username,
    "uid" :uid,
    "postId" :postId,
    "datePublished" :datePublished,
    "PostUrl" :PostUrl,
    "ProfilImage" :ProfilImage,
    "Likes" : Likes
  };

  static Post fromSnap(DocumentSnapshot snap)
  {
    var snapshot = snap.data() as Map<String , dynamic>;
    return Post(
      description: snapshot["description"],
      username: snapshot["username"], 
      uid: snapshot["uid"], 
      postId: snapshot["postId"], 
      datePublished: snapshot["datePublished"], 
      PostUrl: snapshot["PostUrl"], 
      ProfilImage: snapshot["ProfilImage"], 
      Likes: snapshot["Likes"]
      );
  }
}