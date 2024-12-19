import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../user_bloc/user_bloc.dart';

class UserSubscriptionView extends StatefulWidget {
  const UserSubscriptionView({super.key, required this.userId});

  final String userId;

  @override
  State<StatefulWidget> createState() => _UserSubscriptionViewState();

}

class _UserSubscriptionViewState extends State<UserSubscriptionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 32.0, right: 8.0, left: 8.0, bottom: 8.0),
                  child: Text(
                    textScaler: TextScaler.linear(1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    'Ваш ID',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 28,
                      // fontSize: MediaQuery.textScalerOf(context).scale(28),
                    ),
                  ),
                ),
              ),
              UserID(),
              Padding(
                padding: EdgeInsets.only(
                    top: 24.0, bottom: 8.0, left: 8.0, right: 8.0),
                child: Text(
                  textScaler: TextScaler.linear(1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  'Статус підписки',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 28,
                    // fontSize: MediaQuery.textScalerOf(context).scale(28),
                  ),
                ),
              ),
              SubscriptionStatus(),
              Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: RestorePurchasesButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserID extends StatelessWidget {
  const UserID({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textScaler: TextScaler.linear(1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            state.appUserID,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 28,
              // fontSize: MediaQuery.textScalerOf(context).scale(28),
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

class SubscriptionStatus extends StatelessWidget {
  const SubscriptionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textScaler: TextScaler.linear(1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            state.entitlementIsActive == true
                ? 'Активна'
                : 'Не активна',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 28,
              // fontSize: MediaQuery.textScalerOf(context).scale(28),
            ),
          ),
        );
      },
    );
  }
}

class RestorePurchasesButton extends StatelessWidget {
  const RestorePurchasesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.read<UserBloc>().add(const UserPurchasesRestored());
            },
            child: Text(
              textScaler: TextScaler.linear(1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              "Відновити покупки",
              style: TextStyle(
                fontFamily: "Inter",
                color: Colors.green.shade800,
                fontSize: 28,
                // fontSize: MediaQuery.textScalerOf(context).scale(28)
              ),
            ),
          ),
        );
      },
    );
  }
}