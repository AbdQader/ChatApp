import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/screens/chat_screen.dart';
import '/data/models/user.dart';
import '/core/utils/components.dart';

class UserItem extends StatelessWidget {

  final UserModel user;
  const UserItem(this.user);
  
  @override
  Widget build(BuildContext context) {
    var lastMsg = 'start chating...';
    var lastMsgDate = '';
    bool? isMyMsg;
    bool? isMsgRead;
    if (user.lastMessage != null)
    {
      lastMsg = user.lastMessage!.message ?? 'start chating...';
      lastMsgDate = user.lastMessage!.messageDate ?? '';
      isMyMsg = user.id != user.lastMessage!.senderId;
      isMsgRead = user.lastMessage!.isRead;
    }
    return InkWell(
      onTap: () => Get.to(() => ChatScreen(user)),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          children: [
            buildProfileImage(
              imageUrl: user.image!,
              isActive: user.isActive!,
              radius: 40.0,
              outerCircleSize: 20.0,
              innerCircleSize: 18.0,
              positionBottom: 10.0,
              positionRight: 1.0
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 170.0,
                    child: Text(
                      user.username!,
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontSize: 20.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // child: buildText(
                    //   text: user.username!,
                    //   size: 20.0,
                    //   weight: FontWeight.bold,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    //width: 170.0,
                    child: Text(
                      lastMsg,
                      style: Theme.of(context).textTheme.headline3!
                      .copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: isMyMsg != null && isMsgRead != null
                          ? !isMyMsg && 
                            !isMsgRead
                              ? Theme.of(context).accentColor
                              : null
                          : null
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // child: buildText(
                    //   text: lastMsg,
                    //   size: 16.0,
                    //   overflow: TextOverflow.ellipsis,
                    //   color: isMyMsg != null && isMsgRead != null
                    //     ? !isMyMsg && 
                    //       !isMsgRead
                    //         ? Theme.of(context).accentColor
                    //         : null
                    //     : null
                    // ),
                  ),
                ],
              ),
            ),
            //Spacer(),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: Text(
                    buildTimeFormat(date: lastMsgDate),
                    style: Theme.of(context).textTheme.headline2!
                    .copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: isMyMsg != null && isMsgRead != null
                        ? !isMyMsg && !isMsgRead
                          ? Theme.of(context).accentColor
                          : null
                        : null
                    ),
                  ),
                  // child: buildText(
                  //   text: buildTimeFormat(date: lastMsgDate),
                  //   size: 14.0,
                  //   color: isMyMsg != null && isMsgRead != null
                  //     ? !isMyMsg && !isMsgRead
                  //       ? Theme.of(context).accentColor
                  //       : null
                  //     : null
                  // ),
                ),
                const SizedBox(height: 5),
                if (isMyMsg != null && isMsgRead != null && !isMyMsg && !isMsgRead)
                CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 8,
                ),
                if (isMyMsg != null && isMsgRead != null && isMyMsg)
                Icon(
                  Icons.done_all,
                  color: isMsgRead
                    ? Theme.of(context).accentColor
                    : Colors.grey
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}