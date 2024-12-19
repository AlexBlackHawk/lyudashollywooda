import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:lyudashollywooda/donate_bloc/donate_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../services/services_bloc.dart';

class AdditionalServicesPage extends StatefulWidget {
  const AdditionalServicesPage({super.key, required this.userInfo, required this.userId, required this.jumpToTab});

  final Map<String, dynamic> userInfo;
  final String userId;
  final void Function(int) jumpToTab;

  @override
  State<AdditionalServicesPage> createState() => _AdditionalServicesPageState();
}

class _AdditionalServicesPageState extends State<AdditionalServicesPage> {
  final Map<String, String> servicesPhoto = <String, String>{
    "Консультація по стилю": "assets/services_images/img.png",
    "Розбір гардеробу": "assets/services_images/img_1.png",
    "Поради": "assets/services_images/img_2.png",
    "Годинна консультація по блогу": "assets/services_images/img_3.png",
    "Донат на розвиток застосунку": "assets/services_images/img_4.png",
    "Привітання з днем народження": "assets/services_images/party-popper.png",
    "Прямі повідомлення": "assets/services_images/exclamation-mark.png",
  };

  late FocusNode messageFocusNode;
  late FocusNode nameFocusNode;
  late FocusNode wishesFocusNode;
  late FocusNode donateFocusNode;

  @override
  void initState() {
    super.initState();

    messageFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    wishesFocusNode = FocusNode();
    donateFocusNode = FocusNode();
  }

  @override
  void dispose() {
    messageFocusNode.dispose();
    nameFocusNode.dispose();
    wishesFocusNode.dispose();
    donateFocusNode.dispose();

    super.dispose();
  }

  // final TextEditingController directMessageController = TextEditingController();
  //
  // final TextEditingController personNameController = TextEditingController();
  //
  // final TextEditingController wishesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServicesBloc>(
      create: (context) => ServicesBloc()..add(ServicesFetched()),
      child: BlocConsumer<ServicesBloc, ServicesState>(
        // listenWhen: (previous, current) => previous.operationPerformed != current.operationPerformed,
        listener: (context, state) {
          if (state.operationPerformed) {
            // ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
            //   SnackBar(
            //     backgroundColor: Colors.black,
            //     elevation: 7,
            //     content: Center(child: Text(
            //       textScaler: TextScaler.linear(1),
            //       textAlign: TextAlign.center,
            //       state.message,
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
            // // Navigator.pop(context);
            // context.read<ServicesBloc>().add(const ChangeOperationPerformed());
          }
          // ----------------------------------------------------------
          // if (state.goToCardPage) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => const ServicesCardForm(),
          //     ),
          //   );
          //   context.read<ServicesBloc>().add(const CancelGoToCardPage());
          // }
          // if (state.operationPerformed) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       backgroundColor: Colors.white.withOpacity(0.3),
          //       elevation: 7,
          //       content: Center(child: Text(textAlign: TextAlign.center, state.message, style: const TextStyle(fontFamily: "Inter", fontWeight: FontWeight.w400, fontSize: 12),)),
          //       duration: const Duration(seconds: 5),
          //       width: MediaQuery.of(context).size.width * 0.7,
          //       behavior: SnackBarBehavior.floating,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(30.0),
          //       ),
          //     ),
          //   );
          //   context.read<ServicesBloc>().add(const ChangeOperationPerformed());
          // }
        },
        builder: (context, state) {
          return Scaffold(
            // resizeToAvoidBottomInset: false,
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
                    widget.jumpToTab(0);
                    // Navigator.pop(context);
                  },
                ),
              ),
              title: Text(
                textScaler: TextScaler.linear(1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                "Додаткові послуги",
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
            body: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: state.services,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        'Сталася помилка'
                      )
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        'Завантаження...'
                      )
                    );
                  }
                  if (snapshot.hasData) {
                    // return TextField(
                    //   textAlignVertical: TextAlignVertical.top,
                    //   controller: directMessageController,
                    //   expands: true,
                    //   maxLines: null,
                    //   decoration: InputDecoration(
                    //     hintText: "Ваше повідомлення",
                    //     border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(12)
                    //     ),
                    //   ),
                    // );
                    return ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (BuildContext listContext, int index) => const SizedBox(height: 10),
                      itemBuilder: (BuildContext listContext, int index) {
                        String id = snapshot.data!.docs[index].id;
                        Map<String, dynamic> data = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                        return Column(
                          children: [
                            Visibility(
                              visible: data["available"],
                              child: (id == "2vHnAI3VkzfdFF4m9Iri") ? ExpansionTile(
                                onExpansionChanged: (isOpened) {
                                  HapticFeedback.lightImpact();
                                },
                                leading: Image.asset(servicesPhoto[data["name"]]!, width: 24, height: 24,),
                                title: Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  data["name"],
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                  ),
                                ),
                                childrenPadding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                  left: 10,
                                  right: 10,
                                ),
                                collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xFF212121)
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xFF212121)
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                                children: [
                                  Text(
                                    textScaler: TextScaler.linear(1),
                                    // maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                    data["description"],
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontSize: 14,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Platform.isIOS ? BlocBuilder<DonateBloc, DonateState>(
                                    builder: (context, state) {
                                      return Column(
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
                                                  context.read<DonateBloc>().add(DonatePackageChanged(package: value.lifetime!));
                                                },
                                              );
                                            }).toList().cast(),
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
                                      );
                                    },
                                  ) : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        textScaler: TextScaler.linear(1),
                                        // maxLines: 1,
                                        // overflow: TextOverflow.ellipsis,
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
                                      ServiceDonateDonateSum(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ServiceDonateInputField(donateFocusNode: donateFocusNode,),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ServiceDonateHundredChip(),
                                          ServiceDonateThreeHundredChip(),
                                          ServiceDonateFiveHundredChip(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ServiceDonateContinueButton(donateFocusNode: donateFocusNode,),
                                    ],
                                  ),
                                ],
                              ) : (id == "B4LUGvFkR2MovFJ2r5Go") ? ExpansionTile(
                                onExpansionChanged: (isOpened) {
                                  HapticFeedback.lightImpact();
                                },
                                leading: Image.asset(servicesPhoto[data["name"]]!, width: 24, height: 24,),
                                title: Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  data["name"],
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                  ),
                                ),
                                childrenPadding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                  left: 10,
                                  right: 10,
                                ),
                                collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xFF212121)
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xFF212121)
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                                children: [
                                  Text(
                                    textScaler: TextScaler.linear(1),
                                    // maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                    data["description"],
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontSize: 14,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  // const DirectMessageTextField(),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.23,
                                    width: double.infinity,
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(12)
                                    // ),
                                    child: TextField(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                      },
                                      focusNode: messageFocusNode,
                                      onTapOutside: (value) {
                                        HapticFeedback.lightImpact();
                                        nameFocusNode.unfocus();
                                      },
                                      textAlignVertical: TextAlignVertical.top,
                                      expands: true,
                                      onChanged: (value) {
                                        context.read<ServicesBloc>().add(ServicesDirectMessageChanged(directMessage: value));
                                      },
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: "Ваше повідомлення",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12)
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    textScaler: TextScaler.linear(1),
                                    // maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                    "\$${data["price"]}",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontSize: 20,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(20),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  // ContinueOrderServiceButton(userId: userId, serviceId: id, price: data["price"].toString(),),
                                  // SendDirectMessageButton(userId: userId, serviceId: id,),
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.05,
                                    child: ElevatedButton(
                                      onPressed: state.directMessage != "" ? () {
                                        HapticFeedback.lightImpact();
                                        messageFocusNode.unfocus();
                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: UsePaypal(
                                            sandboxMode: true,
                                            clientId: "Abv_IIj64RL556Ve5oNjlo6niYcVSTwnIcmFAINPyA0cO2GLXK13d9m1Hg3MGwhfv1PaPZjqz9zYZ9Ec",
                                            secretKey: "EMfGfDbgRYEIkigMrtd8x0qQc2-Lkawsvd5Qm9ginUkFYD0mjPnPDZbxPYbpxY04TXbt8ZHcyDjxlCwC",
                                            returnURL: "https://samplesite.com/return",
                                            cancelURL: "https://samplesite.com/cancel",
                                            transactions: [
                                              {
                                                "amount": {
                                                  "total": data["price"].toString(),
                                                  "currency": "USD",
                                                  "details": {
                                                    "subtotal": data["price"].toString(),
                                                    "shipping": '0',
                                                    "shipping_discount": 0
                                                  }
                                                },
                                                "description": data["name"],
                                                // "payment_options": {
                                                //   "allowed_payment_method":
                                                //       "INSTANT_FUNDING_SOURCE"
                                                // },
                                                "item_list": {
                                                  "items": [
                                                    {
                                                      "name": "Donate",
                                                      "quantity": 1,
                                                      "price": data["price"].toString(),
                                                      "currency": "USD"
                                                    }
                                                  ],
                                                }
                                              }
                                            ],
                                            note: "Contact us for any questions on your order.",
                                            onSuccess: (Map params) async {
                                              context.read<ServicesBloc>().add(ServicesNewRequestCreated(userId: widget.userId, serviceId: id, directMessage: state.directMessage));
                                            },
                                            onError: (error) {
                                              ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.black,
                                                  elevation: 7,
                                                  content: Center(
                                                    child: Text(
                                                      textScaler: TextScaler.linear(1),
                                                      textAlign: TextAlign.center,
                                                      "Виникла помилка під час оплати",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Inter",
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 12,
                                                        // fontSize: MediaQuery.textScalerOf(context).scale(12)
                                                      ),
                                                    ),
                                                  ),
                                                  duration: const Duration(seconds: 5),
                                                  width: MediaQuery.of(context).size.width * 0.7,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                  ),
                                                ),
                                              );
                                            },
                                            onCancel: (params) {}
                                          ),
                                          withNavBar: false,
                                        );
                                      } : null,
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30)
                                        ),
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        textScaler: TextScaler.linear(1),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        "Надіслати запит"
                                      ),
                                    ),
                                  )
                                ],
                              ) : (id == "eVTJdbWXKSMFDjynX7jI") ? ExpansionTile(
                                onExpansionChanged: (isOpened) {
                                  HapticFeedback.lightImpact();
                                },
                                leading: Image.asset(servicesPhoto[data["name"]]!, width: 24, height: 24,),
                                title: Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  data["name"],
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                  ),
                                ),
                                childrenPadding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                  left: 10,
                                  right: 10,
                                ),
                                collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xFF212121)
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xFF212121)
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                                children: [
                                  Text(
                                    textScaler: TextScaler.linear(1),
                                    // maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                    data["description"],
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontSize: 14,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  // const BirthdayPersonNameTextField(),
                                  TextField(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                    },
                                    focusNode: nameFocusNode,
                                    // expands: true,
                                    // maxLines: null,
                                    onTapOutside: (value) {
                                      HapticFeedback.lightImpact();
                                      nameFocusNode.unfocus();
                                    },
                                    onChanged: (value) {
                                      context.read<ServicesBloc>().add(ServicesBirthdayPersonNameChanged(birthdayPersonName: value));
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Імʼя особи, яку поздоровити",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  // const BirthdayWishesTextField(),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.23,
                                    width: double.infinity,
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(12)
                                    // ),
                                    child: TextField(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                      },
                                      focusNode: wishesFocusNode,
                                      onTapOutside: (value) {
                                        HapticFeedback.lightImpact();
                                        nameFocusNode.unfocus();
                                      },
                                      textAlignVertical: TextAlignVertical.top,
                                      onChanged: (value) {
                                        context.read<ServicesBloc>().add(ServicesBirthdayWishesChanged(birthdayWishes: value));
                                      },
                                      expands: true,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: "Побажання",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12)
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    textScaler: TextScaler.linear(1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    "\$${data["price"]}",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontSize: 20,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(20),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  // ContinueOrderServiceButton(userId: userId, serviceId: id, price: data["price"].toString(),),
                                  // OrderBirthdayGreetingsButton(userId: userId, serviceId: id,),
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.05,
                                    child: ElevatedButton(
                                      onPressed: (state.birthdayPersonName != "" && state.birthdayWishes != "") ? () {
                                        HapticFeedback.lightImpact();
                                        nameFocusNode.unfocus();
                                        wishesFocusNode.unfocus();
                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: UsePaypal(
                                            sandboxMode: true,
                                            clientId: "Abv_IIj64RL556Ve5oNjlo6niYcVSTwnIcmFAINPyA0cO2GLXK13d9m1Hg3MGwhfv1PaPZjqz9zYZ9Ec",
                                            secretKey: "EMfGfDbgRYEIkigMrtd8x0qQc2-Lkawsvd5Qm9ginUkFYD0mjPnPDZbxPYbpxY04TXbt8ZHcyDjxlCwC",
                                            returnURL: "https://samplesite.com/return",
                                            cancelURL: "https://samplesite.com/cancel",
                                            transactions: [
                                              {
                                                "amount": {
                                                  "total": data["price"].toString(),
                                                  "currency": "USD",
                                                  "details": {
                                                    "subtotal": data["price"].toString(),
                                                    "shipping": '0',
                                                    "shipping_discount": 0
                                                  }
                                                },
                                                "description": data["name"],
                                                // "payment_options": {
                                                //   "allowed_payment_method":
                                                //       "INSTANT_FUNDING_SOURCE"
                                                // },
                                                "item_list": {
                                                  "items": [
                                                    {
                                                      "name": "Donate",
                                                      "quantity": 1,
                                                      "price": data["price"].toString(),
                                                      "currency": "USD"
                                                    }
                                                  ],
                                                }
                                              }
                                            ],
                                            note: "Contact us for any questions on your order.",
                                            onSuccess: (Map params) async {
                                              context.read<ServicesBloc>().add(ServicesNewRequestCreated(userId: widget.userId, serviceId: id, personName: state.birthdayPersonName, wishes: state.birthdayWishes));
                                            },
                                            onError: (error) {
                                              ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.black,
                                                  elevation: 7,
                                                  content: Center(
                                                    child: Text(
                                                      textScaler: TextScaler.linear(1),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.center,
                                                      "Виникла помилка під час оплати",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Inter",
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 14,
                                                        // fontSize: MediaQuery.textScalerOf(context).scale(14)
                                                      ),
                                                    ),
                                                  ),
                                                  duration: const Duration(seconds: 5),
                                                  width: MediaQuery.of(context).size.width * 0.7,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                  ),
                                                ),
                                              );
                                            },
                                            onCancel: (params) {}
                                          ),
                                          withNavBar: false,
                                        );
                                      } : null,
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30)
                                        ),
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        textScaler: TextScaler.linear(1),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        "Надіслати запит"
                                      ),
                                    ),
                                  )
                                ],
                              ) : ExpansionTile(
                                onExpansionChanged: (isOpened) {
                                  HapticFeedback.lightImpact();
                                },
                                leading: Image.asset(servicesPhoto[data["name"]]!, width: 24, height: 24,),
                                title: Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  data["name"],
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                  ),
                                ),
                                childrenPadding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                  left: 10,
                                  right: 10,
                                ),
                                collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xFF212121)
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color(0xFF212121)
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                                children: [
                                  Text(
                                    textScaler: TextScaler.linear(1),
                                    // maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                    data["description"],
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontSize: 14,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    textScaler: TextScaler.linear(1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    "\$${data["price"]}",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontSize: 20,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(20),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  // ContinueOrderServiceButton(userId: userId, serviceId: id, price: data["price"].toString(),),
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
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: UsePaypal(
                                            sandboxMode: true,
                                            clientId: "Abv_IIj64RL556Ve5oNjlo6niYcVSTwnIcmFAINPyA0cO2GLXK13d9m1Hg3MGwhfv1PaPZjqz9zYZ9Ec",
                                            secretKey: "EMfGfDbgRYEIkigMrtd8x0qQc2-Lkawsvd5Qm9ginUkFYD0mjPnPDZbxPYbpxY04TXbt8ZHcyDjxlCwC",
                                            returnURL: "https://samplesite.com/return",
                                            cancelURL: "https://samplesite.com/cancel",
                                            transactions: [
                                              {
                                                "amount": {
                                                  "total": data["price"].toString(),
                                                  "currency": "USD",
                                                  "details": {
                                                    "subtotal": data["price"].toString(),
                                                    "shipping": '0',
                                                    "shipping_discount": 0
                                                  }
                                                },
                                                "description": data["name"],
                                                // "payment_options": {
                                                //   "allowed_payment_method":
                                                //       "INSTANT_FUNDING_SOURCE"
                                                // },
                                                "item_list": {
                                                  "items": [
                                                    {
                                                      "name": "Donate",
                                                      "quantity": 1,
                                                      "price": data["price"].toString(),
                                                      "currency": "USD"
                                                    }
                                                  ],
                                                }
                                              }
                                            ],
                                            note: "Contact us for any questions on your order.",
                                            onSuccess: (Map params) async {
                                              context.read<ServicesBloc>().add(ServicesNewRequestCreated(userId: widget.userId, serviceId: id));
                                            },
                                            onError: (error) {
                                              ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.black,
                                                  elevation: 7,
                                                  content: Center(child: Text(
                                                    textScaler: TextScaler.linear(1),
                                                    textAlign: TextAlign.center,
                                                    "Виникла помилка під час оплати",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "Inter",
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12,
                                                      // fontSize: MediaQuery.textScalerOf(context).scale(12)
                                                    ),
                                                  )),
                                                  duration: const Duration(seconds: 5),
                                                  width: MediaQuery.of(context).size.width * 0.7,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                  ),
                                                ),
                                              );
                                            },
                                            onCancel: (params) {}
                                          ),
                                          withNavBar: false,
                                        );
                                      },
                                      child: Text(
                                        textScaler: TextScaler.linear(1),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        "Замовити",
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
                                ],
                              ),
                            ),
                            Visibility(
                              visible: index == (snapshot.data!.docs.length - 1),
                              child: SizedBox(
                                height: MediaQuery.of(context).viewInsets.bottom == 0 ? MediaQuery.of(context).size.height * 0.12 : 0,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "Немає пропозицій",
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}


class ServiceDonateDonateSum extends StatelessWidget {
  const ServiceDonateDonateSum({super.key});

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

class ServiceDonateInputField extends StatefulWidget {
  const ServiceDonateInputField({super.key, required this.donateFocusNode});

  final FocusNode donateFocusNode;

  @override
  State<ServiceDonateInputField> createState() => _ServiceDonateInputFieldState();
}

class _ServiceDonateInputFieldState extends State<ServiceDonateInputField> {

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

class ServiceDonateHundredChip extends StatelessWidget {
  const ServiceDonateHundredChip({super.key});

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
            context.read<DonateBloc>().add(const DonateFirstChipPressed());
          },
        );
      },
    );
  }
}

class ServiceDonateThreeHundredChip extends StatelessWidget {
  const ServiceDonateThreeHundredChip({super.key});

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
            context.read<DonateBloc>().add(const DonateSecondChipPressed());
          },
        );
      },
    );
  }
}

class ServiceDonateFiveHundredChip extends StatelessWidget {
  const ServiceDonateFiveHundredChip({super.key});

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
            context.read<DonateBloc>().add(const DonateThirdChipPressed());
          },
        );
      },
    );
  }
}

class ServiceDonateContinueButton extends StatefulWidget {
  const ServiceDonateContinueButton({super.key, required this.donateFocusNode});

  final FocusNode donateFocusNode;

  @override
  State<ServiceDonateContinueButton> createState() => _ServiceDonateContinueButtonState();
}

class _ServiceDonateContinueButtonState extends State<ServiceDonateContinueButton> {
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
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: UsePaypal(
                  sandboxMode: true,
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
                    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.black,
                        elevation: 7,
                        content: Center(child: Text(
                          textScaler: TextScaler.linear(1),
                          textAlign: TextAlign.center,
                          "Дякую за ваш донат",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            // fontSize: MediaQuery.textScalerOf(context).scale(12)
                          ),
                        )),
                        duration: const Duration(seconds: 5),
                        width: MediaQuery.of(context).size.width * 0.7,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    );
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.black,
                        elevation: 7,
                        content: Center(child: Text(
                          textScaler: TextScaler.linear(1),
                          textAlign: TextAlign.center,
                          "Виникла помилка під час надсилання донату: $error",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            // fontSize: MediaQuery.textScalerOf(context).scale(12)
                          ),
                        )),
                        duration: const Duration(seconds: 5),
                        width: MediaQuery.of(context).size.width * 0.7,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    );
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

// class DirectMessageTextField extends StatelessWidget {
//   const DirectMessageTextField({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.23,
//       width: double.infinity,
//       // decoration: BoxDecoration(
//       //     borderRadius: BorderRadius.circular(12)
//       // ),
//       child: TextField(
//         textAlignVertical: TextAlignVertical.top,
//         // controller: queryTextFieldController,
//         onChanged: (value) {
//           context.read<ServicesBloc>().add(DirectMessageChanged(directMessage: value));
//         },
//         expands: true,
//         maxLines: null,
//         decoration: InputDecoration(
//           hintText: "Ваше повідомлення",
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12)
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SendDirectMessageButton extends StatelessWidget {
//   const SendDirectMessageButton({super.key, required this.userId, required this.serviceId});
//
//   final String userId;
//   final String serviceId;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ServicesBloc, ServicesState>(
//       builder: (context, state) {
//         return SizedBox(
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height * 0.05,
//           child: ElevatedButton(
//             onPressed: () {
//               context.read<ServicesBloc>().add(SendDirectMessageButtonClicked(userId: userId, serviceId: serviceId));
//             },
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(13)
//               ),
//               backgroundColor: Colors.black,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text(
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               "Надіслати"
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class BirthdayPersonNameTextField extends StatelessWidget {
//   const BirthdayPersonNameTextField({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ServicesBloc, ServicesState>(
//       builder: (context, state) {
//         return TextField(
//           // controller: queryTextFieldController,
//           onChanged: (value) {
//             context.read<ServicesBloc>().add(BirthdayPersonNameChanged(birthdayPersonName: value));
//           },
//           // expands: true,
//           // maxLines: null,
//           decoration: InputDecoration(
//             hintText: "Імʼя особи, яку поздоровити",
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12)
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class BirthdayWishesTextField extends StatelessWidget {
//   const BirthdayWishesTextField({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ServicesBloc, ServicesState>(
//       builder: (context, state) {
//         return SizedBox(
//           height: MediaQuery.of(context).size.height * 0.23,
//           width: double.infinity,
//           // decoration: BoxDecoration(
//           //     borderRadius: BorderRadius.circular(12)
//           // ),
//           child: TextField(
//             textAlignVertical: TextAlignVertical.top,
//             // controller: queryTextFieldController,
//             onChanged: (value) {
//               context.read<ServicesBloc>().add(BirthdayWishesChanged(birthdayWishes: value));
//             },
//             expands: true,
//             maxLines: null,
//             decoration: InputDecoration(
//               hintText: "Побажання",
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12)
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class OrderBirthdayGreetingsButton extends StatelessWidget {
//   const OrderBirthdayGreetingsButton({super.key, required this.userId, required this.serviceId});
//
//   final String userId;
//   final String serviceId;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ServicesBloc, ServicesState>(
//       builder: (context, state) {
//         return SizedBox(
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height * 0.05,
//           child: ElevatedButton(
//             onPressed: () {
//               context.read<ServicesBloc>().add(OrderBirthdayGreetingsButtonClicked(userId: userId, serviceId: serviceId));
//             },
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(13)
//               ),
//               backgroundColor: Colors.black,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text(
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               "Надіслати запит"
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


// class ContinueOrderServiceButton extends StatelessWidget {
//   const ContinueOrderServiceButton({super.key, required this.userId, required this.serviceId, required this.price});
//
//   final String userId;
//   final String serviceId;
//   final String price;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ServicesBloc, ServicesState>(
//       builder: (context, state) {
//         return SizedBox(
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height * 0.05,
//           child: ElevatedButton(
//             onPressed: () {
//               // context.read<ServicesBloc>().add(AddNewRequests(serviceId: serviceId, userId: userId, price: price));
//               context.read<ServicesBloc>().add(SetService(serviceId: serviceId, userId: userId, price: price));
//             },
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(13)
//               ),
//               backgroundColor: Colors.black,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text(
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               "Замовити"
//             ),
//           ),
//         );
//       },
//     );
//   }
// }