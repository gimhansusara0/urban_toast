import 'package:flutter/material.dart';
import 'package:urban_toast/screens/user_account/services/preference_service.dart';

class EditProfileDialog extends StatefulWidget {
  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String number = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'First Name'),
            onChanged: (v) => firstName = v,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Last Name'),
            onChanged: (v) => lastName = v,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            onChanged: (v) => number = v,
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final fullName = '$firstName $lastName';
            await PreferencesService.saveUserName(fullName);
            if (!mounted) return;
            Navigator.pop(context, true);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
