import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/user/user_provider.dart';

class EditProfileDialog extends StatefulWidget {
  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _numberCtrl;

  @override
  void initState() {
    super.initState();
    final userData = context.read<UserProvider>().userData;
    _firstNameCtrl = TextEditingController(text: userData?['firstName'] ?? '');
    _lastNameCtrl = TextEditingController(text: userData?['lastName'] ?? '');
    _numberCtrl = TextEditingController(text: userData?['phone'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _firstNameCtrl,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: _lastNameCtrl,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: _numberCtrl,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final provider = context.read<UserProvider>();
            await provider.updateUserData({
              'firstName': _firstNameCtrl.text.trim(),
              'lastName': _lastNameCtrl.text.trim(),
              'phone': _numberCtrl.text.trim(),
            });
            if (!mounted) return;
            Navigator.pop(context, true);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
