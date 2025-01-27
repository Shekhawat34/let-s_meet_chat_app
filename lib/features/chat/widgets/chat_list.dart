import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lets_meet/features/chat/widgets/sender_msg_card.dart';

import '../../../common/enums/messageEnum.dart';
import '../../../common/providers/msg_reply_provider.dart';
import '../../../common/widgets/loader.dart';
import '../../../models/message.dart';
import '../controller/chat_controller.dart';
import 'my_msg_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList({
    super.key,
    required this.recieverUserId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void onMessageSwipe(
      String message,
      bool isMe,
      MessageEnum messageEnum,
      ) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
       messageEnum,
       message,
       isMe
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: widget.isGroupChat?
      ref.read(chatControllerProvider).groupChatStream(widget.recieverUserId)
          :ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);

            if (!messageData.isSeen &&
                messageData.recieverid == FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                context,
                widget.recieverUserId,
                messageData.messageId,
              );
            }
            if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onLeftSwipe: () => onMessageSwipe(
                  messageData.text,
                  true,
                  messageData.type,
                ),
                isSeen: messageData.isSeen,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
              username: messageData.repliedTo,
              repliedMessageType: messageData.repliedMessageType,
              onRightSwipe: () => onMessageSwipe(
                messageData.text,
                false,
                messageData.type,
              ),
              repliedText: messageData.repliedMessage,
            );
          },
        );
      },
    );
  }
}
