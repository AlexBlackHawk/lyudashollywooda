part of 'services_bloc.dart';

enum RequestStatus {notAdded, inProgress, added}

final class ServicesState extends Equatable {
  const ServicesState({
    this.prices = const <String, double>{},
    this.operationPerformed = false,
    this.birthdayPersonName = "",
    this.birthdayWishes = "",
    this.directMessage = "",
    this.directMessageAnswers = const <String, String>{},
    this.birthdayRequestsAnswers = const <String, String>{},
    this.services,
  });

  final Map<String, double> prices;
  final bool operationPerformed;
  final String directMessage;
  final String birthdayPersonName;
  final String birthdayWishes;
  final Map<String, String> directMessageAnswers;
  final Map<String, String> birthdayRequestsAnswers;
  final Stream<QuerySnapshot>? services;


  ServicesState copyWith({
    Map<String, double>? prices,
    bool? operationPerformed,
    String? directMessage,
    String? birthdayPersonName,
    String? birthdayWishes,
    RequestStatus? status,
    Map<String, String>? directMessageAnswers,
    Map<String, String>? birthdayRequestsAnswers,
    Stream<QuerySnapshot>? services,
  }) {
    return ServicesState(
      prices: prices ?? this.prices,
      operationPerformed: operationPerformed ?? this.operationPerformed,
      directMessage: directMessage ?? this.directMessage,
      birthdayPersonName: birthdayPersonName ?? this.birthdayPersonName,
      birthdayWishes: birthdayWishes ?? this.birthdayWishes,
      directMessageAnswers: directMessageAnswers ?? this.directMessageAnswers,
      birthdayRequestsAnswers: birthdayRequestsAnswers ?? this.birthdayRequestsAnswers,
      services: services ?? this.services,
    );
  }

  @override
  List<Object?> get props => [
    prices,
    operationPerformed,
    directMessage,
    birthdayPersonName,
    birthdayWishes,
    directMessageAnswers,
    birthdayRequestsAnswers,
    services,
  ];
}
