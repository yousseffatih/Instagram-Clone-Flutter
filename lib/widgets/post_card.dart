import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_flutter_clone/model/user.dart';
import 'package:insta_flutter_clone/providers/user_provider.dart';
import 'package:insta_flutter_clone/resources/firestore_method.dart';
import 'package:insta_flutter_clone/utils/color.dart';
import 'package:insta_flutter_clone/utils/global_variabels.dart';
import 'package:insta_flutter_clone/utils/util.dart';
import 'package:insta_flutter_clone/widgets/comment_screen.dart';
import 'package:insta_flutter_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Post_card extends StatefulWidget {
  final  snap;

  const Post_card({Key? key , required this.snap}) : super(key: key);

  @override
  State<Post_card> createState() => _Post_cardState();
}

class _Post_cardState extends State<Post_card> {

  bool isLikeAnimating = false;
  int commentLen = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async 
  {
    try
    {
        QuerySnapshot snap =  await FirebaseFirestore.instance.collection("Posts").doc(widget.snap["postId"]).collection("Comments").get();
        commentLen  = snap.docs.length;
    }
    catch(e)
    {
      showSnackbare(e.toString(), context);
    }
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width =MediaQuery.of(context).size.width;
    return Container(
      color: width> webScreenSize? webBackgroundColor: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Header section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4 ,horizontal: 16).copyWith(right:0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.snap["ProfilImage"],),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                          ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context) {
                      return Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            "Delete",
                          ].map((e) => InkWell(
                            onTap: () async{
                              FirestoreMethods().deletePost(widget.snap['postId']);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding : const EdgeInsets.symmetric(vertical: 12 ,horizontal: 16),
                              child: Text(e),
                            ),
                            
                          )).toList(),
                        ),
                      );
                    });
                  }, 
                  icon: const Icon(Icons.more_vert)
                ),
              ],
            ),
          ),
          // IMAGE SELECTION
          GestureDetector(
            onDoubleTap: () async{
              await FirestoreMethods().LikePost(widget.snap["postId"], user.uid, widget.snap['Likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children:[ 
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(widget.snap["PostUrl"], fit: BoxFit.fill,),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating? 1 : 0,
                  child: LikeAnimation(
                    child: Icon(Icons.favorite, color:Colors.white, size :120), 
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: (){
                      setState(() {
                        isLikeAnimating = false;
                      });
                    }
                    ),
                ),
              ] 
            ),
          ),
          // Like Comment Section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap["Likes"].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async{
                    await FirestoreMethods().LikePost(widget.snap["postId"], user.uid, widget.snap['Likes']);
                  },
                  icon: widget.snap["Likes"].contains(user.uid)? const Icon(Icons.favorite,color: Colors.red,)
                  : const Icon(Icons.favorite_border,)
                  
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder :(context) =>  CommentScreen(snap :widget.snap))),
                icon: const Icon(Icons.comment_outlined,)
              ),
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.send,)
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: (){},
                  ),
                ),
              ),
            ],
          ),
          // DESCREPTION AND NUMBER COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    "${widget.snap["Likes"].length} Likes",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: primaryColor,
                      ),
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " ${widget.snap["description"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w300
                          )
                        ),
                        
                      ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder :(context) =>  CommentScreen(snap :widget.snap))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View all $commentLen comments",
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd().format(widget.snap["datePublished"].toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        color: secondaryColor
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}