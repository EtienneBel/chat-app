import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/appMainBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTitle(
                  userName: searchSnapshot.docs[index].data()["name"],
                  userEmail: searchSnapshot.docs[index].data()["email"]);
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  /// create chatroom, send user to conversation screen, pushreplacement
  createChatRoomAndStartConversation({String username}) {
    //print("$Constants.myName");
    if (username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ConversationScreen(
        chatRoomId
      )));
    } else {
      print("You cannot send message to yourself");
    }
  }

  Widget SearchTitle({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(userName, style: mediunTextStyle()),
          Text(userEmail, style: mediunTextStyle())
        ]),
        Spacer(),
        GestureDetector(
          onTap: () {
            createChatRoomAndStartConversation(username: userName);
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message", style: mediunTextStyle())),
        )
      ]),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Container(
        child: Column(children: [
          Container(
            color: Color(0x54FFFFFF),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: searchTextEditingController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Search username ... ",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none),
                ),
              ),
              GestureDetector(
                  child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF),
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      child: Icon(Icons.search, color: Colors.white)),
                  onTap: () {
                    initiateSearch();
                  }),
            ]),
          ),
          searchList()
        ]),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
