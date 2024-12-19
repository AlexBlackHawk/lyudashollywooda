import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyudashollywooda/view/post_list_page.dart';
import 'package:lyudashollywooda/view/settings_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../user_bloc/user_bloc.dart';
import 'additional_services_page.dart';
import 'chat_bot_page.dart';
import 'chat_page.dart';
import 'no_chats_page.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> with WidgetsBindingObserver {

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
        final List<Widget> widgetOptions = <Widget>[
          PostsPage(
            userInfo: state.userInfo,
            userId: state.userId,
            showAds: state.showAds,
            jumpToTab: changeTab,
            productList: state.productList,
          ),
          state.haveChat ? ChatPage(
            userInfo: state.userInfo,
            userId: state.userId,
            chatId: state.chatId,
            jumpToTab: changeTab,
          ) : NoChatsPage(
            userInfo: state.userInfo,
            userId: state.userId,
            jumpToTab: changeTab,
            productList: state.productList,
          ),
          AdditionalServicesPage(
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
              child: Center(child: bniIndex == 0 ? SvgPicture.asset("assets/icons/Home hover.svg") : SvgPicture.asset("assets/icons/BNIHomeActive.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),),
              // child: const Icon(Iconsax.home_2_copy, size: 24,),
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
              child: Center(child: bniIndex == 1 ? SvgPicture.asset("assets/icons/Messages hover.svg") : SvgPicture.asset("assets/icons/BNIMessages.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),),
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
              child: Center(child: bniIndex == 2 ? SvgPicture.asset("assets/icons/Bolt hover.svg") : SvgPicture.asset("assets/icons/BNIBoltActive.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),),
            ),
            activeColorPrimary: Colors.black,
            inactiveColorPrimary: Colors.white,
          ),
          PersistentBottomNavBarItem(
            icon: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                color: bniIndex == 3 ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(child: FaIcon(FontAwesomeIcons.robot, size: 24,)),
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
              child: Center(child: bniIndex == 4 ? SvgPicture.asset("assets/icons/User hover.svg") : SvgPicture.asset("assets/icons/BNIUserActive.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),),
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
              // popBehaviorOnSelectedNavBarItemPress: PopBehavior.,
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

        // return ClipRRect(
        //   child: BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        //     child: PersistentTabView(
        //       context,
        //       screens: widgetOptions,
        //       items: items,
        //       controller: controller,
        //       confineToSafeArea: true,
        //       resizeToAvoidBottomInset: true,
        //       // popBehaviorOnSelectedNavBarItemPress: PopBehavior.,
        //       navBarHeight: MediaQuery.of(context).size.height * 0.089,
        //       handleAndroidBackButtonPress: true,
        //       hideNavigationBarWhenKeyboardAppears: true,
        //       backgroundColor: const Color(0xFF636363).withOpacity(0.6),
        //       margin: const EdgeInsets.only(
        //         left: 20,
        //         right: 20,
        //         // bottom: 15,
        //       ),
        //       bottomScreenMargin: 15,
        //       decoration: NavBarDecoration(
        //         borderRadius: BorderRadius.circular(60),
        //       ),
        //       navBarStyle: NavBarStyle.simple,
        //       onItemSelected: (index) {
        //         setState(() {
        //           controller.index = index;
        //           bniIndex = index;
        //         });
        //         //   // if (tabIndex == 1 && state.haveChat) {
        //         //   //
        //         //   // }
        //       },
        //     ),
        //   ),
        // );
        // return Scaffold(
        //   extendBody: true,
        //   body: widgetOptions.elementAt(state.selectedIndex),
        //   bottomNavigationBar: Container(
        //     // color: Colors.red,
        //     margin: const EdgeInsets.only(
        //         left: 20,
        //         right: 20,
        //         bottom: 15
        //     ),
        //     child: ClipRRect(
        //       borderRadius: BorderRadius.circular(60),
        //       child: BackdropFilter(
        //         filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        //         child: BottomNavigationBar(
        //           showSelectedLabels: false,
        //           showUnselectedLabels: false,
        //           type: BottomNavigationBarType.fixed,
        //           selectedItemColor: Colors.white,
        //           // backgroundColor: Colors.green,
        //           backgroundColor: const Color(0xFF636363).withOpacity(0.6),
        //           // backgroundColor: Colors.red,
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
        //                 child: Icon(Iconsax.home_2, size: 40,),
        //               ),
        //               // icon: Icon(Icons.other_houses_outlined, size: 40,),
        //               label: "",
        //             ),
        //             BottomNavigationBarItem(
        //               icon: Container(
        //                 padding: const EdgeInsets.all(17),
        //                 decoration: BoxDecoration(
        //                   color: state.selectedIndex == 1 ? Colors.white : Colors.transparent,
        //                   shape: BoxShape.circle,
        //                 ),
        //                 child: const Icon(Iconsax.sms_copy, size: 40,),
        //               ),
        //               // icon: Icon(Icons.email_outlined, size: 40,),
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
        //               // icon: Icon(Icons.bolt_outlined, size: 40,),
        //               label: "",
        //             ),
        //             BottomNavigationBarItem(
        //               icon: Container(
        //                 padding: const EdgeInsets.all(17),
        //                 decoration: BoxDecoration(
        //                   color: state.selectedIndex == 3 ? Colors.white : Colors.transparent,
        //                   shape: BoxShape.circle,
        //                 ),
        //                 child: const Icon(Iconsax.user_square_copy, size: 40,),
        //               ),
        //               // icon: Icon(Icons.person, size: 40,),
        //               label: "",
        //             ),
        //           ],
        //           currentIndex: state.selectedIndex,
        //           onTap: (tabIndex) {
        //             BlocProvider.of<UserBloc>(context).add(ChangeIndex(index: tabIndex));
        //             // if (tabIndex == 1 && state.haveChat) {
        //             //
        //             // }
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }
}