import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/services_bloc.dart';


class ServicesSettingsPage extends StatefulWidget {
  const ServicesSettingsPage({super.key, required this.userInfo, required this.userId});

  final Map<String, dynamic> userInfo;
  final String userId;

  @override
  State<ServicesSettingsPage> createState() => _ServicesSettingsPageState();
}

class _ServicesSettingsPageState extends State<ServicesSettingsPage> {
  // String removeZero(double money) {
  //   var response = money.toString();
  //   var parts = response.split(".");
  //
  //   if (parts.length > 1) {
  //     var decimalPoint = parts[1];
  //     if (decimalPoint == "0") {
  //       response = parts[0];
  //     } else if (decimalPoint == "00") {
  //       response = parts[0];
  //     }
  //   }
  //
  //   return response;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesBloc()..add(ServicesFetched()),
      child: BlocConsumer<ServicesBloc, ServicesState>(
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
            //           fontSize: 14,
            //           // fontSize: MediaQuery.textScalerOf(context).scale(14)
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
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor: Colors.white,
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
                "Налаштування",
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
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        String id = snapshot.data!.docs[index].id;
                        Map<String, dynamic> data = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                        return Column(
                          children: [
                            ExpansionTile(
                              onExpansionChanged: (isOpened) {
                                HapticFeedback.lightImpact();
                              },
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              leading: Text(
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
                              title: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  textScaler: TextScaler.linear(1),
                                  data["price"].toString(),
                                  // "\$${removeZero(data["price"].toDouble())}",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                  ),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.edit_rounded
                              ),
                              childrenPadding: const EdgeInsets.only(
                                top: 15,
                                bottom: 15,
                                left: 10,
                                right: 10,
                              ),
                              collapsedShape: Border(
                                top: BorderSide(
                                  color: Color(0xFF212121)
                                ),
                                bottom: index == (snapshot.data!.docs.length - 1) ? BorderSide(
                                  color: Color(0xFF212121)
                                ) : BorderSide.none,
                              ),
                              shape: Border(
                                top: BorderSide(
                                  color: Color(0xFF212121)
                                ),
                                bottom: index == (snapshot.data!.docs.length - 1) ? BorderSide(
                                  color: Color(0xFF212121)
                                ) : BorderSide.none,
                              ),
                              children: [
                                TextField(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                  },
                                  onChanged: (value) {
                                    context.read<ServicesBloc>().add(ServicesNewPriceSet(newPrice: value, service: id));
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: Container(
                                      margin: const EdgeInsets.only(
                                        right: 10,
                                        // right: 10
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (state.prices.containsKey(id) && state.prices[id] != null) ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.check,
                                          color: (state.prices.containsKey(id) && state.prices[id] != null) ? Colors.white : const Color(0xFF212121),
                                        ),
                                        onPressed: (state.prices.containsKey(id) && state.prices[id] != null) ? () {
                                          HapticFeedback.lightImpact();
                                          context.read<ServicesBloc>().add(ServicesServicePriceChanged(service: id));
                                        } : null,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        // color: Colors.green
                                        color: (state.prices.containsKey(id) && state.prices[id] != null) ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
                                      ),
                                      borderRadius: BorderRadius.circular(30)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        // color: Colors.green
                                        color: (state.prices.containsKey(id) && state.prices[id] != null) ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
                                      ),
                                      borderRadius: BorderRadius.circular(30)
                                    ),
                                    hintText: "Введіть нову ціну",
                                    hintStyle: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF7B7B7B),
                                      fontSize: 14,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                data["available"] ? TextButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    context.read<ServicesBloc>().add(ServicesServiceDeactivated(service: id));
                                  },
                                  child: Text(
                                    textScaler: TextScaler.linear(1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    "Деактивувати послугу",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontSize: 14,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ) : TextButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    context.read<ServicesBloc>().add(ServicesServiceActivated(service: id));
                                  },
                                  // state.services!.docs[index].id
                                  child: Text(
                                    textScaler: TextScaler.linear(1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    "Активувати послугу",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontSize: 14,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    context.read<ServicesBloc>().add(ServicesServiceDeleted(service: id));
                                  },
                                  child: Text(
                                    textScaler: TextScaler.linear(1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    "Видалити послугу",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontSize: 14,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: index == (snapshot.data!.docs.length - 1),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.12,
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
                      "Немає постів",
                    ),
                  );
                }
              ),
            ),
          );
        },
      ),
    );
  }
}
