part of 'donate_bloc.dart';

final class DonateEvent extends Equatable {
  const DonateEvent();

  @override
  List<Object?> get props => [];
}

final class DonateFirstChipPressed extends DonateEvent {
  const DonateFirstChipPressed();
}

final class DonateSecondChipPressed extends DonateEvent {
  const DonateSecondChipPressed();
}

final class DonateThirdChipPressed extends DonateEvent {
  const DonateThirdChipPressed();
}

final class DonateSumChanged extends DonateEvent {
  const DonateSumChanged({required this.newSum});

  final String newSum;

  @override
  List<Object> get props => [newSum];
}

final class DonateCancelled extends DonateEvent {
  const DonateCancelled();
}

final class DonatePackagePurchased extends DonateEvent {
  const DonatePackagePurchased();
}

final class DonateOfferingsFetched extends DonateEvent {
  const DonateOfferingsFetched();
}

final class DonateCommentChanged extends DonateEvent {
  const DonateCommentChanged({required this.comment});

  final String comment;

  @override
  List<Object> get props => [comment];
}

final class DonatePackageChanged extends DonateEvent {
  const DonatePackageChanged({required this.package});

  final Package package;

  @override
  List<Object> get props => [package];
}
