import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'subscriptions_event.dart';
part 'subscriptions_state.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  SubscriptionsBloc() : super(const SubscriptionsState()) {
    // on<RestorePurchases>(_onRestorePurchases);
    on<SubscriptionsChosenSubscriptionChanged>(_onChosenSubscriptionChanged);
  }

  void _onChosenSubscriptionChanged(SubscriptionsChosenSubscriptionChanged event, Emitter<SubscriptionsState> emit) async {
    emit(
        state.copyWith(
          chosenSubscription: event.subscriptionIndex,
        )
    );
  }
}
