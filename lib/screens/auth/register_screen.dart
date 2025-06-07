import 'package:flutter/material.dart';
import 'package:urban_toast/screens/auth/components/register/regis_img.dart';
import 'package:urban_toast/screens/auth/components/register/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _portraitBuilder(context);
          } else {
            return _landscapeBuilder(context);
          }
        },
      ),
    );
  }
}

Widget _portraitBuilder(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: RegisterImg()),
          Expanded(
              child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100))),
            child: RegisterForm(),
          ))
        ],
      ),
    ),
  );
}

Widget _landscapeBuilder(BuildContext context) {
  return SafeArea(
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        children: [
          Expanded(child: RegisterImg()),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: SingleChildScrollView(child: RegisterForm())))
        ],
      ),
    ),
  );
}
