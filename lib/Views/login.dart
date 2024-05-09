import 'package:flutter/material.dart';
import 'package:spinningwheel/Components/button.dart';
import 'package:spinningwheel/Components/colors.dart';
import 'package:spinningwheel/Components/textfield.dart';
import 'package:spinningwheel/JSON/users.dart';
import 'package:spinningwheel/Views/home/home_screen.dart';
import 'package:spinningwheel/Views/signup.dart';

import '../SQLite/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Our controllers
  //Controller is used to take the value from user and pass it to database
  final usrName = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();

  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();
  //Login Method
  //We will take the value of text fields using controllers in order to verify whether details are correct or not
  login()async{
    Users? usrDetails = await db.getUser(usrName.text);
    var res = await db.authenticate(Users(usrName: usrName.text, password: password.text, phoneNumber: phoneNumber.text));
    if(res == true){
      //If result is correct then go to profile or home
      if(!mounted)return;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen( user: usrDetails!)));
    }else{
      //Otherwise show the error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //Because we don't have account, we must create one to authenticate
                //lets go to sign up

                const Text("LOGIN",style: TextStyle(color: primaryColor,fontSize: 40),),
                Image.asset("assets/telecom.jpg"),
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrName),
                InputField(hint: "Password", icon: Icons.lock, controller: password,passwordInvisible: true),
                InputField(hint: "Phone Number", icon: Icons.phone, controller: phoneNumber),
                
                const SizedBox(height: 10),

                //Our login button
                Button(label: "LOGIN", press: (){
                login();

                }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",style: TextStyle(color: Colors.grey),),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignupScreen()));
                        },
                        child: const Text("SIGN UP"))
                  ],
                ),

                 // Access denied message in case when your username and password is incorrect
                //By default we must hide it
                 //When login is not true then display the message
                 isLoginTrue? Text("Username or password is incorrect",style: TextStyle(color: Colors.red.shade900),):const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
