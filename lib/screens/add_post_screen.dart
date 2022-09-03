import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_flutter_clone/model/user.dart';
import 'package:insta_flutter_clone/providers/user_provider.dart';
import 'package:insta_flutter_clone/resources/firestore_method.dart';
import 'package:insta_flutter_clone/utils/color.dart';
import 'package:insta_flutter_clone/utils/util.dart';
import 'package:provider/provider.dart';

class AddPageScreen extends StatefulWidget {
  const AddPageScreen({Key? key}) : super(key: key);

  @override
  State<AddPageScreen> createState() => _AddPageScreenState();
}

class _AddPageScreenState extends State<AddPageScreen> {

  Uint8List? _file;
  final TextEditingController _descreptionController = TextEditingController();
  bool _isloding = false;

  selecteImage(BuildContext context)
  {
    return showDialog(
      context: context, 
      builder: (context){
        return SimpleDialog(
          title: const Text("Create Post"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickerImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Chosse from Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickerImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  void PostImage (String uid,String username,String ProfilImage) async
  {
    setState(() {
      _isloding = true;
    });
    try 
    {
      String res = await FirestoreMethods().uploadPost(
        _descreptionController.text,
        _file! ,
        uid,
        username,
        ProfilImage
      );
      if(res == "success")
      {
        setState(() {
          _isloding = false;
        });
        showSnackbare("Posted", context);
        clearImage();
      }
      else{
        setState(() {
          _isloding = false;
        });
        showSnackbare(res, context);
      }
    }
    catch(e)
    {
      showSnackbare(e.toString(), context);
    }
  }
  void clearImage()
  {
    setState(() {
      _file = null;
    });
  } 

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descreptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser; 

    return _file == null ? 
    Center(
        child: IconButton(
          onPressed: () => selecteImage(context),
          icon:const Icon(Icons.upload,)
        ),
      )
    : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: clearImage,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Post to"),
        centerTitle: false ,
        actions: [
          TextButton(
            onPressed: () => PostImage(user.uid, user.username, user.PhotoUrl), 
            child: const Text(
              "Post" , 
              style: TextStyle(
                color: Colors.blueAccent , 
                fontWeight: FontWeight.bold , 
                fontSize: 16,
                ),
              )
          )
        ],
      ),
      body: Column(
        children: [
          _isloding? const LinearProgressIndicator() : Container(),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.PhotoUrl),
                
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextField(
                  controller: _descreptionController,
                  decoration: const InputDecoration(
                    hintText: "Write a caption...",
                    border: InputBorder.none
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                width: 45,
                height: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit :BoxFit.fill,
                        alignment :FractionalOffset.topCenter
                      )
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          )
        ],
      ),
    );
  }
}