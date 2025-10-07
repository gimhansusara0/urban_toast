import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/auth/auth_provider.dart';

class TopRibbon extends StatelessWidget {
  const TopRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final userData = context.read<AuthProvider>().userData;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Welcome ${userData?['firstName']}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Theme.of(context).primaryColor,
                    size: 26,
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
