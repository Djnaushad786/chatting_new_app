import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_view_model.dart';
import 'home_page.dart';


class MassagePage extends StatefulWidget {
  final String otherUid;
  const MassagePage({super.key, required this.otherUid});

  @override
  State<MassagePage> createState() => _MassagePageState();
}

class _MassagePageState extends State<MassagePage> {
  final uId=FirebaseAuth.instance.currentUser?.uid;
  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    var uid= FirebaseAuth.instance.currentUser?.uid ??"";
    Future.delayed(Duration(seconds: 2),() async{
      var viewModel = Provider.of<ChatViewModel>(context, listen: false);
      var chatRoomId = await viewModel.getChatList(cid: uid, otherId: widget.otherUid);


    },);
  }
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ChatViewModel>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatHomePage(uid: ""),));
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height-210 - MediaQuery.of(context).viewInsets.bottom,
            child: Consumer<ChatViewModel>(
              builder: (context, value, child) {
                if (value.chatList.isEmpty) {
                  return Text("data");
                }
                return ListView.builder(
                  controller: controller,
                  itemCount: value.chatList.length,
                  itemBuilder: (context, index) {
                    var user = value.chatList[index];
                    if (user.message_type.toString() == "image") {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: user.senderId == uId
                              ? Align(
                              alignment: Alignment.topRight,
                              child: Image.network("${user.photo_url}",  height: 100, width: 100,))
                              : Align(
                              alignment: Alignment.topLeft,
                              child: Image.network("${user.photo_url}", height: 100, width: 100,))
                      );

                    }else {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: user.senderId == uId
                              ? Align(
                              alignment: Alignment.topRight,
                              child: Text("${user.message}"))
                              : Align(
                              alignment: Alignment.topLeft,
                              child: Text("${user.message}")));
                    }
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 110,
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: viewModel.chatController,
                  decoration: InputDecoration(hintText: "massage",border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                )),
                IconButton(onPressed: () {
                  viewModel.sendChat(otherUid: widget.otherUid);
                  Future.delayed(Duration(milliseconds: 300),() {
                    controller.jumpTo(controller.position.maxScrollExtent);

                  },);
                }, icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),

    );
  }
}


