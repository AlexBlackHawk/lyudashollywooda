import 'dart:io';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyudashollywooda/view/user_view.dart';

import '../user_bloc/user_bloc.dart';
import '../widgets/modal_bottom_sheet.dart';
import 'admin_view.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        switch (state.userInfo["role"]) {
          case "user":
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserView(),
              ),
            );
            if (state.showAds && state.showDialog) {
              showModalBottomSheet(
                constraints: const BoxConstraints(
                  maxWidth: double.infinity,
                ),
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                enableDrag: false,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                builder: (BuildContext context) {
                  // context.read<UserBloc>().add(const DismissModalSheet());
                  return const SubscriptionModalBottomSheet();
                  // return SubscriptionModal(disposableCross: disposableCross, state: state);
                },
              );
              // context.read<UserBloc>().add(const DismissModalSheet());
            }
            break;
          case "admin":
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AdminView(),
              ),
            );
            break;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/LogInBackgroundImage.png'
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).size.height * 0.07,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GoogleAuthButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.read<UserBloc>().add(const UserLogInWithGoogle());
                      },
                      text: "Продовжити з Google",
                      style: AuthButtonStyle(
                        textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                          fontFamily: "Inter",
                        ),
                        buttonColor: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.0625,
                        width: double.infinity,
                        borderRadius: 50,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    Platform.isAndroid ? FacebookAuthButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.read<UserBloc>().add(const UserLogInWithFacebook());
                      },
                      text: "Продовжити з Facebook",
                      style: AuthButtonStyle(
                        textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                          fontFamily: "Inter",
                        ),
                        iconColor: Colors.blue,
                        buttonColor: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.0625,
                        width: double.infinity,
                        borderRadius: 50,
                      ),
                    ) : AppleAuthButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.read<UserBloc>().add(const UserLogInWithApple());
                      },
                      text: "Продовжити з Apple",
                      style: AuthButtonStyle(
                        textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                          fontFamily: "Inter",
                        ),
                        iconColor: Colors.black,
                        buttonColor: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.0625,
                        width: double.infinity,
                        borderRadius: 50,
                      ),
                    ),

                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.0625,
                    //   width: double.infinity,
                    //   child: Platform.isAndroid ? Expanded(
                    //     child: SignInButton(
                    //       text: "Продовжити з Facebook",
                    //       shape: const RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(20),
                    //         ),
                    //       ),
                    //       Buttons.facebookNew,
                    //       onPressed: () {
                    //         HapticFeedback.lightImpact();
                    //         context.read<UserBloc>().add(const LogInFacebook());
                    //       },
                    //     ),
                    //   ) : SignInButton(
                    //     text: "Продовжити з Apple",
                    //     shape: const RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(20),
                    //       ),
                    //     ),
                    //     Buttons.apple,
                    //     onPressed: () {
                    //       HapticFeedback.lightImpact();
                    //       context.read<UserBloc>().add(const LogInApple());
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
