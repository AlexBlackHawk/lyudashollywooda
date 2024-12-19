import 'package:lyudashollywooda/configs/store_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Future<void> configureSDK() async {
  // Enable debug logs before calling `configure`.
  await Purchases.setLogLevel(LogLevel.debug);

  /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
  PurchasesConfiguration configuration;
  configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
    ..appUserID = null;
    // ..observerMode = false;
  await Purchases.configure(configuration);
}