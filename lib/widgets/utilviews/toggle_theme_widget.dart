import 'package:filminfomation/scoped_models/app_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return IconButton(
            icon: Icon(
              Icons.color_lens,
              color: Colors.white,
            ),
            onPressed: () {
              model.toggleTheme();
            });
      },
    );
  }
}
