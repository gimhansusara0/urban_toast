import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/cart/cart_provider.dart';
import 'package:urban_toast/providers/orders/orders_provider.dart';
import 'package:urban_toast/screens/user_account/services/order_service.dart';
import 'package:urban_toast/screens/user_account/services/payment_service.dart';
import 'package:urban_toast/screens/user_account/services/biometric_service.dart';
import 'package:urban_toast/screens/user_account/services/preference_service.dart';
import '../../models/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  final String userId;
  const CartPage({super.key, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _saveCard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final productId = cart.items.keys.elementAt(index);
                    final item = cart.items[productId]!;

                    return _CartItemCard(
                      item: item,
                      onIncrease: () => cart.incrementQty(productId),
                      onDecrease: () => cart.decrementQty(productId),
                      onSizeChanged: (sz) => cart.changeSize(productId, sz),
                      onRemove: () async {
                        final ok = await _confirm(context, 'Remove item?',
                            'Do you want to remove this item from the cart?');
                        if (ok) {
                          await cart.removeItem(productId);
                          _snack(context, 'Item removed');
                        }
                      },
                    );
                  },
                ),
              ),

              // Checkout summary
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12 + 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    )
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total: ${cart.subTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text('Checkout'),
                        onPressed: () => _showCheckoutSheet(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Checkout bottom sheet
  Future<void> _showCheckoutSheet(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final numCtrl = TextEditingController();
    final expCtrl = TextEditingController();
    final csvCtrl = TextEditingController();

    final user = FirebaseAuth.instance.currentUser!;
    final cart = context.read<CartProvider>();
    final orders = context.read<OrdersProvider>();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Checkout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: nameCtrl,
                  decoration:
                      const InputDecoration(labelText: "Card Holder's Name"),
                ),
                TextField(
                  controller: numCtrl,
                  decoration:
                      const InputDecoration(labelText: "Card Number"),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expCtrl,
                        keyboardType: TextInputType.number,
                        maxLength: 7, // MM/YYYY
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                          _ExpiryDateFormatter(),
                        ],
                        decoration: const InputDecoration(
                          labelText: "Expiry (MM/YYYY)",
                          counterText: "",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: csvCtrl,
                        decoration: const InputDecoration(labelText: "CSV"),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _saveCard,
                      onChanged: (v) {
                        setState(() {
                          _saveCard = v ?? false;
                        });
                      },
                    ),
                    const Text('Save this card for future use'),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text('Checkout'),
                        onPressed: () async {
                          if (nameCtrl.text.isEmpty || numCtrl.text.isEmpty) {
                            _snack(context, 'Please fill card details');
                            return;
                          }

                          if (_saveCard) {
                            await PaymentService.saveCard(
                              cardHolder: nameCtrl.text,
                              cardNumber: numCtrl.text,
                              expDate: expCtrl.text,
                              csv: csvCtrl.text,
                            );
                          }

                          await OrderService.saveOrder(
                            cartItems: cart.items,
                            total: cart.subTotal,
                          );

                          final total = cart.subTotal;
                          await cart.clearCart();
                          Navigator.pop(ctx);
                          _snack(context,
                              'Order placed successfully! Total: ${total.toStringAsFixed(2)}');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.credit_card),
                        label: const Text('Use Saved Card'),
                        onPressed: () async {
                          final bioEnabled =
                              await PreferencesService.getBiometricEnabled();
                          if (bioEnabled != true) {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Fingerprint not enabled'),
                                content: const Text(
                                    'Would you like to enable fingerprint authentication?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                            if (result == true) {
                              await PreferencesService.saveBiometricEnabled(
                                  true);
                            } else {
                              return;
                            }
                          }

                          final auth =
                              await BiometricService.authenticateUser();
                          if (!auth) {
                            _snack(context, 'Fingerprint verification failed');
                            return;
                          }

                          final cards =
                              await PaymentService.getSavedCards();
                          if (cards.isEmpty) {
                            _snack(context, 'No saved cards found');
                            return;
                          }

                          final chosen =
                              await showModalBottomSheet<Map<String, dynamic>>(
                            context: context,
                            backgroundColor: Theme.of(context).cardColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                            ),
                            builder: (_) => ListView(
                              children: cards.map((c) {
                                final masked = c['cardNumber']
                                    .toString()
                                    .replaceRange(4, 12, "********");
                                return ListTile(
                                  leading: const Icon(Icons.credit_card),
                                  title: Text(masked),
                                  subtitle: Text(
                                      'Expires: ${c['expDate'] ?? '--/--'}'),
                                  onTap: () => Navigator.pop(context, c),
                                );
                              }).toList(),
                            ),
                          );

                          if (chosen != null) {
                            orders.addOrderFromCart(
                              userId: user.uid,
                              cartItems: cart.items,
                            );
                            final total = cart.subTotal;
                            await cart.clearCart();
                            _snack(context,
                                'Order placed using saved card! Total: ${total.toStringAsFixed(2)}');
                            Navigator.pop(ctx);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ----- helpers -----
Future<bool> _confirm(BuildContext context, String title, String body) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes')),
      ],
    ),
  );
  return res ?? false;
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));
}

// Expiry Date Formatter
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');

    // Limit to 6 digits (MMYYYY)
    if (text.length > 6) {
      text = text.substring(0, 6);
    }

    // Insert slash after first 2 digits
    if (text.length >= 3) {
      text = text.substring(0, 2) + '/' + text.substring(2);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final ValueChanged<ItemSize> onSizeChanged;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onSizeChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.local_cafe),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(item.product.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      IconButton(
                        tooltip: 'Remove',
                        icon: const Icon(Icons.close),
                        onPressed: onRemove,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('Size: '),
                      DropdownButton<ItemSize>(
                        value: item.size,
                        underline: const SizedBox(),
                        items: ItemSize.values.map((sz) {
                          return DropdownMenuItem<ItemSize>(
                            value: sz,
                            child: Text(sz.label),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) onSizeChanged(v);
                        },
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Unit: ${item.unitPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QtyBtn(icon: Icons.remove, onTap: onDecrease),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('${item.qty}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ),
                      _QtyBtn(icon: Icons.add, onTap: onIncrease),
                      const Spacer(),
                      Text(
                        'Total: ${item.lineTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(.08),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }
}
