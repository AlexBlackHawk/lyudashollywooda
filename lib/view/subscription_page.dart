import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyudashollywooda/view/terms_of_use_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import '../subscriptions/subscriptions_bloc.dart';
import '../user_bloc/user_bloc.dart';
import 'package:intl/intl.dart';
import 'donate_page.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key, required this.userInfo, required this.userId, required this.productList});

  final Map<String, dynamic> userInfo;
  final String userId;
  final List<Package> productList;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscriptionsBloc(),
      child: BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
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
              actions: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 10,
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
                          builder: (context) => DonatePage(userInfo: userInfo, userId: userId, productList: productList,),
                        ),
                      );
                    },
                  ),
                ),
              ],
              // toolbarHeight: 100,,
            ),
            body: Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
                bottom: MediaQuery.of(context).size.height * 0.12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        Platform.isIOS ? "Підписка дозволяє користувачам користуватися додатком без перерв на рекламу. У той час як користувачі, які не підписалися, бачитимуть рекламу під час використання, підписники можуть отримати доступ до повного контенту та функцій додатку без реклами, що забезпечує більш плавне та приємне користування." : "Ви зможете користуватися додатком без реклами.",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.77,
                            height: MediaQuery.of(context).size.height * 0.09852,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: (state.chosenSubscription == 0) ? Colors.black : const Color(0xFFD9D9D9),
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                context.read<SubscriptionsBloc>().add(const SubscriptionsChosenSubscriptionChanged(subscriptionIndex: 0));
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: 'Базовий \n',
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Colors.black,
                                      fontSize: 16,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(16)
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: Platform.isIOS ? productList[0].storeProduct.priceString :  "${NumberFormat.simpleCurrency(name: productList[0].storeProduct.currencyCode).currencySymbol}${productList[0].storeProduct.price.toString()}",
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 24,
                                          // fontSize: MediaQuery.textScalerOf(context).scale(24)
                                        )
                                      ),
                                      TextSpan(
                                        text: ' /місяць',
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          color: Color(0xFF7B7B7B),
                                          fontSize: 16,
                                          // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                          fontWeight: FontWeight.normal
                                        )
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.09852,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: (state.chosenSubscription == 0) ? Colors.black : const Color(0xFFD9D9D9),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  backgroundColor: (state.chosenSubscription == 0) ? Colors.black : Colors.white,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  context.read<SubscriptionsBloc>().add(const SubscriptionsChosenSubscriptionChanged(subscriptionIndex: 0));
                                },
                                child: Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.1,
                                    height: MediaQuery.of(context).size.height * 0.04,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: (state.chosenSubscription == 0) ? Colors.black : const Color(0xFFD9D9D9),
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: (state.chosenSubscription == 0) ? const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.black,
                                      ),
                                    ) : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.77,
                            height: MediaQuery.of(context).size.height * 0.09852,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: (state.chosenSubscription == 1) ? Colors.black : const Color(0xFFD9D9D9)
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                context.read<SubscriptionsBloc>().add(const SubscriptionsChosenSubscriptionChanged(subscriptionIndex: 1));
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: 'Преміум \n',
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Colors.black,
                                      fontSize: 16,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(16)
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: Platform.isIOS ? productList[1].storeProduct.priceString : "${NumberFormat.simpleCurrency(name: productList[1].storeProduct.currencyCode).currencySymbol}${productList[1].storeProduct.price.toString()}",
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 24,
                                          // fontSize: MediaQuery.textScalerOf(context).scale(24)
                                        )
                                      ),
                                      TextSpan(
                                        text: ' /рік',
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          color: Color(0xFF7B7B7B),
                                          fontSize: 16,
                                          // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                          fontWeight: FontWeight.normal
                                        )
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.09852,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: (state.chosenSubscription == 1) ? Colors.black : const Color(0xFFD9D9D9),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  backgroundColor: (state.chosenSubscription == 1) ? Colors.black : Colors.white,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  context.read<SubscriptionsBloc>().add(const SubscriptionsChosenSubscriptionChanged(subscriptionIndex: 1));
                                },
                                child: Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.1,
                                    height: MediaQuery.of(context).size.height * 0.04,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: (state.chosenSubscription == 1) ? Colors.black : const Color(0xFFD9D9D9),
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: (state.chosenSubscription == 1) ? const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.black,
                                      ),
                                    ) : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.065,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: const Color(0xFF212121),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: (state.chosenSubscription == 0 || state.chosenSubscription == 1) ? () {
                            HapticFeedback.lightImpact();
                            context.read<UserBloc>().add(UserSubscriptionPackagePurchased(subscriptionIndex: state.chosenSubscription));
                          } : null,
                          child: Text(
                            textScaler: TextScaler.linear(1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "Оформити підписку",
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              // fontSize: MediaQuery.textScalerOf(context).scale(14)
                            ),
                          )
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14)
                        ),
                        textScaler: TextScaler.linear(1),
                        state.chosenSubscription != -1 ? "Перші 3 дні безкоштовно, далі ${NumberFormat.simpleCurrency(name: productList[0].storeProduct.currencyCode).currencySymbol}${productList[0].storeProduct.price.toString()} за ${state.chosenSubscription == 0 ? "місяць" : "рік"}. Скасувати можна в будь який час." : "",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.065,
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            context.read<UserBloc>().add(const UserPurchasesRestored());
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xFFD9D9D9)
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(
                            textScaler: TextScaler.linear(1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "Відновити покупки",
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: RichText(
                      textScaler: TextScaler.linear(1),
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Оформлюючи підписку, Ви автоматично погоджуєтесь з ",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14)
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()..onTap = () {
                              HapticFeedback.lightImpact();
                              // PersistentNavBarNavigator.pushNewScreen(
                              //   context,
                              //   screen: TermsOfUsePage(),
                              //   withNavBar: false,
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TermsOfUsePage()),
                              );
                            },
                            text: "Умовами корристування",
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: Color(0xFF212121),
                              // fontWeight: FontWeight.bold,
                              fontSize: 14,
                              // fontSize: MediaQuery.textScalerOf(context).scale(14)
                            ),
                          )
                        ]
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
