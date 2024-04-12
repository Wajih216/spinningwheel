import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spinningwheel/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:spinningwheel/screens/home/views/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spinning Wheel',   
      debugShowCheckedModeBanner: false,
      theme : ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade100 , 
          onBackground: Colors.green,
          primary: Colors.blue,
          onPrimary: Colors.white,
        )
      ),
      home : BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: ((context, state) { 
          if (state.status == AuthenticationStatus.authenticated) {
            return const HomeScreen(); 
          } else {
            return WelcomeScreen();
          }
        }
),
      )
    ); 
  }
}