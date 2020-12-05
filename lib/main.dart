import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/views/chatRoomsScreen.dart';
import 'package:chat_app/views/signIn.dart';
import 'package:chat_app/views/singUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Authenticate(),
      // home: userIsLoggedIn ? ChatRoom() : Authenticate(),
    );
  }
}

class IamBlack extends StatefulWidget {
  @override
  _IamBlackState createState() => _IamBlackState();
}

class _IamBlackState extends State<IamBlack> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
