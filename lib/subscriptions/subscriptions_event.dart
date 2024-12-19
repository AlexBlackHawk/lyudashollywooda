part of 'subscriptions_bloc.dart';

sealed class SubscriptionsEvent extends Equatable {
  const SubscriptionsEvent();

  @override
  List<Object> get props => [];
}

final class SubscriptionsChosenSubscriptionChanged extends SubscriptionsEvent {
  const SubscriptionsChosenSubscriptionChanged({required this.subscriptionIndex});

  final int subscriptionIndex;

  @override
  List<Object> get props => [subscriptionIndex];
}
