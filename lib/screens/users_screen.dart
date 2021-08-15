import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/data/controllers/user_controller.dart';
import '/screens/profile_screen.dart';
import '/widgets/user/user_item.dart';
import '/core/styles/icon_broken.dart';
import '/core/utils/components.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MixinBuilder<UserController>(
      init: UserController(),
      builder: (controller) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            'Messages',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          leading: InkWell(
            onTap: () => Get.to(() => ProfileScreen()),
            child: Container(
              padding: const EdgeInsets.only(left: 15.0),
              child: buildCircleCachedImage(
                imageUrl: controller.user.image ?? null,
                radius: 30.0,
              ),
            ),
          ),
        ),
        body: controller.isLoading
          ? showCircularProgress()
          : controller.users.isEmpty
            ? buildEmptyView(
                text: 'There are no users yet !',
                icon: IconBroken.User,
              )
            : RefreshIndicator(
                onRefresh: () async {
                  controller.getUsers();
                },
                child: ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return UserItem(controller.users[index]);
                  },
                ),
              ),
      ),
    );

  }
}

// return Scaffold(
//   backgroundColor: Colors.white,
//   appBar: AppBar(
//     title: Text(
//       'Messages',
//       style: Theme.of(context).textTheme.bodyText1,
//     ),
//     leading: InkWell(
//       onTap: () => Get.to(() => ProfileScreen(controller.user)),
//       child: Container(
//         padding: EdgeInsets.only(left: 15.0),
//         child: buildCircleCachedImage(
//           imageUrl: controller.user.image ?? null,
//           radius: 30.0,
//         ),
//       ),
//     ),
//     actions: [
//       IconButton(
//         onPressed: () => Get.put(AuthController()).logout(),
//         icon: Icon(
//           IconBroken.Logout, 
//           size: 30, 
//           color: Colors.black
//         ),
//       ),
//     ],
//   ),
//   body: MixinBuilder<UserController>(
//     builder: (controller) {
//       return controller.isLoading
//       ? showCircularProgress()
//       : controller.users.isEmpty
//         ? buildEmptyView(
//             text: 'There are no users yet !',
//             icon: IconBroken.User,
//           )
//         : RefreshIndicator(
//             onRefresh: () async {
//               controller.getUsers();
//             },
//             child: ListView.builder(
//               //physics: BouncingScrollPhysics(),
//               itemCount: controller.users.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return UserItem(controller.users[index]);
//               },
//             ),
//           );
//     },
//   ),
// );
