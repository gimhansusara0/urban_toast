import 'package:flutter/material.dart';
import 'package:urban_toast/screens/auth/components/login/login_form.dart';
import 'package:urban_toast/screens/auth/components/login/login_img.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: LoginImg(),
            ),
            Expanded(child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100))
              ),
              child: LoginForm()))
          ],
        ),
      ),
  );
}

Widget _landscapeBuilder(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        children: [
          Expanded(child: LoginImg()),
          Expanded(child: Container(
            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: LoginForm()))
        ],
      ),
    ),
  );
}
