import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_flutter_clone/resources/auth_methods.dart';
import 'package:insta_flutter_clone/screens/login_screen.dart';
import 'package:insta_flutter_clone/utils/util.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/color.dart';
import '../widgets/input_files.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoding = false;

   void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectedImage() async
  {
    Uint8List im = await pickerImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void SingUpUser() async
  {
    setState(() {
      _isLoding = true;
    });
    String res = await AuthMethods().singUpUser(
                      email: _emailController.text,
                      password: _passwordController.text,
                      bio: _bioController.text,
                      username: _usernameController.text,
                      file: _image!,
                      );
    setState(() {
      _isLoding = false;
    });  

    if(res != "success")
    {
      showSnackbare(res, context);
    }
    else
    {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:(context) => const ReponsiveLayout(mobileScreenLayout: MobileScreenLayout() ,webScreenLayout: webScreenLayout(),)
          )
      );
    }
    
  }

  void navigatToLogin ()
  {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32,),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container() , flex: 2,),
                //svg image
                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox( height: 64,),
                // circular widget to accepte and show our selected file 
                Stack(
                  children: [
                    _image != null ?
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    ) :
                    const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage("https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"),
                    ),
                    Positioned(
                      bottom: -10,
                      left : 80,
                      child: IconButton(
                        onPressed: selectedImage,
                        icon: const Icon(Icons.add_a_photo),
                      )
                    )
                  ],
                ),
                const SizedBox(height: 24,),
                //text field input for username
                InputFiled(
                  textEditingController: _usernameController, 
                  hintText: "Enter your username", 
                  textInputType: TextInputType.text
                  ),
                const SizedBox( height: 24,),
                //texe field input for email
                InputFiled(
                  textEditingController: _emailController, 
                  hintText: "Enter your email", 
                  textInputType: TextInputType.emailAddress
                  ),
                const SizedBox( height: 24,),
                //text field input for password
                InputFiled(
                  textEditingController: _passwordController, 
                  hintText: "Enter your password", 
                  textInputType: TextInputType.text,
                  isPassword: true,
                  ),
                const SizedBox( height: 24,),
                //text field input for bio
                InputFiled(
                  textEditingController: _bioController, 
                  hintText: "Enter your bio", 
                  textInputType: TextInputType.text
                  ),
                const SizedBox( height: 24,),
                //button field login
                InkWell(
                  onTap: SingUpUser,
                  child: Container(
                    child: _isLoding ? Center(child:const  CircularProgressIndicator( color: primaryColor,),) :const Text("Sing Up"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))
                      ),
                    ),
                  ),
                ),
                const SizedBox( height: 12,),
                Flexible(child: Container() , flex: 2,),
                // trainsition to sign up 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Don't have an account?"),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: navigatToLogin,
                      child: Container(
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
  }
}