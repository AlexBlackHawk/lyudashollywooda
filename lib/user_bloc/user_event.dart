part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class UserInformationFetched extends UserEvent {
  const UserInformationFetched();
}

final class UserPurchasesRestored extends UserEvent {
  const UserPurchasesRestored();
}

final class UserConfigurationsSet extends UserEvent {
  const UserConfigurationsSet();
}

final class UserPlatformStateInitialized extends UserEvent {
  const UserPlatformStateInitialized();
}

final class UserLogoutPressed extends UserEvent {
  const UserLogoutPressed();
}

final class UserLogInWithGoogle extends UserEvent {
  const UserLogInWithGoogle();
}

final class UserLogInWithApple extends UserEvent {
  const UserLogInWithApple();
}

final class UserLogInWithFacebook extends UserEvent {
  const UserLogInWithFacebook();
}

final class UserSubscriptionPackagePurchased extends UserEvent {
  const UserSubscriptionPackagePurchased({required this.subscriptionIndex});

  final int subscriptionIndex;

  @override
  List<Object> get props => [subscriptionIndex];
}

final class UserOnlineStatusChanged extends UserEvent {
  const UserOnlineStatusChanged({required this.isOnline});

  final bool isOnline;

  @override
  List<Object> get props => [isOnline];
}

final class UserDBDeleted extends UserEvent {
  const UserDBDeleted();
}

final class UserAuthDeleted extends UserEvent {
  const UserAuthDeleted();
}
