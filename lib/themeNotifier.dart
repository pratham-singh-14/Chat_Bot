import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Themenotifier extends StateNotifier<ThemeMode>
{
  Themenotifier() : super(ThemeMode.light);

  void toggleTheme(){

    if(state == ThemeMode.light){
      state= ThemeMode.dark;
    }else{
      state= ThemeMode.light;
    }
  }



}


final themeProvider = StateNotifierProvider<Themenotifier,ThemeMode>((ref){

  return Themenotifier();
});
