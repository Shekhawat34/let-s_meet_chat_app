import 'package:lets_meet/common/enums/messageEnum.dart';
import 'package:riverpod/riverpod.dart';

class MessageReply{
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(this.messageEnum,this.message,this.isMe);

}

final messageReplyProvider=StateProvider<MessageReply?>((ref)=>null);