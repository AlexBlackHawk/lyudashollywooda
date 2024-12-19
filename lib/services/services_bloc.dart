import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc() : super(const ServicesState()) {
    on<ServicesNewPriceSet>(_onNewPriceSet);
    on<ServicesServiceDeleted>(_onServiceDeleted);
    on<ServicesNewRequestCreated>(_onNewRequestCreated);
    on<ServicesServicePriceChanged>(_onServicePriceChanged);
    on<ServicesServiceActivated>(_onServiceActivated);
    on<ServicesServiceDeactivated>(_onServiceDeactivated);
    on<ServicesDirectMessageChanged>(_onDirectMessageChanged);
    on<ServicesBirthdayPersonNameChanged>(_onBirthdayPersonNameChanged);
    on<ServicesBirthdayWishesChanged>(_onBirthdayWishesChanged);
    on<ServicesDirectMessageVideoChanged>(_onDirectMessageVideoChanged);
    on<ServicesBirthdayGreetingsVideoChanged>(_onBirthdayGreetingsVideoChanged);
    on<ServicesDirectMessageVideoSent>(_onDirectMessageVideoSent);
    on<ServicesBirthdayGreetingsVideoSent>(_onBirthdayGreetingsVideoSent);
    on<ServicesFetched>(_onFetched);
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  void _onFetched(ServicesFetched event, Emitter<ServicesState> emit) {
    Stream<QuerySnapshot> fetchedServices = db.collection('Services').snapshots();

    emit(
        state.copyWith(
          services: fetchedServices,
        )
    );
  }

  void _onDirectMessageVideoChanged(ServicesDirectMessageVideoChanged event, Emitter<ServicesState> emit) {
    Map<String, String> newDirectMessageAnswers = Map<String, String>.of(state.directMessageAnswers);
    newDirectMessageAnswers[event.request] = event.directMessageVideo;

    emit(
        state.copyWith(
          directMessageAnswers: newDirectMessageAnswers,
        )
    );
  }

  void _onBirthdayGreetingsVideoChanged(ServicesBirthdayGreetingsVideoChanged event, Emitter<ServicesState> emit) {
    Map<String, String> newBirthdayRequestsAnswers = Map<String, String>.of(state.birthdayRequestsAnswers);
    newBirthdayRequestsAnswers[event.request] = event.birthdayGreetingsVideo;

    emit(
        state.copyWith(
          birthdayRequestsAnswers: newBirthdayRequestsAnswers,
        )
    );
  }

  Future<void> _onDirectMessageVideoSent(ServicesDirectMessageVideoSent event, Emitter<ServicesState> emit) async {
    // final String directMessage = event.directMessage;

    final smtpServer = gmail("lifehub.replies@gmail.com", "lcyc nrws zljh ivwv");

    final message = Message()
      ..from = Address("lifehub.replies@gmail.com", 'LifeHub Replies')
      ..recipients.add(event.userEmail)
      ..subject = 'Відповідь'
      ..text = 'Відповідь на ваше пряме повідомлення'
      ..attachments = [
        FileAttachment(File(state.directMessageAnswers[event.request]!))
          ..location = Location.inline
      ];

    await send(message, smtpServer);

    Map<String, String> newDirectMessageAnswers = Map<String, String>.of(state.directMessageAnswers);
    newDirectMessageAnswers.remove(event.request);

    emit(
        state.copyWith(
          operationPerformed: true,
          directMessageAnswers: newDirectMessageAnswers,
        )
    );
  }

  Future<void> _onBirthdayGreetingsVideoSent(ServicesBirthdayGreetingsVideoSent event, Emitter<ServicesState> emit) async {
    // final String directMessage = event.directMessage;

    final smtpServer = gmail("lifehub.replies@gmail.com", "lcyc nrws zljh ivwv");

    final message = Message()
      ..from = Address("lifehub.replies@gmail.com", 'LifeHub Replies')
      ..recipients.add(event.userEmail)
      ..subject = 'Привітання'
      ..text = 'Привітання з днем народження'
      ..attachments = [
        FileAttachment(File(state.birthdayRequestsAnswers[event.request]!))
          ..location = Location.inline
      ];

    await send(message, smtpServer);

    Map<String, String> newBirthdayRequestsAnswers = Map<String, String>.of(state.birthdayRequestsAnswers);
    newBirthdayRequestsAnswers.remove(event.request);

    emit(
        state.copyWith(
          operationPerformed: true,
          birthdayRequestsAnswers: newBirthdayRequestsAnswers,
        )
    );
  }

  // ----------------------------

  void _onDirectMessageChanged(ServicesDirectMessageChanged event, Emitter<ServicesState> emit) {
    final String directMessage = event.directMessage;

    emit(
      state.copyWith(
        directMessage: directMessage,
      )
    );
  }

  void _onBirthdayPersonNameChanged(ServicesBirthdayPersonNameChanged event, Emitter<ServicesState> emit) {
    final String birthdayPersonName = event.birthdayPersonName;

    emit(
        state.copyWith(
          birthdayPersonName: birthdayPersonName
        )
    );
  }

  void _onBirthdayWishesChanged(ServicesBirthdayWishesChanged event, Emitter<ServicesState> emit) {
    final String birthdayWishes = event.birthdayWishes;
    emit(
        state.copyWith(
          birthdayWishes: birthdayWishes,
        )
    );
  }

  void _onServiceActivated(ServicesServiceActivated event, Emitter<ServicesState> emit) {
    db.collection('Services').doc(event.service).update({"available": true});

    emit(
        state.copyWith(
          operationPerformed: true,
        )
    );
  }

  void _onServiceDeactivated(ServicesServiceDeactivated event, Emitter<ServicesState> emit) {
    db.collection('Services').doc(event.service).update({"available": false});

    emit(
        state.copyWith(
          operationPerformed: true,
        )
    );
  }

  void _onServicePriceChanged(ServicesServicePriceChanged event, Emitter<ServicesState> emit) {
    db.collection('Services').doc(event.service).update({"price": state.prices[event.service]});

    emit(
        state.copyWith(
          operationPerformed: true,
        )
    );
  }

  void _onNewPriceSet(ServicesNewPriceSet event, Emitter<ServicesState> emit) {
    Map<String, double> newPrices = Map<String, double>.of(state.prices);
    newPrices[event.service] = double.parse(event.newPrice);
    emit(
      state.copyWith(
        prices: newPrices,
      )
    );
  }

  Future<void> _onServiceDeleted(ServicesServiceDeleted event, Emitter<ServicesState> emit) async {
    db.collection('Services').doc(event.service).delete();
    // QuerySnapshot<Map<String, dynamic>> fetchedServices = await db.collection('Services').get();
    emit(
      state.copyWith(
        // services: fetchedServices,
        operationPerformed: true,
      ),
    );
  }

  Future<void> _onNewRequestCreated(ServicesNewRequestCreated event, Emitter<ServicesState> emit) async {

    if (event.serviceId == "B4LUGvFkR2MovFJ2r5Go") {
      Map<String, dynamic> requestInfo = <String, dynamic>{
        "user": event.userId,
        "service": event.serviceId,
        "direct message": event.directMessage,
        "time": FieldValue.serverTimestamp(),
      };

      await db.collection("Requests").add(requestInfo);
    }
    else if (event.serviceId == "eVTJdbWXKSMFDjynX7jI") {
      Map<String, dynamic> requestInfo = <String, dynamic>{
        "user": event.userId,
        "service": event.serviceId,
        "birthday person name": event.personName,
        "birthday wishes": event.wishes,
        "time": FieldValue.serverTimestamp(),
      };

      await db.collection("Requests").add(requestInfo);
    }
    else {
      Map<String, dynamic> requestInfo = <String, dynamic>{
        "user": event.userId,
        "service": event.serviceId,
        "time": FieldValue.serverTimestamp(),
      };

      await db.collection("Requests").add(requestInfo);
    }

    emit(
      state.copyWith(
        operationPerformed: true,
      ),
    );
  }
}
