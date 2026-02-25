import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  double get totalPrice {
    return widget.cartItems
        .fold(0, (sum, item) => sum + item.totalPrice);
  }

  void submitOrder() {
  if (_formKey.currentState!.validate()) {

    setState(() {
      widget.cartItems.clear(); // kosongkan cart
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );

    Navigator.pop(context); // kembali ke cart
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...widget.cartItems.map((item) => ListTile(
                  title: Text(item.product.name),
                  subtitle: Text(
                      '${item.quantity} x Rp ${item.product.price.toStringAsFixed(0)}'),
                  trailing: Text(
                      'Rp ${item.totalPrice.toStringAsFixed(0)}'),
                )),

            const Divider(),

            Text(
              'Total: Rp ${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text(
              'Customer Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Full Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your name' : null,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration:
                        const InputDecoration(labelText: 'Address'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your address' : null,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your phone number' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitOrder,
                    child: const Text('Place Order'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}