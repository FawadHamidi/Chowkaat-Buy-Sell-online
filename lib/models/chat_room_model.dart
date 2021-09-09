import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  String? lastMessage;
  String? lastMessageSendBy;
  Timestamp? messageTimestamp;
  List<String>? users;

  ChatRoom(
      {this.lastMessage,
      this.lastMessageSendBy,
      this.messageTimestamp,
      this.users});
  ChatRoom.fromMap(Map<dynamic, dynamic> data) {
    lastMessage = data['last_message'];
    lastMessageSendBy = data['last_message_sendby'];
    messageTimestamp = data['last_message_ts'];
    users = data['users'];
  }
}
