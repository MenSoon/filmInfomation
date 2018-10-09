import 'package:filminfomation/app.dart';
import 'package:filminfomation/scoped_models/app_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()async {
  SharedPreferences sharedPreference=await SharedPreferences.getInstance();
  runApp(ScopedModel<AppModel>(
    model: AppModel(sharedPreference),child: CinematicApp(),
  ));
}


