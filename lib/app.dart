import 'package:filminfomation/scoped_models/app_model.dart';
import 'package:filminfomation/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
class CinematicApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<AppModel>(builder: (context,child,model){
      return MaterialApp(
        home: HomePage(),
        title: 'Cinematic',
        theme: model.theme,
      );
    },);
  }
}