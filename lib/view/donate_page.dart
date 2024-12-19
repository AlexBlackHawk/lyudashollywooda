import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:lyudashollywooda/view/subscription_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../donate_bloc/donate_bloc.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key, required this.userInfo, required this.userId, required this.productList});

  final Map<String, dynamic> userInfo;
  final String userId;
  final List<Package> productList;

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {

  late FocusNode donateFocusNode;
  late FocusNode commentFocusNode;

  @override
  void initState() {
    super.initState();

    donateFocusNode = FocusNode();
    commentFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    donateFocusNode.dispose();
    commentFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonateBloc, DonateState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
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
              "Задонатити",
              style: TextStyle(
                fontFamily: "Inter",
                color: Color(0xFF212121),
                fontWeight: FontWeight.w600,
                fontSize: 16,
                // fontSize: MediaQuery.textScalerOf(context).scale(16),
              ),
            ),
            actions: [
              Container(
                width: MediaQuery.of(context).size.height * 0.0591,
                height: MediaQuery.of(context).size.height * 0.0591,
                margin: const EdgeInsets.only(
                  right: 10,
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
            ],
            centerTitle: true,
            // toolbarHeight: 100,,
          ),
          body: Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 25,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    top: 12,
                    right: 16,
                    bottom: 16
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFFD9D9D9)
                    )
                  ),
                  child: Text(
                    textScaler: TextScaler.linear(1),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    "Допоможіть нам покращити наші послуги та надати вам ще більше корисного контенту. Дякуємо за вашу підтримку!",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      // fontSize: MediaQuery.textScalerOf(context).scale(14),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Platform.isIOS ? Column(
                  children: [
                    Text(
                      "Оберіть суму, яку ви хочете задонатити",
                      textScaler: TextScaler.linear(1),
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        // fontSize: MediaQuery.textScalerOf(context).scale(14)
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      // scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      children: state.productList.values.map((value) {
                        return ChoiceChip(
                          selectedColor: Colors.white,
                          showCheckmark: false,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: state.chosenDonatePackage == value.lifetime ? Colors.black : const Color(0xFFD9D9D9)),
                          ),
                          label: Text(
                            textScaler: TextScaler.linear(1),
                            value.lifetime!.storeProduct.priceString,
                            overflow: TextOverflow.ellipsis,
                          ),
                          selected: state.chosenDonatePackage == value.lifetime,
                          onSelected: (newState) {
                            HapticFeedback.lightImpact();
                            context.read<DonateBloc>().add(DonatePackageChanged(package: value.lifetime!));
                          },
                        );
                      }
                     ).toList().cast(),
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
                        onPressed: state.chosenDonatePackage != null ? () {
                          HapticFeedback.lightImpact();
                          context.read<DonateBloc>().add(const DonatePackagePurchased());
                        } : null,
                        child: Text(
                          textScaler: TextScaler.linear(1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "Продовжити",
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            // fontSize: MediaQuery.textScalerOf(context).scale(14)
                          ),
                        )
                      ),
                    )
                  ],
                ) : Expanded(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "Сума донату",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DonateSum(),
                      SizedBox(
                        height: 20,
                      ),
                      DonateInputField(donateFocusNode: donateFocusNode,),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          HundredChip(),
                          ThreeHundredChip(),
                          FiveHundredChip(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommentTextField(commentFocusNode: commentFocusNode,),
                      const SizedBox(
                        height: 10,
                      ),
                      ContinueButton(donateFocusNode: donateFocusNode, commentFocusNode: commentFocusNode,),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      const CancelButton(),
                    ],
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

class DonateSum extends StatelessWidget {
  const DonateSum({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonateBloc, DonateState>(
      builder: (context, state) {
        return Text(
          textScaler: TextScaler.linear(1),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          state.sum.toString(),
          style: TextStyle(
            fontFamily: "Inter",
            color: Color(0xFF212121),
            fontWeight: FontWeight.w600,
            fontSize: 32,
            // fontSize: MediaQuery.textScalerOf(context).scale(32),
          ),
        );
      },
    );
  }
}

class DonateInputField extends StatefulWidget {
  const DonateInputField({super.key, required this.donateFocusNode});

  final FocusNode donateFocusNode;

  @override
  State<DonateInputField> createState() => _DonateInputFieldState();
}

class _DonateInputFieldState extends State<DonateInputField> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonateBloc, DonateState>(
      builder: (context, state) {
        return TextField(
          onTap: () {
            HapticFeedback.lightImpact();
          },
          focusNode: widget.donateFocusNode,
          onTapOutside: (value) {
            HapticFeedback.lightImpact();
            widget.donateFocusNode.unfocus();
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                // color: Colors.green
                color: (state.sum != "") ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
              ),
              borderRadius: BorderRadius.circular(30)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                // color: Colors.green
                color: (state.sum != "") ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
              ),
              borderRadius: BorderRadius.circular(30)
            ),
            hintText: "Введіть розмір донату",
            hintStyle: TextStyle(
              fontFamily: "Inter",
              color: Color(0xFF7B7B7B),
              fontSize: 14,
              // fontSize: MediaQuery.textScalerOf(context).scale(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          onChanged: (value) {
            context.read<DonateBloc>().add(DonateSumChanged(newSum: value));
          },
        );
      },
    );
  }
}

class HundredChip extends StatelessWidget {
  const HundredChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonateBloc, DonateState>(
      builder: (context, state) {
        return ChoiceChip(
          backgroundColor: state.chipChosen == 1 ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color(0xFFD9D9D9)
            ),
            borderRadius: BorderRadius.circular(30)
          ),
          label: Text(
            textScaler: TextScaler.linear(1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            "\$100",
            style: TextStyle(
              fontFamily: "Inter",
              color: state.chipChosen == 1 ? Colors.white : Colors.black,
              fontSize: 14,
              // fontSize: MediaQuery.textScalerOf(context).scale(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: false,
          onSelected: (bool selected) {
            HapticFeedback.lightImpact();
            context.read<DonateBloc>().add(const DonateFirstChipPressed());
          },
        );
      },
    );
  }
}

class ThreeHundredChip extends StatelessWidget {
  const ThreeHundredChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonateBloc, DonateState>(
      builder: (context, state) {
        return ChoiceChip(
          backgroundColor: state.chipChosen == 2 ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color(0xFFD9D9D9)
            ),
            borderRadius: BorderRadius.circular(30)
          ),
          label: Text(
            textScaler: TextScaler.linear(1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            "\$300",
            style: TextStyle(
              fontFamily: "Inter",
              color: state.chipChosen == 2 ? Colors.white : Colors.black,
              fontSize: 14,
              // fontSize: MediaQuery.textScalerOf(context).scale(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: false,
          onSelected: (bool selected) {
            HapticFeedback.lightImpact();
            context.read<DonateBloc>().add(const DonateSecondChipPressed());
          },
        );
      },
    );
  }
}

class FiveHundredChip extends StatelessWidget {
  const FiveHundredChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonateBloc, DonateState>(
      builder: (context, state) {
        return ChoiceChip(
          backgroundColor: state.chipChosen == 3 ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color(0xFFD9D9D9)
            ),
            borderRadius: BorderRadius.circular(30)
          ),
          label: Text(
            textScaler: TextScaler.linear(1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            "\$500",
            style: TextStyle(
              fontFamily: "Inter",
              color: state.chipChosen == 3 ? Colors.white : Colors.black,
              fontSize: 14,
              // fontSize: MediaQuery.textScalerOf(context).scale(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: false,
          onSelected: (bool selected) {
            HapticFeedback.lightImpact();
            context.read<DonateBloc>().add(const DonateThirdChipPressed());
          },
        );
      },
    );
  }
}

class CommentTextField extends StatefulWidget {
  const CommentTextField({super.key, required this.commentFocusNode});

  final FocusNode commentFocusNode;

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonateBloc, DonateState>(
      builder: (context, state) {
        return Flexible(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.065,
            child: TextField(
              onTap: () {
                HapticFeedback.lightImpact();
              },
              focusNode: widget.commentFocusNode,
              onTapOutside: (value) {
                HapticFeedback.lightImpact();
                widget.commentFocusNode.unfocus();
              },
              onChanged: (value) {
                context.read<DonateBloc>().add(DonateCommentChanged(comment: value));
              },
              expands: true,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFD9D9D9),
                  ),
                  borderRadius: BorderRadius.circular(30)
                ),
                hintText: "Коментар (необовʼязково)",
                hintStyle: TextStyle(
                  fontFamily: "Inter",
                  color: Color(0xFF7B7B7B),
                  fontSize: 14,
                  // fontSize: MediaQuery.textScalerOf(context).scale(14),
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ContinueButton extends StatefulWidget {
  const ContinueButton({super.key, required this.donateFocusNode, required this.commentFocusNode});

  final FocusNode donateFocusNode;
  final FocusNode commentFocusNode;

  @override
  State<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonateBloc, DonateState>(
      builder: (context, state) {
        return SizedBox(
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
            onPressed: state.sum != "" ? () {
              HapticFeedback.lightImpact();
              widget.donateFocusNode.unfocus();
              widget.commentFocusNode.unfocus();
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: UsePaypal(
                  // sandboxMode: true,
                  clientId: "Abv_IIj64RL556Ve5oNjlo6niYcVSTwnIcmFAINPyA0cO2GLXK13d9m1Hg3MGwhfv1PaPZjqz9zYZ9Ec",
                  secretKey: "EMfGfDbgRYEIkigMrtd8x0qQc2-Lkawsvd5Qm9ginUkFYD0mjPnPDZbxPYbpxY04TXbt8ZHcyDjxlCwC",
                  returnURL: "https://samplesite.com/return",
                  cancelURL: "https://samplesite.com/cancel",
                  transactions: [
                    {
                      "amount": {
                        "total": state.sum,
                        "currency": "USD",
                        "details": {
                          "subtotal": state.sum,
                          "shipping": '0',
                          "shipping_discount": 0
                        }
                      },
                      "description": state.comment,
                      // "payment_options": {
                      //   "allowed_payment_method":
                      //       "INSTANT_FUNDING_SOURCE"
                      // },
                      "item_list": {
                        "items": [
                          {
                            "name": "Donate",
                            "quantity": 1,
                            "price": state.sum,
                            "currency": "USD"
                          }
                        ],
                      }
                    }
                  ],
                  note: "Contact us for any questions on your order.",
                  onSuccess: (Map params) async {
                    // ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                    //   SnackBar(
                    //     backgroundColor: Colors.black,
                    //     elevation: 7,
                    //     content: Center(child: Text(
                    //       textScaler: TextScaler.linear(1),
                    //       textAlign: TextAlign.center,
                    //       "Дякую за ваш донат",
                    //       maxLines: 1,
                    //       overflow: TextOverflow.ellipsis,
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontFamily: "Inter",
                    //           fontWeight: FontWeight.w400,
                    //           fontSize: 12,
                    //           // fontSize: MediaQuery.textScalerOf(context).scale(12)
                    //       ),)
                    //     ),
                    //     duration: const Duration(seconds: 5),
                    //     width: MediaQuery.of(context).size.width * 0.7,
                    //     behavior: SnackBarBehavior.floating,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(30.0),
                    //     ),
                    //   ),
                    // );
                  },
                  onError: (error) {
                    // ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                    //   SnackBar(
                    //     backgroundColor: Colors.black,
                    //     elevation: 7,
                    //     content: Center(child: Text(
                    //       textScaler: TextScaler.linear(1),
                    //       textAlign: TextAlign.center,
                    //       "Виникла помилка під час надсилання донату",
                    //       maxLines: 1,
                    //       overflow: TextOverflow.ellipsis,
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontFamily: "Inter",
                    //           fontWeight: FontWeight.w400,
                    //           fontSize: 12,
                    //           // fontSize: MediaQuery.textScalerOf(context).scale(12)
                    //       ),
                    //     )),
                    //     duration: const Duration(seconds: 5),
                    //     width: MediaQuery.of(context).size.width * 0.7,
                    //     behavior: SnackBarBehavior.floating,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(30.0),
                    //     ),
                    //   ),
                    // );
                  },
                  onCancel: (params) {}
                ),
                withNavBar: false,
              );
            } : null,
            child: Text(
              textScaler: TextScaler.linear(1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              "Продовжити",
              style: TextStyle(
                fontFamily: "Inter",
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                // fontSize: MediaQuery.textScalerOf(context).scale(14)
              ),
            )
          ),
        );
      },
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonateBloc, DonateState>(
      builder: (context, state) {
        return TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            context.read<DonateBloc>().add(const DonateCancelled());
          },
          child: Text(
            textScaler: TextScaler.linear(1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            "Скасувати",
            style: TextStyle(
              fontFamily: "Inter",
              color: Color(0xFF212121),
              fontWeight: FontWeight.w500,
              fontSize: 14,
              // fontSize: MediaQuery.textScalerOf(context).scale(14)
            ),
          ),
        );
      },
    );
  }
}