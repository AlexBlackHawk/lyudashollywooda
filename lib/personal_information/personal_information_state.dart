part of 'personal_information_bloc.dart';

final class PersonalInformationState extends Equatable {
  const PersonalInformationState({
    this.userId = "",
    this.email = "",
    this.mobilePhone = "",
    this.birthday,
    this.avatar = "",
    this.enteredEmail = "",
    this.enteredMobilePhone = "",
    this.chosenBirthday = "",
    this.chosenAvatar = "",
    this.operationPerformed = false,
  });

  final String userId;  // ---------------------------------
  final String email;
  final String mobilePhone;
  final DateTime? birthday;
  final String avatar;
  final String enteredEmail;
  final String enteredMobilePhone;
  final String chosenBirthday;
  final String chosenAvatar;
  final bool operationPerformed;

  PersonalInformationState copyWith({
    String? userId,
    String? email,
    String? mobilePhone,
    DateTime? birthday,
    String? avatar,
    String? enteredEmail,
    String? enteredMobilePhone,
    String? chosenBirthday,
    String? chosenAvatar,
    bool? operationPerformed,
  }) {
    return PersonalInformationState(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      birthday: birthday ?? this.birthday,
      avatar: avatar ?? this.avatar,
      enteredEmail: enteredEmail ?? this.enteredEmail,
      enteredMobilePhone: enteredMobilePhone ?? this.enteredMobilePhone,
      chosenBirthday: chosenBirthday ?? this.chosenBirthday,
      chosenAvatar: chosenAvatar ?? this.chosenAvatar,
      operationPerformed: operationPerformed ?? this.operationPerformed,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    email,
    mobilePhone,
    birthday,
    avatar,
    enteredEmail,
    enteredMobilePhone,
    chosenBirthday,
    chosenAvatar,
    operationPerformed,
  ];
}

