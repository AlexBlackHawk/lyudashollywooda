import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyudashollywooda/chat_bloc/chat_bloc.dart';
import 'package:lyudashollywooda/donate_bloc/donate_bloc.dart';
import 'package:lyudashollywooda/new_post_bloc/new_post_bloc.dart';
import 'package:lyudashollywooda/post_list/post_list_bloc.dart';
import 'package:lyudashollywooda/services/services_bloc.dart';
import 'package:lyudashollywooda/user_bloc/user_bloc.dart';
import 'package:lyudashollywooda/view/admin_view.dart';
import 'package:lyudashollywooda/view/log_in_page.dart';
import 'package:lyudashollywooda/view/user_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc()..add(const UserInformationFetched())..add(const UserPlatformStateInitialized())..add(const UserConfigurationsSet()),
        ),
        BlocProvider<PostListBloc>(
          create: (BuildContext context) => PostListBloc()..add(const PostListFetched()),
        ),
        BlocProvider<ChatBloc>(
          create: (BuildContext context) => ChatBloc(),
        ),
        BlocProvider<ServicesBloc>(
          create: (BuildContext context) => ServicesBloc(),
        ),
        BlocProvider<NewPostBloc>(
          create: (BuildContext context) => NewPostBloc(),
        ),
        BlocProvider<DonateBloc>(
          create: (BuildContext context) => DonateBloc()..add(const DonateOfferingsFetched()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LifeHub',
        theme: ThemeData(
          useMaterial3: true,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.black,
          )
        ),
        home: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state.isLoadingUserInfo,
              child: state.userInfo["role"] == "user" ? const UserView() : state.userInfo["role"] == "admin" ? const AdminView() : const LogInView(),
            );
          },
        ),
      )
    );
  }
}