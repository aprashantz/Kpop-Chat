import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/business_logic/real_users_cubit/real_users_cubit.dart';
import 'package:kpopchat/business_logic/virtual_friends_list_cubit/virtual_friends_list_cubit.dart';
import 'package:kpopchat/business_logic/virtual_friends_posts_cubit/virtual_friends_posts_cubit.dart';
import 'package:kpopchat/core/utils/initializer.dart';
import 'package:kpopchat/presentation/screens/friends_map_screen/friends_map_screen.dart';
import 'package:kpopchat/presentation/screens/home_screen/home_screen.dart';
import 'package:kpopchat/presentation/screens/virtual_friends_list_screen/virtual_friends_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ValueNotifier<int> _navAt = ValueNotifier<int>(1);
  PageController _pageController = PageController(initialPage: 1);
  final ScrollController _homeScrollController = ScrollController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    RequiredInitializations.initializeFirebaseRemoteConfig();
    BlocProvider.of<VirtualFriendsPostsCubit>(context).fetchPosts();
    BlocProvider.of<VirtualFriendsListCubit>(context).getVirtualFriends();
    BlocProvider.of<RealUsersCubit>(context).fetchRealUsers();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _navAt,
        builder: (context, currentIndex, child) {
          return CupertinoTabBar(
              currentIndex: currentIndex,
              onTap: (value) {
                if (_navAt.value != value) {
                  _pageController.jumpToPage(value);
                }
              },
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.globe), label: "Posts"),

                const BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.chat_bubble_2), label: "Chats"),
                const BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.location), label: "Kpop Map"),

                // const BottomNavigationBarItem(icon: Icon(Icons.people)),
                // const BottomNavigationBarItem(
                //     icon: Icon(CupertinoIcons.memories)),
              ]);
        },
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (newPage) => _navAt.value = newPage,
        children: [
          HomeScreen(scrollController: _homeScrollController),
          VirtualFriendsListScreen(
            scrollController: _chatScrollController,
          ),
          FriendsMapScreen(),
        ],
      ),
    );
  }
}
