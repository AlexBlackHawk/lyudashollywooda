import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyudashollywooda/view/requests_page.dart';
import 'package:lyudashollywooda/view/settings_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../user_bloc/user_bloc.dart';
import 'chat_bot_page.dart';
import 'chat_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'post_list_page.dart';


class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> with WidgetsBindingObserver {

  int bniIndex = 0;

  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  void changeTab(index) {
    HapticFeedback.lightImpact();
    controller.jumpToTab(index);
    setState(() {
      // controller.index = index;
      bniIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        context.read<UserBloc>().add(const UserOnlineStatusChanged(isOnline: false));
        break;
      case AppLifecycleState.resumed:
        context.read<UserBloc>().add(const UserOnlineStatusChanged(isOnline: true));
        break;
      case AppLifecycleState.inactive:
        context.read<UserBloc>().add(const UserOnlineStatusChanged(isOnline: false));
        break;
      case AppLifecycleState.hidden:
        context.read<UserBloc>().add(const UserOnlineStatusChanged(isOnline: false));
        break;
      case AppLifecycleState.paused:
        context.read<UserBloc>().add(const UserOnlineStatusChanged(isOnline: false));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        List<Widget> widgetOptions = <Widget>[
          PostsPage(
            userInfo: state.userInfo,
            userId: state.userId,
            showAds: false,
            jumpToTab: changeTab,
            productList: state.productList,
          ),
          ChatListPage(
            userInfo: state.userInfo,
            userId: state.userId,
            jumpToTab: changeTab,
          ),
          RequestsPage(
            userInfo: state.userInfo,
            userId: state.userId,
            jumpToTab: changeTab,
          ),
          ChatBotPage(
            userInfo: state.userInfo,
            userId: state.userId,
            jumpToTab: changeTab,
            productList: state.productList,
          ),
          SettingsPage(
            userInfo: state.userInfo,
            userId: state.userId,
            jumpToTab: changeTab,
          ),
        ];
        List<PersistentBottomNavBarItem> items = [
          PersistentBottomNavBarItem(
            icon: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.022),
              decoration: BoxDecoration(
                color: bniIndex == 0 ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: bniIndex == 0 ? SvgPicture.asset("assets/icons/Home hover.svg") : SvgPicture.asset("assets/icons/BNIHomeActive.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
            ),
            activeColorPrimary: Colors.black,
            inactiveColorPrimary: Colors.white,
          ),
          PersistentBottomNavBarItem(
            icon: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.022),
              decoration: BoxDecoration(
                color: bniIndex == 1 ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: bniIndex == 1 ? SvgPicture.asset("assets/icons/Messages hover.svg") : SvgPicture.asset("assets/icons/BNIMessages.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
            ),
            activeColorPrimary: Colors.black,
            inactiveColorPrimary: Colors.white,
          ),
          PersistentBottomNavBarItem(
            icon: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.022),
              decoration: BoxDecoration(
                color: bniIndex == 2 ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: bniIndex == 2 ? SvgPicture.asset("assets/icons/Bolt hover.svg") : SvgPicture.asset("assets/icons/BNIBoltActive.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
            ),
            activeColorPrimary: Colors.black,
            inactiveColorPrimary: Colors.white,
          ),
          PersistentBottomNavBarItem(
            icon: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.022),
              decoration: BoxDecoration(
                color: bniIndex == 3 ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: FaIcon(FontAwesomeIcons.robot),
              // child: bniIndex == 3 ? SvgPicture.asset("assets/icons/Bolt hover.svg") : SvgPicture.asset("assets/icons/BNIBoltActive.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
            ),
            activeColorPrimary: Colors.black,
            inactiveColorPrimary: Colors.white,
          ),
          PersistentBottomNavBarItem(
            icon: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.022),
              decoration: BoxDecoration(
                color: bniIndex == 4 ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: bniIndex == 4 ? SvgPicture.asset("assets/icons/User hover.svg") : SvgPicture.asset("assets/icons/BNIUserActive.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
            ),
            activeColorPrimary: Colors.black,
            inactiveColorPrimary: Colors.white,
          ),
        ];
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: PersistentTabView(
              context,
              screens: widgetOptions,
              items: items,
              controller: controller,
              confineToSafeArea: true,
              resizeToAvoidBottomInset: false,
              navBarHeight: MediaQuery.of(context).size.height * 0.089,
              handleAndroidBackButtonPress: true,
              backgroundColor: const Color(0xFF636363).withValues(alpha: 0.6),
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 15,
              ),
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              navBarStyle: NavBarStyle.simple,
              onItemSelected: (index) {
                HapticFeedback.lightImpact();
                setState(() {
                  controller.index = index;
                  bniIndex = index;
                });
              },
            ),
          ),
        );

          // return Scaffold(
          //   extendBody: true,
          //   body: widgetOptions.elementAt(state.selectedIndex),
          //   // floatingActionButton: FloatingActionButton(
          //   //   shape: const CircleBorder(
          //   //     // borderRadius: BorderRadius.zero,
          //   //   ),
          //   //   onPressed: () {
          //   //     Navigator.of(context).push(
          //   //       MaterialPageRoute(
          //   //         builder: (context) => AddNewPostPage(userInfo: state.userInfo, userId: state.userId,),
          //   //       ),
          //   //     );
          //   //   },
          //   //   backgroundColor: Colors.white,
          //   //   foregroundColor: Colors.black,
          //   //   child: const Icon(Icons.add),
          //   // ),
          //   bottomNavigationBar: Container(
          //     margin: const EdgeInsets.only(
          //         left: 10,
          //         right: 10,
          //         bottom: 15
          //     ),
          //     child: ClipRRect(
          //       borderRadius: const BorderRadius.all(
          //         Radius.circular(60),
          //       ),
          //       child: BackdropFilter(
          //         filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          //         child: BottomNavigationBar(
          //           showSelectedLabels: false,
          //           showUnselectedLabels: false,
          //           type: BottomNavigationBarType.fixed,
          //           selectedItemColor: Colors.white,
          //           // backgroundColor: Colors.green,
          //           backgroundColor: const Color(0xFF636363).withOpacity(0.5),
          //           selectedIconTheme: const IconThemeData(
          //             color: Colors.black,
          //           ),
          //           unselectedIconTheme: const IconThemeData(
          //             color: Colors.white,
          //           ),
          //           items: <BottomNavigationBarItem>[
          //             BottomNavigationBarItem(
          //               icon: Container(
          //                 padding: const EdgeInsets.all(17),
          //                 decoration: BoxDecoration(
          //                   color: state.selectedIndex == 0 ? Colors.white : Colors.transparent,
          //                   shape: BoxShape.circle,
          //                 ),
          //                 child: const Icon(Iconsax.home_2, size: 40,),
          //               ),
          //               // Icon(Icons.other_houses_outlined, size: 40,),
          //               label: "",
          //             ),
          //             BottomNavigationBarItem(
          //               icon: Container(
          //                 padding: const EdgeInsets.all(17),
          //                 decoration: BoxDecoration(
          //                   color: state.selectedIndex == 1 ? Colors.white : Colors.transparent,
          //                   shape: BoxShape.circle,
          //                 ),
          //                 child: const Icon(Icons.mail, size: 40,),
          //               ),
          //               // Icon(Icons.mail, size: 40,),
          //               label: "",
          //             ),
          //             BottomNavigationBarItem(
          //               icon: Container(
          //                 padding: const EdgeInsets.all(17),
          //                 decoration: BoxDecoration(
          //                   color: state.selectedIndex == 2 ? Colors.white : Colors.transparent,
          //                   shape: BoxShape.circle,
          //                 ),
          //                 child: const Icon(Icons.bolt_outlined, size: 40,),
          //               ),
          //               // Icon(Icons.bolt_outlined, size: 40,),
          //               label: "",
          //             ),
          //           ],
          //           currentIndex: state.selectedIndex,
          //           onTap: (tabIndex) {
          //             BlocProvider.of<UserBloc>(context).add(ChangeIndex(index: tabIndex));
          //           },
          //         ),
          //       ),
          //     ),
          //   ),
          // );
      }
    );
  }
}