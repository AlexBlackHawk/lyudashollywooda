import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyudashollywooda/view/subscription_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../user_bloc/user_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionsSettingsPage extends StatelessWidget {
  const SubscriptionsSettingsPage({super.key, required this.userInfo, required this.userId});

  final Map<String, dynamic> userInfo;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
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
                  Navigator.pop(context);
                },
              ),
            ),
            title: Text(
              textScaler: TextScaler.linear(1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              "Підписка",
              style: TextStyle(
                fontFamily: "Inter",
                color: Color(0xFF212121),
                fontWeight: FontWeight.w600,
                fontSize: 16,
                // fontSize: MediaQuery.textScalerOf(context).scale(16),
              ),
            ),
            centerTitle: true,
            // toolbarHeight: 100,,
          ),
          body: Container(
            margin: EdgeInsets.only(
              left: 8,
              right: 8,
              top: MediaQuery.of(context).size.height * 0.02463,
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Color(0xFFD9D9D9),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textScaler: TextScaler.linear(1),
                        // textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "ID підписки",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Color(0xFF7B7B7B),
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          textScaler: TextScaler.linear(1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          state.appUserID,
                          style: const TextStyle(
                            fontFamily: "Inter",
                            color: Color(0xFF212121),
                            fontSize: 16,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color(0xFFD9D9D9),
                ),
                const SizedBox(
                  height: 10,
                ),
                // -------------------------------------------------------------
                Container(
                  height: MediaQuery.of(context).size.height * 0.065,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Color(0xFFD9D9D9)
                      )
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "ID користувача",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Color(0xFF7B7B7B),
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          textScaler: TextScaler.linear(1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          state.userId,
                          style: const TextStyle(
                            fontFamily: "Inter",
                            color: Color(0xFF212121),
                            // fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // -------------------------------------------------------------
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.065,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Color(0xFFD9D9D9)
                    )
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "Статус підписки",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Color(0xFF7B7B7B),
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        state.entitlementIsActive ? "Активна" : "Не активна",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Color(0xFF212121),
                          fontSize: 16,
                          // fontSize: MediaQuery.textScalerOf(context).scale(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Visibility(
                //   visible: !state.entitlementIsActive,
                //   child: const SizedBox(
                //     height: 10,
                //   ),
                // ),
                // Visibility(
                //   visible: !state.entitlementIsActive,
                //   child: TextField(
                //     onChanged: (value) {},
                //     decoration: const InputDecoration(
                //         enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //                 color: Color(0xFFD9D9D9)
                //             )
                //         )
                //     ),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.049261,
                  ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.065,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        )
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(WidgetState.pressed)) return Colors.black;
                        return Colors.white;
                      }),
                      backgroundColor: WidgetStateProperty.all(Colors.black),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(WidgetState.pressed)) return Colors.white;
                        return null;
                      }),
                    ),
                    onPressed: () async {
                      HapticFeedback.lightImpact();
                      if (state.entitlementIsActive) {
                        if (state.customerInfo!.managementURL == null) {
                          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.black,
                              elevation: 7,
                              content: Center(
                                child: Text(
                                  textScaler: TextScaler.linear(1),
                                  textAlign: TextAlign.center,
                                  'Наразі у вас немає активної підписки',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  // fontSize: MediaQuery.textScalerOf(context).scale(12)
                                  ),
                                )
                              ),
                              duration: const Duration(seconds: 5),
                              width: MediaQuery.of(context).size.width * 0.7,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          );
                        }
                        else {
                          await launchUrl(
                            Uri.parse(state.customerInfo!.managementURL!),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      }
                      else {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: SubscriptionPage(userInfo: userInfo, userId: userId, productList: state.productList,),
                          withNavBar: true,
                        );
                      }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const SubscriptionPage()),
                      // );
                    },
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      state.entitlementIsActive ? "Скасувати підписку" : "Оформити підписку",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        // fontSize: MediaQuery.textScalerOf(context).scale(14)
                      ),
                    )
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: state.entitlementIsActive,
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: SubscriptionPage(userInfo: userInfo, userId: userId, productList: state.productList,),
                        withNavBar: true,
                      );
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => const SubscriptionPage(),
                      //   ),
                      // );
                    },
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "Всі тарифні плани",
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        // fontSize: MediaQuery.textScalerOf(context).scale(14)
                      ),
                    ),
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