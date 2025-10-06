// lib/screens/auth/components/login/login_form.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/auth/auth_provider.dart';
import 'package:urban_toast/screens/auth/register_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Login',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(45, 10, 45, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Email',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(
                  controller: auth.emailController,
                  decoration: const InputDecoration(labelText: 'Enter your Email'),
                ),
                const SizedBox(height: 10),
                const Text('Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(
                  controller: auth.passwordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Enter your Password'),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: auth.isLoading
                        ? null
                        : () => auth.login(context),
                    child: auth.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Theme.of(context).primaryColorDark,
              ),
              children: [
                TextSpan(
                  text: 'Sign Up',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
