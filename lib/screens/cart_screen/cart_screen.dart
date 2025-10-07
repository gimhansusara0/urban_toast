import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urban_toast/providers/cart/cart_provider.dart';
import 'package:urban_toast/screens/user_account/services/order_service.dart';
import 'package:urban_toast/screens/user_account/services/payment_service.dart';
import '../../models/cart_item.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
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
                      isDark: isDark,
                      onIncrease: () => cart.incrementQty(productId),
                      onDecrease: () => cart.decrementQty(productId),
                      onSizeChanged: (sz) => cart.changeSize(productId, sz),
                      onRemove: () async {
                        final ok = await _confirm(
                          context,
                          'Remove item?',
                          'Do you want to remove this item from the cart?',
                        );
                        if (ok) {
                          await cart.removeItem(productId);
                          _snack(context, 'Item removed');
                        }
                      },
                    );
                  },
                ),
              ),

              // Bottom summary
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total: ${cart.subTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text('Checkout'),
                        onPressed: () => _showCheckoutSheet(context, isDark),
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

  // --- CHECKOUT SHEET ---
  Future<void> _showCheckoutSheet(BuildContext context, bool isDark) async {
    final nameCtrl = TextEditingController();
    final numCtrl = TextEditingController();
    final expCtrl = TextEditingController();
    final csvCtrl = TextEditingController();

    final user = FirebaseAuth.instance.currentUser!;
    final cart = context.read<CartProvider>();

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
                Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 15),

                // Card inputs
                _styledInput(nameCtrl, "Card Holder's Name", isDark),
                _styledInput(numCtrl, "Card Number", isDark,
                    keyboardType: TextInputType.number),
                Row(
                  children: [
                    Expanded(
                      child: _styledInput(expCtrl, "Expiry (MM/YYYY)", isDark,
                          keyboardType: TextInputType.number,
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                            _ExpiryDateFormatter(),
                          ]),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _styledInput(csvCtrl, "CSV", isDark,
                          keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Save card checkbox
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
                    Text(
                      'Save this card for future use',
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Checkout Button
                Center(
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
                      _snack(
                        context,
                        'Order placed successfully! Total: ${total.toStringAsFixed(2)}',
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper for input style
  Widget _styledInput(TextEditingController ctrl, String label, bool isDark,
      {TextInputType? keyboardType, List<TextInputFormatter>? formatters}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.white54 : Colors.black38),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

// --- HELPERS ---
Future<bool> _confirm(BuildContext context, String title, String body) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Yes'),
        ),
      ],
    ),
  );
  return res ?? false;
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));
}

// --- EXPIRY FORMATTER ---
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 6) text = text.substring(0, 6);
    if (text.length >= 3) text = '${text.substring(0, 2)}/${text.substring(2)}';
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

// --- CART ITEM CARD ---
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool isDark;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final ValueChanged<ItemSize> onSizeChanged;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.isDark,
    required this.onIncrease,
    required this.onDecrease,
    required this.onSizeChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black;
    return Card(
      color: isDark ? Colors.grey[850] : null,
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
                        child: Text(
                          item.product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
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
                      Text('Size: ', style: TextStyle(color: textColor)),
                      DropdownButton<ItemSize>(
                        dropdownColor:
                            isDark ? Colors.grey[850] : Colors.white,
                        value: item.size,
                        underline: const SizedBox(),
                        items: ItemSize.values.map((sz) {
                          return DropdownMenuItem<ItemSize>(
                            value: sz,
                            child: Text(sz.label,
                                style: TextStyle(color: textColor)),
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
                          color: textColor.withOpacity(0.8),
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
                        child: Text(
                          '${item.qty}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                      ),
                      _QtyBtn(icon: Icons.add, onTap: onIncrease),
                      const Spacer(),
                      Text(
                        'Total: ${item.lineTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
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

// --- QTY BUTTON ---
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
