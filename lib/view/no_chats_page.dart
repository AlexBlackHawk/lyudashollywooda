import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyudashollywooda/view/subscription_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import '../chat_bloc/chat_bloc.dart';
import 'chat_page.dart';
import 'donate_page.dart';

class NoChatsPage extends StatefulWidget {
  const NoChatsPage({super.key, required this.userInfo, required this.userId, required this.jumpToTab, required this.productList});

  final Map<String, dynamic> userInfo;
  final String userId;
  final void Function(int) jumpToTab;
  final List<Package> productList;

  @override
  State<NoChatsPage> createState() => _NoChatsPageState();
}

class _NoChatsPageState extends State<NoChatsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state.isNewChatRoomCreated) {
          String chatId = state.chatRoomId;
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: ChatPage(userInfo: widget.userInfo, userId: widget.userId, chatId: chatId, jumpToTab: widget.jumpToTab,),
            withNavBar: true,
          );
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => ChatPage(userInfo: userInfo, userId: userId, chatId: chatId,),
          //   ),
          // );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0.0,
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
                  icon: SvgPicture.asset("assets/icons/Star Circle.svg"),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: SubscriptionPage(userInfo: widget.userInfo, userId: widget.userId, productList: widget.productList,),
                      withNavBar: true,
                    );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const SubscriptionPage(),
                    //   ),
                    // );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  right: 15,
                  // right: 10
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF0F0F0),
                ),
                child: IconButton(
                  icon: SvgPicture.asset("assets/icons/Hand Money.svg"),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DonatePage(userInfo: widget.userInfo, userId: widget.userId, productList: widget.productList,),
                      ),
                    );
                  },
                ),
              ),
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
                  icon: SvgPicture.asset("assets/icons/Settings.svg"),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    widget.jumpToTab(3);
                    // PersistentNavBarNavigator.pushNewScreen(
                    //   context,
                    //   screen: SettingsPage(userId: userId, controller: controller,),
                    //   withNavBar: true,
                    // );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => SettingsPage(userId: userId,),
                    //   ),
                    // );
                  },
                ),
              ),
            ],
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
                  widget.jumpToTab(0);
                  // Navigator.pop(context);
                },
              ),
            ),
            // toolbarHeight: 100,,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset("assets/icons/Dialog.svg"),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  textScaler: TextScaler.linear(1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  "Ще немає чатів",
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    // fontSize: MediaQuery.textScalerOf(context).scale(16)
                  )
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    textScaler: TextScaler.linear(1),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "Натисніть кнопку нижче, щоб його розпочати",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Color(0xFF7B7B7B),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      // fontSize: MediaQuery.textScalerOf(context).scale(14)
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.37,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color(0xFF212121),
                      foregroundColor: Colors.white,
                    ),
                    // 7hlUwyI2FpO6B6pAJaFJLSHi3Ed2
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.read<ChatBloc>().add(ChatRoomCreated(firstCompanionId: widget.userId));
                    },
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "Написати",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        // fontSize: MediaQuery.textScalerOf(context).scale(14)
                      )
                    )
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}