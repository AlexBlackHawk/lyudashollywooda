import 'dart:io';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lyudashollywooda/personal_information/personal_information_bloc.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../user_bloc/user_bloc.dart';
import 'log_in_page.dart';


class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key, required this.userId});

  final String userId;

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  TextEditingController datePickerController = TextEditingController();

  late FocusNode emailFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode birthdayFocusNode;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    birthdayFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    birthdayFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalInformationBloc>(
      create: (context) => PersonalInformationBloc()..add(PersonalInformationUserDataFetched(id: widget.userId)),
      child: BlocConsumer<PersonalInformationBloc, PersonalInformationState>(
        listener: (context, state) {
          if (state.operationPerformed) {
            // ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
            //   SnackBar(
            //     backgroundColor: Colors.black,
            //     elevation: 7,
            //     content: Center(child: Text(
            //       textAlign: TextAlign.center,
            //       state.message,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: const TextStyle(color: Colors.white, fontFamily: "Inter", fontWeight: FontWeight.w400, fontSize: 12),)),
            //     duration: const Duration(seconds: 5),
            //     width: MediaQuery.of(context).size.width * 0.7,
            //     behavior: SnackBarBehavior.floating,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30.0),
            //     ),
            //   ),
            // );
            // context.read<PersonalInformationBloc>().add(const ChangeOperationPerformed());
          }
        },
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
                "Особиста інформація",
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
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "Контактна інформація",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        // fontSize: MediaQuery.textScalerOf(context).scale(16),
                        // fontWeight: FontWeight.w600
                      ),
                    ),
                    Visibility(
                      visible: Platform.isIOS,
                      child: const SizedBox(
                        height: 10,
                      ),
                    ),
                    Visibility(
                      visible: Platform.isIOS,
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            HapticFeedback.lightImpact();
                            final XFile? pickedFile = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null && context.mounted) {
                              context.read<PersonalInformationBloc>().add(PersonalInformationAvatarChanged(avatar: pickedFile.path));
                            }
                          },
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.height * 0.15,
                            backgroundImage: state.chosenAvatar != "" ? AssetImage(state.chosenAvatar) : NetworkImage(state.avatar) as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: Platform.isIOS,
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    Visibility(
                      visible: Platform.isIOS,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.065,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: const Color(0xFF212121),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: state.chosenAvatar != "" ? () {
                            HapticFeedback.lightImpact();
                            context.read<PersonalInformationBloc>().add(PersonalInformationAvatarUpdated(userId: widget.userId));
                          } : null,
                          child: Text(
                            textScaler: TextScaler.linear(1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "Зберегти",
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: Color(0xFF212121),
                              fontSize: 14,
                              // fontSize: MediaQuery.textScalerOf(context).scale(14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Color(0xFFD9D9D9),
                    ),
                    // ---------------------------------------------------------
                    ExpansionTile(
                      onExpansionChanged: (isOpened) {
                        HapticFeedback.lightImpact();
                      },
                      shape: Border(
                        top: BorderSide.none,
                        bottom: BorderSide.none,
                      ),
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      leading: SvgPicture.asset("assets/icons/BNIMessages.svg", colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),),
                      title: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        state.email,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_down
                      ),
                      children: [
                        TextField(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          focusNode: emailFocusNode,
                          onTapOutside: (value) {
                            HapticFeedback.lightImpact();
                            emailFocusNode.unfocus();
                          },
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            context.read<PersonalInformationBloc>().add(PersonalInformationEmailChanged(email: value));
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                // color: Colors.green
                                color: (state.enteredEmail != "") ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
                              ),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                // color: Colors.green
                                color: (state.enteredEmail != "") ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
                              ),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            hintText: "Введіть нову електронну адресу",
                            hintStyle: TextStyle(
                              fontFamily: "Inter",
                              color: Color(0xFF7B7B7B),
                              fontSize: 14,
                              // fontSize: MediaQuery.textScalerOf(context).scale(14),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.065,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: const Color(0xFF212121),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.enteredEmail) ? () {
                              HapticFeedback.lightImpact();
                              emailFocusNode.unfocus();
                              context.read<PersonalInformationBloc>().add(const PersonalInformationEmailUpdated());
                            } : null,
                            child: Text(
                              textScaler: TextScaler.linear(1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "Зберегти",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 14,
                                // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ---------------------------------------------------------
                    const Divider(
                      color: Color(0xFFD9D9D9),
                    ),
                    ExpansionTile(
                      onExpansionChanged: (isOpened) {
                        HapticFeedback.lightImpact();
                      },
                      shape: Border(
                        top: BorderSide.none,
                        bottom: BorderSide.none,
                      ),
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      leading: SvgPicture.asset("assets/icons/iPhone.svg"),
                      title: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        state.mobilePhone,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                        ),
                      ),
                      trailing: const Icon(
                          Icons.keyboard_arrow_down
                      ),
                      children: [
                        TextField(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          focusNode: phoneFocusNode,
                          onTapOutside: (value) {
                            HapticFeedback.lightImpact();
                            phoneFocusNode.unfocus();
                          },
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            context.read<PersonalInformationBloc>().add(PersonalInformationMobilePhoneChanged(mobilePhone: value));
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                // color: Colors.green
                                color: (state.enteredMobilePhone != "") ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
                              ),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                // color: Colors.green
                                color: (state.enteredMobilePhone != "") ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
                              ),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            hintText: "Введіть новий номер телефону",
                            hintStyle: TextStyle(
                              fontFamily: "Inter",
                              color: Color(0xFF7B7B7B),
                              fontSize: 14,
                              // fontSize: MediaQuery.textScalerOf(context).scale(14),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.065,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: const Color(0xFF212121),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: RegExp(r'^(?:\+1)?\s?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$').hasMatch(state.enteredMobilePhone) ? () {
                              HapticFeedback.lightImpact();
                              phoneFocusNode.unfocus();
                              context.read<PersonalInformationBloc>().add(const PersonalInformationMobilePhoneUpdated());
                            } : null,
                            child: Text(
                              textScaler: TextScaler.linear(1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "Зберегти",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 14,
                                // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color(0xFFD9D9D9),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "Дата народження",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        // fontSize: MediaQuery.textScalerOf(context).scale(16),
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ExpansionTile(
                      onExpansionChanged: (isOpened) {
                        HapticFeedback.lightImpact();
                      },
                      shape: Border(
                        top: BorderSide.none,
                        bottom: BorderSide.none,
                      ),
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      leading: SvgPicture.asset("assets/icons/Calendar.svg"),
                      title: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        state.birthday == null ? "" : DateFormat('dd.MM.yyyy').format(state.birthday!),
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          // fontSize: MediaQuery.textScalerOf(context).scale(14),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_down
                      ),
                      children: [
                        TextField(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          focusNode: birthdayFocusNode,
                          onTapOutside: (value) {
                            HapticFeedback.lightImpact();
                            birthdayFocusNode.unfocus();
                          },
                          controller: datePickerController,
                          // readOnly: true,
                          onChanged: (value) {
                            context.read<PersonalInformationBloc>().add(PersonalInformationBirthdayChanged(birthday: value));
                          },
                          // onTap: () async {
                          //   DateTime? pickedDate = await showDatePicker(
                          //     context: context,
                          //     lastDate: DateTime.now(),
                          //     firstDate: DateTime(1900),
                          //     initialDate: DateTime.now(),
                          //     initialEntryMode: DatePickerEntryMode.calendar,
                          //   );
                          //   if (pickedDate == null) return;
                          //   context.read<PersonalInformationBloc>().add(BirthdayChanged(birthday: pickedDate));
                          //   datePickerController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                          // },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                            DateTextFormatter(),
                          ],
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                // color: Colors.green
                                color: (state.chosenBirthday != "") ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
                              ),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                // color: Colors.green
                                color: (state.chosenBirthday != "") ? const Color(0xFF212121) : const Color(0xFFD9D9D9),
                              ),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            hintText: "ДД.ММ.РРРР",
                            hintStyle: TextStyle(
                              fontFamily: "Inter",
                              color: Color(0xFF7B7B7B),
                              fontSize: 14,
                              // fontSize: MediaQuery.textScalerOf(context).scale(14),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.065,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: const Color(0xFF212121),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: (state.chosenBirthday != "") ? () {
                              HapticFeedback.lightImpact();
                              birthdayFocusNode.unfocus();
                              context.read<PersonalInformationBloc>().add(const PersonalInformationBirthdayUpdated());
                              datePickerController.clear();
                            } : null,
                            child: Text(
                              textScaler: TextScaler.linear(1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "Зберегти",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 14,
                                // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color(0xFFD9D9D9),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const LogInView(),
                          withNavBar: false,
                        );
                        context.read<UserBloc>().add(const UserLogoutPressed());
                        context.read<UserBloc>().add(const UserDBDeleted());
                        context.read<UserBloc>().add(const UserAuthDeleted());
                      },
                      child: Text(
                        "Видалити акаунт",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Inter",
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DateTextFormatter extends TextInputFormatter {
  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
    ) {
    String separator = '.';
    var text = _format(
      newValue.text,
      oldValue.text,
      separator,
    );

    return newValue.copyWith(
      text: text,
      selection: updateCursorPosition(
        oldValue,
        text,
      ),
    );
  }

  String _format(
      String value,
      String oldValue,
      String separator,
    ) {
    var isErasing = value.length < oldValue.length;
    var isComplete = value.length > _maxChars + 2;

    if (!isErasing && isComplete) {
      return oldValue;
    }

    value = value.replaceAll(separator, '');
    final result = <String>[];

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      result.add(value[i]);
      if ((i == 1 || i == 3) && i != value.length - 1) {
        result.add(separator);
      }
    }

    return result.join();
  }

  TextSelection updateCursorPosition(
      TextEditingValue oldValue,
      String text,
    ) {
    var endOffset = max(
      oldValue.text.length - oldValue.selection.end,
      0,
    );

    var selectionEnd = text.length - endOffset;

    return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
  }
}