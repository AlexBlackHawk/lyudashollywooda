import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lyudashollywooda/view/services_settings_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:video_player/video_player.dart';

import '../services/services_bloc.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key, required this.userInfo, required this.userId, required this.jumpToTab});

  final Map<String, dynamic> userInfo;
  final String userId;
  final void Function(int) jumpToTab;

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final Map<String, String> servicesPhoto = <String, String>{
    "Консультація по стилю": "assets/services_images/img.png",
    "Розбір гардеробу": "assets/services_images/img_1.png",
    "Поради": "assets/services_images/img_2.png",
    "Годинна консультація по блогу": "assets/services_images/img_3.png",
    "Донат на розвиток застосунку": "assets/services_images/img_4.png",
    "Привітання з днем народження": "assets/services_images/party-popper.png",
    "Прямі повідомлення": "assets/services_images/exclamation-mark.png",
  };

  Future<Map<String, dynamic>> getUserInfo(String userID) async {
    DocumentReference userDocument = FirebaseFirestore.instance.collection("Users").doc(userID);
    DocumentSnapshot snapshot = await userDocument.get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServicesBloc, ServicesState>(
      listener: (context, state) {
        if (state.operationPerformed) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: Colors.white.withOpacity(0.3),
          //     elevation: 7,
          //     content: Center(child: Text(
          //       textScaler: TextScaler.linear(1),
          //       textAlign: TextAlign.center,
          //       state.message,
          //       maxLines: 1,
          //       overflow: TextOverflow.ellipsis,
          //       style: TextStyle(
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
          // context.read<ServicesBloc>().add(const ChangeOperationPerformed());
        }
      },
      builder: (context, state) {
        // context.read<ServicesBloc>().add(const GetServices());
        // context.read<ServicesBloc>().add(const GetRequestsForServices());
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
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
              "Заявки",
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
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: ServicesSettingsPage(userInfo: widget.userInfo, userId: widget.userId,),
                      withNavBar: true,
                    );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ServicesSettingsPage(userInfo: userInfo, userId: userId,),
                    //   ),
                    // );
                  },
                ),
              ),
            ],
            // toolbarHeight: 100,,
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Services').snapshots(),
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
                  return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (BuildContext context, int servicesIndex) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (BuildContext context, int servicesIndex) {
                      String id = snapshot.data!.docs[servicesIndex].id;
                      Map<String, dynamic> data = snapshot.data!.docs[servicesIndex].data()! as Map<String, dynamic>;
                      return (id == "B4LUGvFkR2MovFJ2r5Go") ? Column(
                        children: [
                          ExpansionTile(
                            onExpansionChanged: (isOpened) {
                              HapticFeedback.lightImpact();
                            },
                            leading: Image.asset(servicesPhoto[data["name"]]!, width: 24, height: 24,),
                            title: Center(
                              child: Text(
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
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('Requests').where("service", isEqualTo: id).orderBy('time', descending: true).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text(
                                        maxLines: 1,
                                        textScaler: TextScaler.linear(1),
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
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      separatorBuilder: (BuildContext context, int subscribersIndex) {
                                        return const Divider(
                                          color: Color(0xFFD9D9D9),
                                        );
                                      },
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (BuildContext context, int subscribersIndex) {
                                        String id = snapshot.data!.docs[subscribersIndex].id;
                                        Map<String, dynamic> data = snapshot.data!.docs[subscribersIndex].data()! as Map<String, dynamic>;
                                        return FutureBuilder<Map<String, dynamic>>(
                                          future: getUserInfo(data["user"]),
                                          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                                            if (userSnapshot.hasError) {
                                              return const Text(
                                                textScaler: TextScaler.linear(1),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                "Error",
                                              );
                                            }
                                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                                              return const Text(
                                                textScaler: TextScaler.linear(1),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                "Завантаження"
                                              );
                                            }
                                            if (userSnapshot.hasData) {
                                              return ExpansionTile(
                                                onExpansionChanged: (isOpened) {
                                                  HapticFeedback.lightImpact();
                                                },
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    userSnapshot.data!["avatar"],
                                                  ),
                                                ),
                                                shape: Border(
                                                  top: BorderSide.none,
                                                  bottom: BorderSide.none,
                                                ),
                                                // collapsedShape: null,
                                                title: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: RichText(
                                                    textScaler: TextScaler.linear(1),
                                                    // maxLines: 3,
                                                    // overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      text: userSnapshot.data!["name"],
                                                      style: TextStyle(
                                                        fontFamily: "Inter",
                                                        color: Color(0xFF212121),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 14,
                                                        // fontSize: MediaQuery.textScalerOf(context).scale(14)
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: " залишив(-ла) заявку",
                                                          style: TextStyle(
                                                            fontFamily: "Inter",
                                                            color: Color(0xFF212121),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14,
                                                            // fontSize: MediaQuery.textScalerOf(context).scale(14)
                                                          ),
                                                        )
                                                      ]
                                                    ),
                                                  ),
                                                ),
                                                  // trailing: IconButton(
                                                  //   onPressed: () {},
                                                  //   icon: const Icon(
                                                  //     Icons.chevron_right,
                                                  //   ),
                                                  // ),
                                                children: [
                                                  const Text(
                                                    maxLines: 1,
                                                    textScaler: TextScaler.linear(1),
                                                    overflow: TextOverflow.ellipsis,
                                                    "Повідомлення"
                                                  ),
                                                  Text(
                                                    textScaler: TextScaler.linear(1),
                                                    data["direct message"]
                                                  ),
                                                  DirectMessageVideoPicker(request: id,),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  SendDirectMessageVideoButton(userEmail: widget.userInfo["email"], request: id,),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            }
                                            return const Text(
                                              maxLines: 1,
                                              textScaler: TextScaler.linear(1),
                                              overflow: TextOverflow.ellipsis,
                                              "No Data"
                                            );
                                          }
                                        );
                                      },
                                    );
                                  }
                                  return const Center(
                                    child: Text(
                                      textScaler: TextScaler.linear(1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      "Немає постів",
                                    ),
                                  );
                                }
                              )
                            ],
                          ),
                          Visibility(
                            visible: servicesIndex == (snapshot.data!.docs.length - 1),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.12,
                            ),
                          ),
                        ],
                      ) : (id == "eVTJdbWXKSMFDjynX7jI") ? Column(
                        children: [
                          ExpansionTile(
                            onExpansionChanged: (isOpened) {
                              HapticFeedback.lightImpact();
                            },
                            leading: Image.asset(servicesPhoto[data["name"]]!, width: 24, height: 24,),
                            title: Center(
                              child: Text(
                                textScaler: TextScaler.linear(1),
                                data["name"],
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  color: Color(0xFF212121),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                ),
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
                            // ------------
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('Requests').where("service", isEqualTo: id).orderBy('time', descending: true).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(child: Text(
                                      maxLines: 1,
                                      textScaler: TextScaler.linear(1),
                                      overflow: TextOverflow.ellipsis,
                                      'Сталася помилка'
                                    ));
                                  }
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: Text(
                                      maxLines: 1,
                                      textScaler: TextScaler.linear(1),
                                      overflow: TextOverflow.ellipsis,
                                      'Завантаження...'
                                    ));
                                  }
                                  if (snapshot.hasData) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      separatorBuilder: (BuildContext context, int subscribersIndex) {
                                        return const Divider(
                                          color: Color(0xFFD9D9D9),
                                        );
                                      },
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (BuildContext context, int subscribersIndex) {
                                        String id = snapshot.data!.docs[subscribersIndex].id;
                                        Map<String, dynamic> data = snapshot.data!.docs[subscribersIndex].data()! as Map<String, dynamic>;
                                        return FutureBuilder<Map<String, dynamic>>(
                                          future: getUserInfo(data["user"]),
                                          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                                            if (userSnapshot.hasError) {
                                              return const Text(
                                                maxLines: 1,
                                                textScaler: TextScaler.linear(1),
                                                overflow: TextOverflow.ellipsis,
                                                "Error"
                                              );
                                            }
                                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                                              return const Text(
                                                maxLines: 1,
                                                textScaler: TextScaler.linear(1),
                                                overflow: TextOverflow.ellipsis,
                                                "Завантаження"
                                              );
                                            }
                                            if (userSnapshot.hasData) {
                                              return ExpansionTile(
                                                onExpansionChanged: (isOpened) {
                                                  HapticFeedback.lightImpact();
                                                },
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    userSnapshot.data!["avatar"],
                                                  ),
                                                ),
                                                shape: Border(
                                                  top: BorderSide.none,
                                                  bottom: BorderSide.none,
                                                ),
                                                title: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: RichText(
                                                    textScaler: TextScaler.linear(1),
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      text: userSnapshot.data!["name"],
                                                      style: TextStyle(
                                                        fontFamily: "Inter",
                                                        color: Color(0xFF212121),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 14,
                                                        // fontSize: MediaQuery.textScalerOf(context).scale(14)
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: " залишив(-ла) заявку",
                                                          style: TextStyle(
                                                            fontFamily: "Inter",
                                                            color: Color(0xFF212121),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14,
                                                            // fontSize: MediaQuery.textScalerOf(context).scale(14)
                                                          ),
                                                        )
                                                      ]
                                                    ),
                                                  ),
                                                ),
                                                // trailing: IconButton(
                                                //   onPressed: () {},
                                                //   icon: const Icon(
                                                //     Icons.chevron_right,
                                                //   ),
                                                // ),
                                                children: [
                                                  const Text(
                                                    maxLines: 1,
                                                    textScaler: TextScaler.linear(1),
                                                    overflow: TextOverflow.ellipsis,
                                                    "Кого привітати",
                                                  ),
                                                  Text(
                                                    textScaler: TextScaler.linear(1),
                                                    data["birthday person name"]
                                                  ),
                                                  const Text(
                                                    maxLines: 1,
                                                    textScaler: TextScaler.linear(1),
                                                    overflow: TextOverflow.ellipsis,
                                                    "Побажання",
                                                  ),
                                                  Text(
                                                    textScaler: TextScaler.linear(1),
                                                      data["birthday wishes"]
                                                  ),
                                                  BirthdayGreetingsVideoPicker(request: id,),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  SendBirthdayGreetingsVideoButton(userEmail: widget.userInfo["email"], request: id,),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            }
                                            return const Text(
                                              maxLines: 1,
                                              textScaler: TextScaler.linear(1),
                                              overflow: TextOverflow.ellipsis,
                                              "No Data"
                                            );
                                          }
                                        );
                                      },
                                    );
                                  }
                                  return const Center(
                                    child: Text(
                                      maxLines: 1,
                                      textScaler: TextScaler.linear(1),
                                      overflow: TextOverflow.ellipsis,
                                      "Немає постів",
                                    ),
                                  );
                                }
                              )
                            ],
                            // ------------
                          ),
                          servicesIndex == (snapshot.data!.docs.length - 1) ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                          ) : Container(),
                        ],
                      ) : Visibility(
                        visible: data["name"] != "Донат на розвиток застосунку",
                        child: Column(
                          children: [
                            ExpansionTile(
                              onExpansionChanged: (isOpened) {
                                HapticFeedback.lightImpact();
                              },
                              leading: Image.asset(servicesPhoto[data["name"]]!, width: 24, height: 24,),
                              title: Center(
                                child: Text(
                                  textScaler: TextScaler.linear(1),
                                  data["name"],
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                  ),
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
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('Requests').where("service", isEqualTo: id).orderBy('time', descending: true).snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                        child: Text(
                                          maxLines: 1,
                                          textScaler: TextScaler.linear(1),
                                          overflow: TextOverflow.ellipsis,
                                          'Сталася помилка'
                                        )
                                      );
                                    }
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                        child: Text(
                                          maxLines: 1,
                                          textScaler: TextScaler.linear(1),
                                          overflow: TextOverflow.ellipsis,
                                          'Завантаження...'
                                        )
                                      );
                                    }
                                    if (snapshot.hasData) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        separatorBuilder: (BuildContext context, int subscribersIndex) {
                                          return const Divider(
                                            color: Color(0xFFD9D9D9),
                                          );
                                        },
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (BuildContext context, int subscribersIndex) {
                                          // String id = snapshot.data!.docs[subscribersIndex].id;
                                          Map<String, dynamic> data = snapshot.data!.docs[subscribersIndex].data()! as Map<String, dynamic>;
                                          return FutureBuilder<Map<String, dynamic>>(
                                            future: getUserInfo(data["user"]),
                                            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                                              if (userSnapshot.hasError) {
                                                return const Text(
                                                  maxLines: 1,
                                                  textScaler: TextScaler.linear(1),
                                                  overflow: TextOverflow.ellipsis,
                                                  "Error"
                                                );
                                              }
                                              if (userSnapshot.connectionState == ConnectionState.waiting) {
                                                return const Text(
                                                  maxLines: 1,
                                                  textScaler: TextScaler.linear(1),
                                                  overflow: TextOverflow.ellipsis,
                                                  "Завантаження"
                                                );
                                              }
                                              if (userSnapshot.hasData) {
                                                return ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                      userSnapshot.data!["avatar"],
                                                    ),
                                                  ),
                                                  title: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: RichText(
                                                      textScaler: TextScaler.linear(1),
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        text: userSnapshot.data!["name"],
                                                        style: TextStyle(
                                                          fontFamily: "Inter",
                                                          color: Color(0xFF212121),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 14,
                                                          // fontSize: MediaQuery.textScalerOf(context).scale(14)
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: " залишив(-ла) заявку",
                                                            style: TextStyle(
                                                              fontFamily: "Inter",
                                                              color: Color(0xFF212121),
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14,
                                                              // fontSize: MediaQuery.textScalerOf(context).scale(14)
                                                            ),
                                                          )
                                                        ]
                                                      ),
                                                    ),
                                                  ),
                                                  trailing: const Icon(
                                                    Icons.chevron_right,
                                                  ),
                                                );
                                              }
                                              return const Text(
                                                maxLines: 1,
                                                textScaler: TextScaler.linear(1),
                                                overflow: TextOverflow.ellipsis,
                                                "No Data"
                                              );
                                            }
                                          );
                                        },
                                      );
                                    }
                                    return const Center(
                                      child: Text(
                                        maxLines: 1,
                                        textScaler: TextScaler.linear(1),
                                        overflow: TextOverflow.ellipsis,
                                        "Немає постів",
                                      ),
                                    );
                                  }
                                )
                              ],
                            ),
                            Visibility(
                              visible: servicesIndex == (snapshot.data!.docs.length - 1),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.12,
                              ),
                            ),
                          ],
                        ),
                      );
                      /*return ExpansionTile(
                        title: Center(
                          child: Text(
                            data["name"],
                            style: const TextStyle(
                              fontFamily: "Inter",
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
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
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (BuildContext context, int subscribersIndex) {
                              return const Divider(
                                color: Color(0xFFD9D9D9),
                              );
                            },
                            // itemCount: 4,
                            itemCount: state.categoriesRequests[state.services!.docs[servicesIndex].id]!.length,
                            itemBuilder: (BuildContext context, int subscribersIndex) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    state.categoriesRequests[state.services!.docs[servicesIndex].id]![subscribersIndex]["avatar"],
                                  ),
                                ),
                                title: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: state.categoriesRequests[state.services!.docs[servicesIndex].id]![subscribersIndex]["name"],
                                      style: const TextStyle(
                                          fontFamily: "Inter",
                                          color: Color(0xFF212121),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14
                                      ),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: " залишила заявку",
                                          style: TextStyle(
                                              fontFamily: "Inter",
                                              color: Color(0xFF212121),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14
                                          ),
                                        )
                                      ]
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.chevron_right,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );*/
                    },
                  );
                }
                return const Center(
                  child: Text(
                    textScaler: TextScaler.linear(1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "Немає постів",
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class DirectMessageVideoPicker extends StatelessWidget {
  DirectMessageVideoPicker({super.key, required this.request});

  final String request;

  final ImagePicker picker = ImagePicker();
  // late XFile? video;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        return Container(
          height: 200,
          color: Colors.grey,
          child: GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();
              XFile? video = await picker.pickVideo(source: ImageSource.gallery);
              if (video != null && context.mounted) {
                context.read<ServicesBloc>().add(ServicesDirectMessageVideoChanged(directMessageVideo: video.path, request: request));
              }
            },
            child: state.directMessageAnswers.containsKey(request) ? AspectRatio(
              aspectRatio: 16/9,
              child: FlickVideoPlayer(
                flickManager: FlickManager(
                  videoPlayerController: VideoPlayerController.file(
                    File(state.directMessageAnswers[request]!),
                  ),
                ),
              ),
            ) : const Center(
              child: Icon(
                Icons.video_call,
                color: Colors.black,
                size: 40,
              )
            ),
          ),
        );
      },
    );
  }
}

class SendDirectMessageVideoButton extends StatelessWidget {
  const SendDirectMessageVideoButton({super.key, required this.userEmail, required this.request});

  final String userEmail;
  final String request;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.05,
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.read<ServicesBloc>().add(ServicesDirectMessageVideoSent(userEmail: userEmail, request: request));
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13)
              ),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              maxLines: 1,
              textScaler: TextScaler.linear(1),
              overflow: TextOverflow.ellipsis,
              "Надіслати запит"
            ),
          ),
        );
      },
    );
  }
}

class BirthdayGreetingsVideoPicker extends StatelessWidget {
  BirthdayGreetingsVideoPicker({super.key, required this.request});

  final String request;

  final ImagePicker picker = ImagePicker();
  // XFile? video;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        return Container(
          height: 200,
          color: Colors.grey,
          child: GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();
              XFile? video = await picker.pickVideo(source: ImageSource.gallery);
              if (video != null && context.mounted) {
                context.read<ServicesBloc>().add(ServicesBirthdayGreetingsVideoChanged(birthdayGreetingsVideo: video.path, request: request));
              }
            },
            child: state.birthdayRequestsAnswers.containsKey(request) ? AspectRatio(
              aspectRatio: 16/9,
              child: FlickVideoPlayer(
                flickManager: FlickManager(
                  videoPlayerController: VideoPlayerController.file(
                    File(state.birthdayRequestsAnswers[request]!),
                  ),
                ),
              ),
            ) : const Center(
              child: Icon(
                Icons.video_call,
                color: Colors.black,
                size: 40,
              )
            ),
          ),
        );
      },
    );
  }
}

class SendBirthdayGreetingsVideoButton extends StatelessWidget {
  const SendBirthdayGreetingsVideoButton({super.key, required this.userEmail, required this.request});

  final String userEmail;
  final String request;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.05,
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.read<ServicesBloc>().add(ServicesBirthdayGreetingsVideoSent(userEmail: userEmail, request: request));
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13)
              ),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              maxLines: 1,
              textScaler: TextScaler.linear(1),
              overflow: TextOverflow.ellipsis,
              "Надіслати",
            ),
          ),
        );
      },
    );
  }
}