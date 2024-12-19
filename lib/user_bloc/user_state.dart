part of 'user_bloc.dart';

enum SubscriptionStatus {active, notActive}
enum FreeTrialStatus {initial, loading, success, failure}

final class UserState extends Equatable {
  const UserState({
    this.entitlementIsActive = false,
    this.appUserID = '',
    this.showAds = true,
    this.userId = "",
    this.customerInfo,
    this.productList = const <Package>[],
    this.userCredential,
    this.userInfo = const <String, dynamic>{},
    this.haveChat = false,
    this.chatId = "",
    this.googleSignIn,
    this.provider = "",
    this.showDialog = false,
    this.freeTrialStatus = FreeTrialStatus.initial,
    this.isLoadingUserInfo = false,
  });

  final String userId;
  final bool entitlementIsActive;
  final String appUserID;
  final bool showAds;
  final CustomerInfo? customerInfo;
  final List<Package> productList;
  final UserCredential? userCredential;
  final Map<String, dynamic> userInfo;
  final bool haveChat;
  final String chatId;
  final GoogleSignIn? googleSignIn;
  final String provider;
  final bool showDialog;
  final FreeTrialStatus freeTrialStatus;
  final bool isLoadingUserInfo;

  UserState copyWith({
    bool? entitlementIsActive,
    String? appUserID,
    bool? showAds,
    CustomerInfo? customerInfo,
    List<Package>? productList,
    bool? isAuthenticated,
    UserCredential? userCredential,
    Map<String, dynamic>? userInfo,
    String? subscriptionId,
    bool? haveChat,
    String? chatId,
    bool? operationPerformed,
    GoogleSignIn? googleSignIn,
    String? provider,
    bool? showDialog,
    String? userId,
    FreeTrialStatus? freeTrialStatus,
    bool? isLoadingUserInfo,
  }) {
    return UserState(
      entitlementIsActive: entitlementIsActive ?? this.entitlementIsActive,
      appUserID: appUserID ?? this.appUserID,
      showAds: showAds ?? this.showAds,
      userId: userId ?? this.userId,
      customerInfo: customerInfo ?? this.customerInfo,
      productList: productList ?? this.productList,
      userCredential: userCredential ?? this.userCredential,
      userInfo: userInfo ?? this.userInfo,
      haveChat: haveChat ?? this.haveChat,
      chatId: chatId ?? this.chatId,
      googleSignIn: googleSignIn ?? this.googleSignIn,
      provider: provider ?? this.provider,
      showDialog: showDialog ?? this.showDialog,
      freeTrialStatus: freeTrialStatus ?? this.freeTrialStatus,
      isLoadingUserInfo: isLoadingUserInfo ?? this.isLoadingUserInfo,
    );
  }

  @override
  List<Object?> get props => [
    entitlementIsActive,
    appUserID,
    userId,
    showAds,
    customerInfo,
    productList,
    userCredential,
    userInfo,
    haveChat,
    chatId,
    googleSignIn,
    provider,
    showDialog,
    freeTrialStatus,
    isLoadingUserInfo,
  ];
}
