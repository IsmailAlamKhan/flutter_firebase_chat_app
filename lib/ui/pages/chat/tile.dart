import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_chat_app/utils/index.dart';
import 'index.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key key,
    @required this.name,
    @required this.isMe,
    @required this.sent,
    @required this.imageURL,
    @required this.messege,
    @required this.id,
  }) : super(key: key);
  final String name;
  final String sent;
  final String imageURL;
  final String messege;
  final String id;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width - 200,
      margin: 5.0.padSymVERT,
      child: Card(
        color: isMe
            ? context.theme.primaryColor
            : context.theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: isMe ? 10 : 0,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: ClipOval(
                    child: SizedBox.expand(
                      child: imageURL != null
                          ? CachedNetworkImage(
                              imageUrl: imageURL,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              '$ImagePath/defaultDark.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                15.0.sizedWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            isMe ? 'You' : name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: context.textTheme.headline6
                                .copyWith(color: isMe ? Colors.white : null),
                          ),
                          10.0.sizedWidth,
                          Text(
                            sent,
                            style: context.textTheme.caption
                                .copyWith(color: isMe ? Colors.white : null),
                          ),
                        ],
                      ),
                      5.0.sizedHeight,
                      Text(
                        messege,
                        style: TextStyle(
                          color: id == ERRORID
                              ? context.theme.errorColor
                              : isMe
                                  ? Colors.white
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
