// dart
import 'package:flutter/material.dart';

// third party
import 'package:go_router/go_router.dart';

// app
import 'package:hunters_app/go_router/router.dart';

class FollowFollowerListPage extends StatefulWidget {
  final bool? isFollow;
  const FollowFollowerListPage({super.key, required this.isFollow});

  @override
  FollowFollowerListPageState createState() => FollowFollowerListPageState();
}

class FollowFollowerListPageState extends State<FollowFollowerListPage> {
  // List<Followers> followersList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.isFollow == null
                ? const Text('invalid arg FollowFollowerListPage')
                : widget.isFollow!
                    ? const Text('フォロー')
                    : const Text('フォロワー'),
          ],
        ),
        toolbarHeight: 60,
        backgroundColor: const Color.fromRGBO(22, 106, 30, 1.0),
        automaticallyImplyLeading: true,
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.pushNamed(RoutesName.otherUser.name);
          },
          child: const Text('taro test'),
        ),
      ),

      // ListView(
      //   children: [

      //   ],
      //   ),
    );
  }
}
