import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/appMainBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatRoomsScreen.dart';

class SignIn extends StatefulWidget {
  final Function toogle;
  SignIn(this.toogle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn() {
    if (formKey.currentState.validate()) {
      // HelperFunctions.saveUserNameSharedPreference(
      //     userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      databaseMethods
          .getUserByEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0].data()["name"]);
      });

      /// TODO function to get userDetails
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appMainBar(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                          ? null
                          : "Please provide a valid email";
                    },
                    controller: emailTextEditingController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("email"),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val) {
                      return val.length > 6
                          ? null
                          : "Please provide a valid username";
                    },
                    controller: passwordTextEditingController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("password"),
                  ),
                  SizedBox(height: 8),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child:
                          Text("Forget Password ?", style: simpleTextStyle()),
                    ),
                  ),
                  SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      signIn();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC),
                          ])),
                      child: Text("Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                    ),
                  ),
                  SizedBox(height: 18),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text("Sign In with Google",
                        style: TextStyle(color: Colors.black87, fontSize: 17)),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account ? ", style: mediunTextStyle()),
                      GestureDetector(
                        onTap: () {
                          widget.toogle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Register now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
