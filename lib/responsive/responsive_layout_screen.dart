import 'package:flutter/material.dart';
import 'package:insta_flutter_clone/providers/user_provider.dart';
import 'package:insta_flutter_clone/utils/global_variabels.dart';
import 'package:provider/provider.dart';
class ReponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ReponsiveLayout({Key? key, required this.webScreenLayout, required this.mobileScreenLayout}) : super(key: key);

  @override
  State<ReponsiveLayout> createState() => _ReponsiveLayoutState();
}

class _ReponsiveLayoutState extends State<ReponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  void addData () async
  {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refrecheUser();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) 
      {
        if(constraints.maxWidth > webScreenSize)
        {
          //web screen
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
        
      },
    );
  }
}