part of 'personal_information_bloc.dart';

sealed class PersonalInformationEvent extends Equatable {
  const PersonalInformationEvent();

  @override
  List<Object> get props => [];
}

final class PersonalInformationEmailChanged extends PersonalInformationEvent {
  const PersonalInformationEmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

final class PersonalInformationMobilePhoneChanged extends PersonalInformationEvent {
  const PersonalInformationMobilePhoneChanged({required this.mobilePhone});

  final String mobilePhone;

  @override
  List<Object> get props => [mobilePhone];
}

final class PersonalInformationBirthdayChanged extends PersonalInformationEvent {
  const PersonalInformationBirthdayChanged({required this.birthday});

  final String birthday;

  @override
  List<Object> get props => [birthday];
}

final class PersonalInformationAvatarChanged extends PersonalInformationEvent {
  const PersonalInformationAvatarChanged({required this.avatar});

  final String avatar;

  @override
  List<Object> get props => [avatar];
}

final class PersonalInformationEmailUpdated extends PersonalInformationEvent {
  const PersonalInformationEmailUpdated();
}

final class PersonalInformationMobilePhoneUpdated extends PersonalInformationEvent {
  const PersonalInformationMobilePhoneUpdated();
}

final class PersonalInformationBirthdayUpdated extends PersonalInformationEvent {
  const PersonalInformationBirthdayUpdated();
}

final class PersonalInformationAvatarUpdated extends PersonalInformationEvent {
  const PersonalInformationAvatarUpdated({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}

final class PersonalInformationUserDataFetched extends PersonalInformationEvent {
  const PersonalInformationUserDataFetched({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
