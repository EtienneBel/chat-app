import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/appMainBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextEditingController =
      new TextEditingController();

  Widget ChatMessageList() {}

  sendMessage() {
    if(messageTextEditingController.text.isNotEmpty){
      Map<String, String> messageMap = {
        "message": messageTextEditingController.text,
        "sendBy": Constants.myName
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    // databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
    //
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appMainBar(context),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Message ... ",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
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
                        child: Icon(Icons.send, color: Colors.white)),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
