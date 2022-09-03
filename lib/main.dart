import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_flutter_clone/providers/user_provider.dart';
import 'package:insta_flutter_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_flutter_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_flutter_clone/responsive/web_screen_layout.dart';
import 'package:insta_flutter_clone/screens/login_screen.dart';
import 'package:insta_flutter_clone/screens/singup_screen.dart';
import 'package:insta_flutter_clone/utils/color.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  if(kIsWeb)
  {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCUmSdDCdKEXQuYJb8NyBbri4k8dNbfIh0",
        appId: "1:115011245163:web:0c395b4639b888d9ae0d2e", 
        messagingSenderId: "115011245163", 
        projectId: "insta-flutter-clone-1bf0f",
        storageBucket: "insta-flutter-clone-1bf0f.appspot.com",
        ),
        
    );
  }
  else{
      await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        //home: const ReponsiveLayout(mobileScreenLayout: MobileScreenLayout() ,webScreenLayout: webScreenLayout(),),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context ,snapshot ) {
            if(snapshot.connectionState == ConnectionState.active)
            {
              if(snapshot.hasData)
              {
                return const ReponsiveLayout(mobileScreenLayout: MobileScreenLayout() ,webScreenLayout: webScreenLayout(),);
              } else if(snapshot.hasError)
              {
                return Center(child: Text('${snapshot.error}'));
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting)
            {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor,)
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
