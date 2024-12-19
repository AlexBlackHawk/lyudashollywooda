import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyudashollywooda/view/personal_information_page.dart';
import 'package:lyudashollywooda/view/subscription_settings_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../user_bloc/user_bloc.dart';
import 'log_in_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.userInfo, required this.userId, required this.jumpToTab});

  final Map<String, dynamic> userInfo;
  final String userId;
  final void Function(int) jumpToTab;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        // if (state.goToLogInPage) {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => const LogInView(),
        //     ),
        //   );
        //   // context.read<UserBloc>().add(const CancelGoToLogInPage());
        // }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0.0,
            leading: Container(
              width: MediaQuery.of(context).size.height * 0.0591,
              height: MediaQuery.of(context).size.height * 0.0591,
              margin: const EdgeInsets.only(
                left: 10,
                // right: 10
              ),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF0F0F0),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // controller.jumpToTab(0);
                  widget.jumpToTab(0);
                  // PersistentNavBarNavigator.pop(context);
                  // AppStateManager.persistentTabController.jumpToTab(tabIndex);
                },
              ),
            ),
            actions: [
              Container(
                width: MediaQuery.of(context).size.height * 0.0591,
                height: MediaQuery.of(context).size.height * 0.0591,
                margin: const EdgeInsets.only(
                  right: 15,
                  // right: 10
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF0F0F0),
                ),
                child: IconButton(
                  icon: SvgPicture.asset("assets/icons/log-out.svg"),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.read<UserBloc>().add(const UserLogoutPressed());
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const LogInView(),
                      withNavBar: false,
                    );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const LogInView(),
                    //   ),
                    // );
                  },
                ),
              ),
            ],
            // toolbarHeight: 100,,
          ),
          body: Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              // top: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "Налаштування облікового запису",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      // fontSize: MediaQuery.textScalerOf(context).scale(16),
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // const Divider(
                //   color: Color(0xFFD9D9D9),
                // ),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: Color(0xFFD9D9D9))
                  ),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: PersonalInformationPage(userId: widget.userId,),
                      withNavBar: true,
                    );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => PersonalInformationPage(userId: userId,),
                    //   ),
                    // );
                  },
                  leading: SvgPicture.asset("assets/icons/User Circle.svg"),
                  title: Text(
                    textScaler: TextScaler.linear(1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "Особиста інформація",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      // fontSize: MediaQuery.textScalerOf(context).scale(14),
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: PersonalInformationPage(userId: widget.userId,),
                        withNavBar: true,
                      );
                    },
                    icon: const Icon(
                      Icons.chevron_right
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: widget.userInfo["role"] == "user",
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(color: Color(0xFFD9D9D9))
                    ),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: SubscriptionsSettingsPage(userInfo: widget.userInfo, userId: widget.userId,),
                        withNavBar: true,
                      );
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => const SubscriptionsSettingsPage(),
                      //   ),
                      // );
                    },
                    leading: SvgPicture.asset("assets/icons/Star Circle.svg"),
                    title: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "Підписка",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        // fontSize: MediaQuery.textScalerOf(context).scale(14),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: SubscriptionsSettingsPage(userInfo: widget.userInfo, userId: widget.userId,),
                          withNavBar: true,
                        );
                      },
                      icon: const Icon(
                        Icons.chevron_right
                      ),
                    ),
                  ),
                ),
                // widget.userInfo["role"] == "user" ? const Divider(
                //   color: Color(0xFFD9D9D9),
                // ) : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}