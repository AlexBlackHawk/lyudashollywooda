part of 'donate_bloc.dart';

enum PaymentStatus { initial, loading, success, failure }

final class DonateState extends Equatable {
  const DonateState({
    this.sum = "0",
    this.chipChosen = 0,
    this.comment = "",
    this.chosenDonatePackage,
    this.productList = const <String, Offering>{},
  });

  final String sum;
  final int chipChosen;
  final String comment;
  final Package? chosenDonatePackage;
  final Map<String, Offering> productList;

  DonateState copyWith({
    String? sum,
    int? chipChosen,
    String? comment,
    Package? chosenDonatePackage,
    Map<String, Offering>? productList,
  }) {
    return DonateState(
      sum: sum ?? this.sum,
      chipChosen: chipChosen ?? this.chipChosen,
      comment: comment ?? this.comment,
      chosenDonatePackage: chosenDonatePackage ?? this.chosenDonatePackage,
      productList: productList ?? this.productList,
    );
  }

  @override
  List<Object?> get props => [
    sum,
    chipChosen,
    comment,
    chosenDonatePackage,
    productList
  ];
}
