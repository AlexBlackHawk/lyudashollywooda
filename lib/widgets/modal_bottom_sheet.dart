import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../subscriptions/subscriptions_bloc.dart';
import 'package:intl/intl.dart';
import '../user_bloc/user_bloc.dart';

class SubscriptionModalBottomSheet extends StatelessWidget {
  const SubscriptionModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscriptionsBloc(),
      child: BlocConsumer<UserBloc, UserState>(
        listenWhen: (previous, current) => previous.freeTrialStatus != current.freeTrialStatus && current.freeTrialStatus == FreeTrialStatus.success,
        listener: (context, state) => Navigator.of(context).pop(),
        builder: (context, userState) {
          return BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
            builder: (context, state) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.94,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      height: MediaQuery.of(context).size.height * 0.64,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        // color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        )),
                      child: Image.asset(
                        'assets/ModalBottomSheetPicture.png',
                          fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  FutureBuilder(
                                    future: Future.delayed(const Duration(seconds: 3)),
                                    builder: (context, snapshot) {
                                      return IconButton(
                                        iconSize: 32,
                                        onPressed: () {
                                          HapticFeedback.lightImpact();
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      );
                                    }
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.05,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              textScaler: TextScaler.linear(1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "Вітаю вас у моєму додатку!",
                              style: TextStyle(
                                fontFamily: "Inter",
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                // fontSize: MediaQuery.textScalerOf(context).scale(20),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                textScaler: TextScaler.linear(1),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                "Ми тут будемо ближче і тільки одиниці отримуватимуть унікальний та корисний контент! Вас чекають поради по розвитку та вихованню дітей, багато інформації про стиль та звісно я поділюсь сучасними методами розвитку Тік-ток та інстаграм для вашого майбутнього 😎",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4855,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.02,
                                    ),
                                    Text(
                                      textScaler: TextScaler.linear(1),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      Platform.isIOS ? "Насолоджуйтесь додатком без реклами для безперервної роботи." : "Оформіть підписку та користуйтесь додатком без реклами",
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.015,
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
                                              context.read<SubscriptionsBloc>().add(const SubscriptionsChosenSubscriptionChanged(subscriptionIndex: 0));},
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
                                                      text: Platform.isIOS ? userState.productList[0].storeProduct.priceString : "${NumberFormat.simpleCurrency(name: userState.productList[0].storeProduct.currencyCode).currencySymbol}${userState.productList[0].storeProduct.price.toString()}",
                                                      style: TextStyle(
                                                        fontFamily: "Inter",
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 24,
                                                        // fontSize: MediaQuery.textScalerOf(context).scale(24)
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: "/місяць",
                                                      style: TextStyle(
                                                        fontFamily: "Inter",
                                                        color: Color(0xFF7B7B7B),
                                                        fontSize: 16,
                                                        // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                                        fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
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
                                                    borderRadius: BorderRadius.circular(10),
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
                                                      text: Platform.isIOS ? userState.productList[1].storeProduct.priceString : "${NumberFormat.simpleCurrency(name: userState.productList[1].storeProduct.currencyCode).currencySymbol}${userState.productList[1].storeProduct.price.toString()}",
                                                      style: TextStyle(
                                                        fontFamily: "Inter",
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 24,
                                                        // fontSize: MediaQuery.textScalerOf(context).scale(24)
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '/рік',
                                                      style: TextStyle(
                                                        fontFamily: "Inter",
                                                        color: Color(0xFF7B7B7B),
                                                        fontSize: 16,
                                                        // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                                        fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
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
                                                    borderRadius: BorderRadius.circular(10),
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
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.015,
                                    ),
                                    // BlocSelector<UserBloc, UserState, bool>(
                                    //   selector: (state) => state.freeTrial,
                                    //   builder: (context, freeTrial) {
                                    //     return Visibility(
                                    //       visible: !freeTrial,
                                    //       child: TextButton(
                                    //         onPressed: () {
                                    //           context.read<UserBloc>().add(const StartFreeTrial());
                                    //         },
                                    //         child: const Text(
                                    //           textScaler: TextScaler.linear(1),
                                    //           maxLines: 1,
                                    //           overflow: TextOverflow.ellipsis,
                                    //           "Почати пробний період на 3 дні",
                                    //           style: TextStyle(
                                    //             color: Colors.black,
                                    //             fontSize: 14,
                                    //             // fontFamily: "Inter",
                                    //             fontWeight: FontWeight.w500,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     );
                                    //   },
                                    // ),
                                    // SizedBox(
                                    //   height: MediaQuery.of(context).size.height * 0.001,
                                    // ),
                                    // const Text(
                                    //   textScaler: TextScaler.linear(1),
                                    //   maxLines: 2,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   "Після закінчення пробного періоду, ви знову будете бачити рекламу, а також ви більше не зможете оформити його знову",
                                    //   style: TextStyle(
                                    //     color: Colors.black,
                                    //     fontSize: 12,
                                    //     fontFamily: "Inter",
                                    //     fontWeight: FontWeight.w400,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: MediaQuery.of(context).size.height * 0.015,
                                    // ),
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
                                          Navigator.of(context).pop();
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
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.015,
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
                                      state.chosenSubscription != -1 ? "Перші 3 дні безкоштовно, далі ${Platform.isIOS ? userState.productList[state.chosenSubscription].storeProduct.priceString : "${NumberFormat.simpleCurrency(name: userState.productList[state.chosenSubscription].storeProduct.currencyCode).currencySymbol}${userState.productList[state.chosenSubscription].storeProduct.price.toString()}"} за ${state.chosenSubscription == 0 ? "місяць" : "рік"}. Скасувати можна в будь який час." : "",
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.02,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          textScaler: TextScaler.linear(1),
                                          // maxLines: 1,
                                          // overflow: TextOverflow.ellipsis,
                                          "Умови використання | Політика конфіденційності | Вже придбали?",
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            color: Colors.black,
                                            // fontSize: 10,
                                            // fontSize: MediaQuery.textScalerOf(context).scale(10),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text(
                                      //       maxLines: 1,
                                      //       overflow: TextOverflow.ellipsis,
                                      //       "Умови використання",
                                      //       style: TextStyle(
                                      //         fontFamily: "Inter",
                                      //         color: Colors.black,
                                      //         fontSize: 10,
                                      //         fontWeight: FontWeight.w500,
                                      //       ),
                                      //     ),
                                      //     Text(
                                      //       maxLines: 1,
                                      //       overflow: TextOverflow.ellipsis,
                                      //       "|",
                                      //       style: TextStyle(
                                      //         fontFamily: "Inter",
                                      //         color: Colors.black,
                                      //         fontSize: 10,
                                      //         fontWeight: FontWeight.w500,
                                      //       ),
                                      //     ),
                                      //     Text(
                                      //       maxLines: 1,
                                      //       overflow: TextOverflow.ellipsis,
                                      //       "Політика конфіденційності",
                                      //       style: TextStyle(
                                      //         fontFamily: "Inter",
                                      //         color: Colors.black,
                                      //         fontSize: 10,
                                      //         fontWeight: FontWeight.w500,
                                      //       ),
                                      //     ),
                                      //     Text(
                                      //       maxLines: 1,
                                      //       overflow: TextOverflow.ellipsis,
                                      //       "|",
                                      //       style: TextStyle(
                                      //         fontFamily: "Inter",
                                      //         color: Colors.black,
                                      //         fontSize: 10,
                                      //         fontWeight: FontWeight.w500,
                                      //       ),
                                      //     ),
                                      //     Text(
                                      //       maxLines: 1,
                                      //       overflow: TextOverflow.ellipsis,
                                      //       "Вже придбали?",
                                      //       style: TextStyle(
                                      //         fontFamily: "Inter",
                                      //         color: Colors.black,
                                      //         fontSize: 10,
                                      //         fontWeight: FontWeight.w500,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }
}
