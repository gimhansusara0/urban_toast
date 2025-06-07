import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Login',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(45, 10, 45, 0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: emailController,
                    decoration:
                        const InputDecoration(labelText: 'Enter your Email'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration:
                        const InputDecoration(labelText: 'Enter your Password'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {}, child: Text('Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800
                            ),))),
                  )
                ],
              ),
            ),
          ),
          RichText(
            text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Theme.of(context).primaryColorDark),
                children: [
                  TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Signup Clicked');
                        })
                ]),
          )
        ],
      ),
    );
  }
}
