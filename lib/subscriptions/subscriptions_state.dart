part of 'subscriptions_bloc.dart';

final class SubscriptionsState extends Equatable {
  const SubscriptionsState({
    this.chosenSubscription = 0,
  });

  final int chosenSubscription;

  SubscriptionsState copyWith({
    int? chosenSubscription,
  }) {
    return SubscriptionsState(
      chosenSubscription: chosenSubscription ?? this.chosenSubscription,
    );
  }

  @override
  List<Object?> get props => [
    chosenSubscription,
  ];
}
