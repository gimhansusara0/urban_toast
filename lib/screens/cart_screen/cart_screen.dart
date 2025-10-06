import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/cart/cart_provider.dart';
import 'package:urban_toast/providers/orders/orders_provider.dart';
import '../../models/cart_item.dart';

class CartPage extends StatelessWidget {
  final String userId;
  const CartPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) {
              if (!cart.selectionMode) return const SizedBox.shrink();
              final anySelected = cart.selectedProductIds.isNotEmpty;
              return Row(
                children: [
                  if (anySelected)
                    IconButton(
                      tooltip: 'Delete selected',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final ok = await _confirm(context,
                            'Remove selected items?', 'This cannot be undone.');
                        if (ok) {
                          await cart.bulkRemoveSelected();
                          _snack(context, 'Selected items removed');
                        }
                      },
                    ),
                  IconButton(
                    tooltip: 'Exit selection',
                    icon: const Icon(Icons.close),
                    onPressed: () => cart.exitSelectionMode(),
                  ),
                ],
              );
            },
          ),
        ],
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
                    final selected = cart.selectedProductIds.contains(productId);

                    return GestureDetector(
                      onLongPress: () {
                        cart.enterSelectionMode();
                        cart.toggleSelection(productId);
                      },
                      onTap: () {
                        // "keep clicking on a card" => in selection mode, toggle checkbox.
                        if (cart.selectionMode) {
                          cart.toggleSelection(productId);
                        }
                      },
                      child: _CartItemCard(
                        item: item,
                        showCheckbox: cart.selectionMode,
                        selected: selected,
                        onToggleSelected: () => cart.toggleSelection(productId),
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
                      ),
                    );
                  },
                ),
              ),

              // Bottom summary & actions
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
                        onPressed: () => _onCheckout(context, userId),
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

  Future<void> _onCheckout(BuildContext context, String userId) async {
    final cart = context.read<CartProvider>();
    final orders = context.read<OrdersProvider>();

    if (cart.items.isEmpty) {
      _snack(context, 'Cart is empty');
      return;
    }

    // Create an Order & PurchaseLog, then clear cart
    orders.addOrderFromCart(userId: userId, cartItems: cart.items);
    final total = cart.subTotal;
    cart.clearCart();

    _snack(context, 'Order placed! Total ${total.toStringAsFixed(2)}');
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool showCheckbox;
  final bool selected;
  final VoidCallback onToggleSelected;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final ValueChanged<ItemSize> onSizeChanged;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.showCheckbox,
    required this.selected,
    required this.onToggleSelected,
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
            if (showCheckbox) ...[
              Checkbox(
                value: selected,
                onChanged: (_) => onToggleSelected(),
              ),
              const SizedBox(width: 8),
            ],

            // Thumbnail placeholder (swap to your product image if you have one)
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

            // Main info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & remove
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.product.name,
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
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

                  // Size selector
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

                  // Qty +/-
                  Row(
                    children: [
                      _QtyBtn(icon: Icons.remove, onTap: onDecrease),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.qty}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                      _QtyBtn(icon: Icons.add, onTap: onIncrease),
                      const Spacer(),
                      Text(
                        'Total: ${item.lineTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
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

// helpers
Future<bool> _confirm(BuildContext context, String title, String body) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
      ],
    ),
  );
  return res ?? false;
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
