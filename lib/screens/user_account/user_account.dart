import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/auth/auth_provider.dart';
import 'package:urban_toast/screens/user_account/components/item.dart';
import 'package:urban_toast/screens/user_account/services/preference_service.dart';
import 'package:urban_toast/screens/user_account/services/biometric_service.dart';
import 'package:urban_toast/screens/user_account/services/payment_service.dart';
import 'package:urban_toast/screens/user_account/components/edit_profile_dialog.dart';
import 'package:urban_toast/screens/user_account/components/order_history_page.dart';

class MyUserAccount extends StatefulWidget {
  const MyUserAccount({super.key});

  @override
  State<MyUserAccount> createState() => _MyUserAccountState();
}

class _MyUserAccountState extends State<MyUserAccount> {
  String? _name;
  String? _imagePath;
  bool _biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
     final auth = context.watch<AuthProvider>();
    // final name = await PreferencesService.getUserName();
    final image = await PreferencesService.getUserImage();
    final bioEnabled = await PreferencesService.getBiometricEnabled();
    setState(() {
      _name = auth.userData?['firstName'] ?? 'User';
      _imagePath = image;
      _biometricsEnabled = bioEnabled ?? false;
    });
  }

  Future<void> _showImagePickerSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (_) {
        final textColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading:
                    const Icon(Icons.camera_alt, color: Colors.orangeAccent),
                title: Text('Take Photo', style: TextStyle(color: textColor)),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.orangeAccent),
                title: Text('Choose from Gallery',
                    style: TextStyle(color: textColor)),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final camStatus = await Permission.camera.request();
      if (!camStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied to access camera')),
        );
        return;
      }
    } else {
      final galStatus = await Permission.photos.request();
      if (!galStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied to access gallery')),
        );
        return;
      }
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 75);
    if (picked != null) {
      await PreferencesService.saveUserImage(picked.path);
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  Future<void> _toggleBiometrics(bool value) async {
    final isAvailable = await BiometricService.canUseBiometrics();
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('No biometric hardware or fingerprints enrolled.')),
      );
      return;
    }

    final auth = await BiometricService.authenticateUser();
    if (auth) {
      setState(() => _biometricsEnabled = value);
      await PreferencesService.saveBiometricEnabled(value);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          value
              ? 'Biometric authentication enabled'
              : 'Biometric authentication disabled',
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fingerprint verification failed')),
      );
    }
  }

  void _editProfile() async {
    final result = await showDialog(
      context: context,
      builder: (_) => EditProfileDialog(),
    );
    if (result == true) _loadUserData();
  }

  void _logout() async {
    await PreferencesService.clearUserData();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  // SHOW SAVED CARDS bottom sheet
  Future<void> _showSavedCards() async {
    final auth = await BiometricService.authenticateUser();
    if (!auth) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fingerprint verification failed')),
      );
      return;
    }

    final cards = await PaymentService.getSavedCards();
    if (cards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No saved cards found.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (_, i) {
              final c = cards[i];
              final masked = c['cardNumber']
                  .toString()
                  .replaceRange(4, 12, "********");
              return ListTile(
                leading: const Icon(Icons.credit_card,
                    color: Colors.orangeAccent),
                title: Text(masked),
                subtitle: Text('Expires: ${c['expDate'] ?? '--/--'}'),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _portraitBuilder(context, textColor)
              : _landscapeBuilder(context, textColor);
        },
      ),
    );
  }

  Widget _portraitBuilder(BuildContext context, Color textColor) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipOval(
                      child: _imagePath == null
                          ? Image.network(
                              'https://i.pinimg.com/736x/51/f1/c4/51f1c4cf7b732a99471d0beca326d666.jpg',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_imagePath!),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: _showImagePickerSheet,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.edit,
                              color: Colors.black87, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _name ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          UserItems(
            icon: const Icon(Icons.edit),
            text: 'Edit Profile',
            onTap: _editProfile,
          ),
          UserItems(
  icon: const Icon(Icons.credit_card),
  text: 'Payment Methods',
  onTap: () async {
    final isAvailable = await BiometricService.canUseBiometrics();
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric hardware not available.')),
      );
      return;
    }

    if (!_biometricsEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Enable biometrics to access payment methods.')),
      );
      return;
    }

    final auth = await BiometricService.authenticateUser();
    if (!auth) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fingerprint verification failed')),
      );
      return;
    }

    // Fetch cards
    final cards = await PaymentService.getSavedCards();
    if (cards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No saved cards found.')),
      );
      return;
    }

    // Show card list bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cards.length,
            itemBuilder: (ctx, i) {
              final c = cards[i];
              final masked = c['cardNumber'].toString().replaceRange(4, 12, "********");
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.credit_card, color: Colors.orangeAccent),
                  title: Text(masked),
                  subtitle: Text(
                    'Holder: ${c['cardHolder']}\nExp: ${c['expDate'] ?? '--/--'}',
                  ),
                  isThreeLine: true,
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditCardSheet(context, c);
                        },
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete card?'),
                              content: const Text('This action cannot be undone.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await PaymentService.deleteCard(c['id']);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Card deleted successfully')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  },
),

          // Added View Saved Cards
          UserItems(
            icon: const Icon(Icons.visibility),
            text: 'View Saved Cards',
            onTap: _showSavedCards,
          ),
          UserItems(
            icon: const Icon(Icons.history),
            text: 'Order History',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
            ),
          ),
          SwitchListTile(
            title: const Text('Enable Biometrics'),
            value: _biometricsEnabled,
            onChanged: _toggleBiometrics,
          ),
          const SizedBox(height: 5),
          UserItems(
            icon: const Icon(Icons.logout, color: Colors.red),
            text: 'Logout',
            textColor: Colors.red,
            showEditIcon: false,
            onTap: _logout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _landscapeBuilder(BuildContext context, Color textColor) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipOval(
                    child: _imagePath == null
                        ? Image.network(
                            'https://i.pinimg.com/736x/51/f1/c4/51f1c4cf7b732a99471d0beca326d666.jpg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(_imagePath!),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: _showImagePickerSheet,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.edit,
                            color: Colors.black87, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _name ?? 'User',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(child: _portraitBuilder(context, textColor)),
      ],
    );
  }
}


void _showEditCardSheet(BuildContext context, Map<String, dynamic> card) {
  final holderCtrl = TextEditingController(text: card['cardHolder']);
  final numCtrl = TextEditingController(text: card['cardNumber']);
  final expCtrl = TextEditingController(text: card['expDate']);
  final csvCtrl = TextEditingController(text: card['csv']);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Edit Card Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: holderCtrl,
                decoration: const InputDecoration(labelText: "Card Holder's Name"),
              ),
              TextField(
                controller: numCtrl,
                decoration: const InputDecoration(labelText: "Card Number"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: expCtrl,
                decoration: const InputDecoration(labelText: "Expiry (MM/YY)"),
              ),
              TextField(
                controller: csvCtrl,
                decoration: const InputDecoration(labelText: "CSV"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                onPressed: () async {
                  await PaymentService.updateCard(
                    cardId: card['id'],
                    cardHolder: holderCtrl.text,
                    cardNumber: numCtrl.text,
                    expDate: expCtrl.text,
                    csv: csvCtrl.text,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Card updated successfully')),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
