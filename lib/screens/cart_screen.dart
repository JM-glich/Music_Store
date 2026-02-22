import 'package:intl/intl.dart';
import 'checkout_screen.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
final formatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

  void increaseQuantity(int index) {
    setState(() {
      widget.cartItems[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (widget.cartItems[index].quantity > 1) {
        widget.cartItems[index].quantity--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
  }

  double get totalPrice {
    return widget.cartItems
        .fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(item.product.name),
                          subtitle: Text(
                              'Rp ${item.product.price.toStringAsFixed(0)}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => decreaseQuantity(index),
                                  ),
                                  Text(item.quantity.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => increaseQuantity(index),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeItem(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Total: Rp ${totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(cartItems: widget.cartItems),
                            ),
                          );
                        },
                        child: const Text('Checkout'),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}