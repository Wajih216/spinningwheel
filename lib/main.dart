//import 'package:bloc/bloc.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spinningwheel/screens/home/home_screen.dart';
//import 'package:spinningwheel/simple_bloc_observer.dart';
//import 'package:user_repository/user_repository.dart';

void main() async {
  runApp(const MyApp()) ; 
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Spinning Wheel',
      debugShowCheckedModeBanner: false,
      home : HomeScreen(), 
      );
    }
}


