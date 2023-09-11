import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';

class Message {
  final String text;
  final String sender;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String friendId;
  final String friendName;

  ChatScreen(
      {super.key,
      required this.currentUserId,
      required this.friendId,
      required this.friendName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  final _textController = TextEditingController();
  // final _scrollController = ScrollController();

  String getChatID(String userID1, String userID2) {
    if (userID1.compareTo(userID2) < 0) {
      return '$userID1-$userID2';
    } else {
      return '$userID2-$userID1';
    }
  }

  Future<void> sendMessage(
      String senderID, String receiverID, String text) async {
    try {
      final chatID = getChatID(senderID, receiverID);
      final chatDocSender = firestoreInstance
          .collection('Users')
          .doc(senderID)
          .collection('Chats')
          .doc(chatID);
      final chatDocReceiver = firestoreInstance
          .collection('Users')
          .doc(receiverID)
          .collection('Chats')
          .doc(chatID);

      final messageData = {
        'sender': senderID,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      };
      final messageDocSender = chatDocSender.collection('Messages').doc();
      final messageDocReceiver = chatDocReceiver.collection('Messages').doc();
      await messageDocSender.set(messageData);
      await messageDocReceiver.set(messageData);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Stream<List<QuerySnapshot>> getChatMessages(String userID1, String userID2) {
    final chatID = getChatID(userID1, userID2);
    final stream1 = FirebaseFirestore.instance
        .collection('Users')
        .doc(userID1)
        .collection('Chats')
        .doc(chatID)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
    final stream2 = FirebaseFirestore.instance
        .collection('Users')
        .doc(userID2)
        .collection('Chats')
        .doc(chatID)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return StreamZip([stream1, stream2]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friendName),
        backgroundColor: Colors.grey[700],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<List<QuerySnapshot>>(
                stream: getChatMessages(widget.currentUserId, widget.friendId),
                builder: (BuildContext context,
                    AsyncSnapshot<List<QuerySnapshot>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData &&
                      snapshot.data?.first.docs.isNotEmpty == true) {
                    final messages = snapshot.data!.first.docs.map((document) {
                      final data = document.data() as Map<String, dynamic>;
                      final message = Message(
                        text: data['text'] as String,
                        sender: data['sender'] as String,
                        // timestamp: (data['timestamp'] as Timestamp).toDate(),
                        timestamp: data['timestamp'] != null
                            ? (data['timestamp'] as Timestamp).toDate()
                            : DateTime.now(),
                      );
                      return message;
                    }).toList();

                    messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        return Padding(
                          padding: message.sender == widget.currentUserId
                              ? const EdgeInsets.only(
                                  left: 50, right: 5, bottom: 5)
                              : const EdgeInsets.only(
                                  left: 5, right: 50, bottom: 5),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              // side: BorderSide(color: Colors.black, width: 1),
                              borderRadius:
                                  message.sender == widget.currentUserId
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(40),
                                          bottomRight: Radius.circular(10)),
                            ),
                            tileColor: message.sender == widget.currentUserId
                                // ? Colors.blueGrey[300]
                                ? Colors.greenAccent
                                : Colors.blue,
                            title: Text(message.text),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  message.sender == widget.currentUserId
                                      ? 'You'
                                      : widget.friendName,
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  DateFormat.MMMEd()
                                      .add_jm()
                                      .format(message.timestamp),
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    // color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            // trailing: Text(message.timestamp.toString()),
                            // trailing:
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No messages found'));
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[500],
                border: const Border(
                  top: BorderSide(color: Colors.black26),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      color: Colors.grey[850],
                    ),
                    onPressed: () async {
                      final text = _textController.text.trim();

                      if (text.isNotEmpty) {
                        sendMessage(
                            widget.currentUserId, widget.friendId, text);
                        _textController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
