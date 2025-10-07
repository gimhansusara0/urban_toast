import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/providers/product/menu_product_provider.dart';

class GiftCoffeeScreen extends StatelessWidget {
  final int crossaxiscount;
  const GiftCoffeeScreen({super.key, this.crossaxiscount = 2});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<MenuProductProvider>();

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final products = productProvider.filteredProducts;
    if (products.isEmpty) {
      return const Center(child: Text('No coffees available.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift a Coffee ☕'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossaxiscount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];
            return _GiftProductCard(product: product);
          },
        ),
      ),
    );
  }
}

class _GiftProductCard extends StatelessWidget {
  final Product product;
  const _GiftProductCard({required this.product});

  String _generateGiftCode() {
    final rand = Random();
    const prefixes = ['CAF', 'BREW', 'BEAN', 'LOVE'];
    return '${prefixes[rand.nextInt(prefixes.length)]}-${rand.nextInt(9000) + 1000}';
  }

  Future<void> _pickContactAndSend(BuildContext context, String coffeeName) async {
    final permission = await FlutterContacts.requestPermission(readonly: true);
    if (!permission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contacts permission denied')),
      );
      return;
    }

    // open the contact picker full screen
    final contact = await Navigator.push<Contact?>(
      context,
      MaterialPageRoute(builder: (_) => const ContactPickerScreen()),
    );

    if (contact == null) return;

    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : null;
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This contact has no phone number')),
      );
      return;
    }

    // generate gift code and message
    final code = _generateGiftCode();
    final message =
        "Hey ${contact.displayName}! ☕ I just sent you a $coffeeName from Urban Toast!\nHere’s your gift code: $code 🤤";

    // launch SMS safely
    await _launchSms(context, phone, message);
  }

  /// Works via Android Intent
  Future<void> _launchSms(BuildContext context, String phone, String message) async {
    try {
      if (Platform.isAndroid) {
        final intent = AndroidIntent(
          action: 'android.intent.action.SENDTO',
          data: 'smsto:$phone',
          arguments: {'sms_body': message},
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      } else if (Platform.isIOS) {
        final smsUrl = Uri.parse('sms:$phone&body=${Uri.encodeComponent(message)}');
        if (await canLaunchUrl(smsUrl)) {
          await launchUrl(smsUrl, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No SMS app found on Android')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unsupported platform')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending SMS: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickContactAndSend(context, product.name),
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coffee image
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Name + gift button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      product.name.length > 13
                          ? '${product.name.substring(0, 13)}...'
                          : product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => _pickContactAndSend(context, product.name),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: const Color(0xFFD48B5C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.card_giftcard, color: Colors.white, size: 20),
                    ),
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


// Full-Screen Contact Picker with Search


class ContactPickerScreen extends StatefulWidget {
  const ContactPickerScreen({super.key});

  @override
  State<ContactPickerScreen> createState() => _ContactPickerScreenState();
}

class _ContactPickerScreenState extends State<ContactPickerScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final contacts = await FlutterContacts.getContacts(withProperties: true);
    setState(() {
      _contacts = contacts;
      _filteredContacts = contacts;
      _loading = false;
    });
  }

  void _searchContacts(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filteredContacts = _contacts
          .where((c) => c.displayName.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Contact'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _searchContacts,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search contact...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final c = _filteredContacts[index];
                      final phone =
                          c.phones.isNotEmpty ? c.phones.first.number : '';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          child: Text(
                            c.displayName.isNotEmpty
                                ? c.displayName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                        title: Text(c.displayName),
                        subtitle: Text(
                          phone.isNotEmpty ? phone : 'No phone number',
                        ),
                        onTap: () => Navigator.pop(context, c),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
