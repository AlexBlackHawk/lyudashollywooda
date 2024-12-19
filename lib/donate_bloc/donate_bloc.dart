import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'donate_event.dart';
part 'donate_state.dart';

class DonateBloc extends Bloc<DonateEvent, DonateState> {
  DonateBloc() : super(const DonateState()) {
    on<DonateSumChanged>(_onSumChanged);
    on<DonateFirstChipPressed>(_onFirstChipPressed);
    on<DonateSecondChipPressed>(_onSecondChipPressed);
    on<DonateThirdChipPressed>(_onThirdChipPressed);
    on<DonateCancelled>(_onCancelled);
    on<DonateCommentChanged>(_onCommentChanged);
    on<DonatePackageChanged>(_onPackageChanged);
    on<DonatePackagePurchased>(_onPackagePurchased);
    on<DonateOfferingsFetched>(_onOfferingsFetched);
  }

  void _onPackageChanged(DonatePackageChanged event, Emitter<DonateState> emit) {
    emit(
        state.copyWith(
          chosenDonatePackage: event.package,
        )
    );
  }

  Future<void> _onPackagePurchased(DonatePackagePurchased event, Emitter<DonateState> emit) async {
    await Purchases.purchasePackage(state.chosenDonatePackage!);
  }

  Future<void> _onOfferingsFetched(DonateOfferingsFetched event, Emitter<DonateState> emit) async {
    Offerings? offerings = await Purchases.getOfferings();
    Map<String, Offering> packages = Map<String, Offering>.of(offerings.all);
    packages.remove("subscriptions");

    Map<String, Offering> sortedPackages = Map.fromEntries(
        packages.entries.toList()..sort((e1, e2) => e1.value.lifetime!.storeProduct.price.compareTo(e2.value.lifetime!.storeProduct.price)));

    emit(
        state.copyWith(
          productList: sortedPackages,
        )
    );
  }

  void _onCommentChanged(DonateCommentChanged event, Emitter<DonateState> emit) {
    final String comment = event.comment;

    emit(
        state.copyWith(
          comment: comment,
        )
    );
  }

  void _onCancelled(DonateCancelled event, Emitter<DonateState> emit) {
    emit(
        state.copyWith(
          sum: "",
        )
    );
  }

  void _onSumChanged(DonateSumChanged event, Emitter<DonateState> emit) {
    String sum = event.newSum;
    emit(
        state.copyWith(
          sum: sum,
        )
    );
  }

  void _onFirstChipPressed(DonateFirstChipPressed event, Emitter<DonateState> emit) {
    emit(
        state.copyWith(
          chipChosen: 1,
          sum: "100",
        )
    );
  }

  void _onSecondChipPressed(DonateSecondChipPressed event, Emitter<DonateState> emit) {
    emit(
        state.copyWith(
          chipChosen: 2,
          sum: "300",
        )
    );
  }

  void _onThirdChipPressed(DonateThirdChipPressed event, Emitter<DonateState> emit) {
    emit(
        state.copyWith(
          chipChosen: 3,
          sum: "500",
        )
    );
  }
}
