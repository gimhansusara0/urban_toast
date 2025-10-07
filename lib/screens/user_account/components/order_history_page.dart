import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urban_toast/screens/user_account/services/order_service.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: FutureBuilder(
        future: OrderService.getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final order = orders[i];
              final createdAt = (order['createdAt'] as Timestamp?)?.toDate();
              final items = order['items'] as List<dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text('Order #${order['id']}'),
                  subtitle: Text(
                    'Date: ${createdAt != null ? createdAt.toLocal().toString().split(" ")[0] : 'N/A'}\n'
                    'Items: ${items.length}',
                  ),
                  trailing: Text(
                    'Rs. ${order['total'].toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Theme.of(context).cardColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      builder: (_) => ListView(
                        padding: const EdgeInsets.all(12),
                        children: [
                          Text(
                            'Order Details',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          ...items.map((item) {
                            return ListTile(
                              title: Text(item['productName']),
                              subtitle: Text('Qty: ${item['qty']} | Size: ${item['size']}'),
                              trailing: Text('Rs. ${item['lineTotal']}'),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
