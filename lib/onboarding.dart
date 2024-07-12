import 'dart:ffi';

import 'package:chat_with_gemini/MyHomePage.dart';
import 'package:chat_with_gemini/onBoardingView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShared();

      }

  void getShared() async {
    final prefs =await SharedPreferences.getInstance();
   final prefrence= prefs.getBool("onBoarding") ?? false;
   //print(prefrence);
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => prefrence ? MyHomePage() : OnBoardingView() ),
      );
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Center(child: Image.asset('assets/robot.gif',))),
            Text("Developed By :-",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
            SizedBox(height: 5,),
            Text("Pratham Singh",style: TextStyle(letterSpacing:1.6,color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 18))
          ],
        )
      ),
    );
  }
}
