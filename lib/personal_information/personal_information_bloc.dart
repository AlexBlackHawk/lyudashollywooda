import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

part 'personal_information_event.dart';
part 'personal_information_state.dart';

class PersonalInformationBloc extends Bloc<PersonalInformationEvent, PersonalInformationState> {
  PersonalInformationBloc() : super(const PersonalInformationState()) {
    on<PersonalInformationEmailChanged>(_onEmailChanged);
    on<PersonalInformationMobilePhoneChanged>(_onMobilePhoneChanged);
    on<PersonalInformationBirthdayChanged>(_onBirthdayChanged);
    on<PersonalInformationAvatarChanged>(_onAvatarChanged);
    on<PersonalInformationEmailUpdated>(_onEmailUpdated);
    on<PersonalInformationMobilePhoneUpdated>(_onMobilePhoneUpdated);
    on<PersonalInformationBirthdayUpdated>(_onBirthdayUpdated);
    on<PersonalInformationAvatarUpdated>(_onAvatarUpdated);
    on<PersonalInformationUserDataFetched>(_onUserDataFetched);
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final storageIns = FirebaseStorage.instance;

  void _onAvatarChanged(PersonalInformationAvatarChanged event, Emitter<PersonalInformationState> emit) async {
    final String avatar = event.avatar;
    emit(
        state.copyWith(
          chosenAvatar: avatar,
        )
    );
  }

  void _onAvatarUpdated(PersonalInformationAvatarUpdated event, Emitter<PersonalInformationState> emit) async {
    File file = File(state.chosenAvatar);
    String fileName = basename(file.path);
    String userId = event.userId;
    var snapshot = await storageIns.ref().child("Avatars/$userId/").child(fileName).putFile(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    db.collection("Users").doc(state.userId).update({"avatar": downloadUrl});
    emit(
        state.copyWith(
          avatar: downloadUrl,
          chosenAvatar: "",
          operationPerformed: true,
        )
    );
  }

  void _onUserDataFetched(PersonalInformationUserDataFetched event, Emitter<PersonalInformationState> emit) async {
    final userDoc = await db.collection("Users").doc(event.id).get();
    final userData = userDoc.data()!;
    if (userData["birthday"] == null) {
      emit(
        state.copyWith(
          userId: event.id,
          email: userData["email"],
          mobilePhone: userData["phone number"],
          birthday: null,
          avatar: userData["avatar"],
        ),
      );
    }
    else {
      Timestamp userBirthdayTimestamp = userData["birthday"];
      DateTime userBirthdayDatetime = userBirthdayTimestamp.toDate();
      emit(
        state.copyWith(
          userId: event.id,
          email: userData["email"],
          mobilePhone: userData["phone number"],
          birthday: userBirthdayDatetime,
          avatar: userData["avatar"],
        ),
      );
    }
  }

  void _onEmailChanged(PersonalInformationEmailChanged event, Emitter<PersonalInformationState> emit) async {
    final String email = event.email;
    emit(
        state.copyWith(
          enteredEmail: email,
        )
    );
  }

  void _onMobilePhoneChanged(PersonalInformationMobilePhoneChanged event, Emitter<PersonalInformationState> emit) async {
    final String mobilePhone = event.mobilePhone;
    emit(
        state.copyWith(
          enteredMobilePhone: mobilePhone,
        )
    );
  }

  void _onBirthdayChanged(PersonalInformationBirthdayChanged event, Emitter<PersonalInformationState> emit) async {
    final String birthday = event.birthday;
    emit(
        state.copyWith(
          chosenBirthday: birthday,
        )
    );
  }

  void _onEmailUpdated(PersonalInformationEmailUpdated event, Emitter<PersonalInformationState> emit) async {
    db.collection("Users").doc(state.userId).update({"email": state.enteredEmail});
    emit(
        state.copyWith(
          email: state.enteredEmail,
          enteredEmail: "",
          operationPerformed: true,
        )
    );
  }

  void _onMobilePhoneUpdated(PersonalInformationMobilePhoneUpdated event, Emitter<PersonalInformationState> emit) async {
    db.collection("Users").doc(state.userId).update({"phone number": state.enteredMobilePhone});
    emit(
        state.copyWith(
          mobilePhone: state.enteredMobilePhone,
          enteredMobilePhone: "",
          operationPerformed: true,
        )
    );
  }

  void _onBirthdayUpdated(PersonalInformationBirthdayUpdated event, Emitter<PersonalInformationState> emit) async {
    final date = DateFormat("dd.MM.yyyy").parse(state.chosenBirthday);
    db.collection("Users").doc(state.userId).update({"birthday": Timestamp.fromDate(date)});
    emit(
        state.copyWith(
          birthday: date,
          chosenBirthday: "",
          operationPerformed: true,
        )
    );
  }
}
