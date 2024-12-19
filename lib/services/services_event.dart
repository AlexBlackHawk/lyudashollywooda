part of 'services_bloc.dart';

final class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => [];
}

final class ServicesNewPriceSet extends ServicesEvent {
  const ServicesNewPriceSet({required this.newPrice, required this.service});

  final String newPrice;
  final String service;

  @override
  List<Object> get props => [newPrice, service];
}

final class ServicesServicePriceChanged extends ServicesEvent {
  const ServicesServicePriceChanged({required this.service});

  final String service;

  @override
  List<Object> get props => [service];
}

final class ServicesServiceDeleted extends ServicesEvent {
  const ServicesServiceDeleted({required this.service});

  final String service;

  @override
  List<Object> get props => [service];
}

final class ServicesFetched extends ServicesEvent {
  const ServicesFetched();
}

final class ServicesServiceActivated extends ServicesEvent {
  const ServicesServiceActivated({required this.service});

  final String service;

  @override
  List<Object> get props => [service];
}

final class ServicesServiceDeactivated extends ServicesEvent {
  const ServicesServiceDeactivated({required this.service});

  final String service;

  @override
  List<Object> get props => [service];
}

final class ServicesDirectMessageChanged extends ServicesEvent {
  const ServicesDirectMessageChanged({required this.directMessage});

  final String directMessage;

  @override
  List<Object> get props => [directMessage];
}

final class ServicesBirthdayPersonNameChanged extends ServicesEvent {
  const ServicesBirthdayPersonNameChanged({required this.birthdayPersonName});

  final String birthdayPersonName;

  @override
  List<Object> get props => [birthdayPersonName];
}

final class ServicesBirthdayWishesChanged extends ServicesEvent {
  const ServicesBirthdayWishesChanged({required this.birthdayWishes});

  final String birthdayWishes;

  @override
  List<Object> get props => [birthdayWishes];
}

final class ServicesDirectMessageVideoChanged extends ServicesEvent {
  const ServicesDirectMessageVideoChanged({required this.directMessageVideo, required this.request});

  final String directMessageVideo;
  final String request;

  @override
  List<Object> get props => [directMessageVideo, request];
}

final class ServicesBirthdayGreetingsVideoChanged extends ServicesEvent {
  const ServicesBirthdayGreetingsVideoChanged({required this.birthdayGreetingsVideo, required this.request});

  final String birthdayGreetingsVideo;
  final String request;

  @override
  List<Object> get props => [birthdayGreetingsVideo, request];
}

final class ServicesDirectMessageVideoSent extends ServicesEvent {
  const ServicesDirectMessageVideoSent({required this.userEmail, required this.request});

  final String userEmail;
  final String request;

  @override
  List<Object> get props => [userEmail, request];
}

final class ServicesBirthdayGreetingsVideoSent extends ServicesEvent {
  const ServicesBirthdayGreetingsVideoSent({required this.userEmail, required this.request});

  final String userEmail;
  final String request;

  @override
  List<Object> get props => [userEmail, request];
}

final class ServicesNewRequestCreated extends ServicesEvent {
  const ServicesNewRequestCreated({required this.serviceId, required this.userId, this.wishes = "", this.personName = "", this.directMessage = ""});

  final String serviceId;
  final String userId;
  final String directMessage;
  final String personName;
  final String wishes;

  @override
  List<Object> get props => [serviceId, userId, directMessage, personName, wishes];
}