import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
final formatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String searchQuery = '';
String selectedCategory = 'All';

List<String> categories = [
  'All',
  'Audio Interfaces',
  'MIDI Controllers',
  'Headphones',
  'Microphones',
  'Accessories',
];

  // Dummy Products
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Focusrite Scarlett 2i2',
      price: 2500000,
      category: 'Audio Interfaces',
      imageUrl: '',
    ),
    Product(
      id: '2',
      name: 'Akai MPK Mini MK3',
      price: 1800000,
      category: 'MIDI Controllers',
      imageUrl: '',
    ),
    Product(
      id: '3',
      name: 'ATH-M50x Headphones',
      price: 2000000,
      category: 'Headphones',
      imageUrl: '',
    ),
    Product(
      id: '4',
      name: 'BM800 Condenser Mic',
      price: 700000,
      category: 'Microphones',
      imageUrl: '',
    ),
    Product(
      id: '5',
      name: 'XLR Cable 3m',
      price: 150000,
      category: 'Accessories',
      imageUrl: '',
    ),
  ];

List<Product> get filteredProducts {
  return products.where((product) {
    final matchesSearch =
        product.name.toLowerCase().contains(searchQuery.toLowerCase());

    final matchesCategory =
        selectedCategory == 'All' ||
        product.category == selectedCategory;

    return matchesSearch && matchesCategory;
  }).toList();
}

  // Cart State
  List<CartItem> cartItems = [];

  void addToCart(Product product) {
    final index =
        cartItems.indexWhere((item) => item.product.id == product.id);

    setState(() {
      if (index >= 0) {
        cartItems[index].quantity++;
      } else {
        cartItems.add(CartItem(product: product));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BeatMart'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(cartItems: cartItems),
                    ),
                  ).then((_) {
                    setState(() {}); // refresh setelah balik
                  });
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search product',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    ),

    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        items: categories
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value!;
          });
        },
        decoration: const InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
      ),
    ),

    const SizedBox(height: 10),

    Expanded(
      child: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(product.name),
              subtitle: Text(
                  '${product.category} • Rp ${product.price.toStringAsFixed(0)}'),
              trailing: ElevatedButton(
                onPressed: () => addToCart(product),
                child: const Text('Add'),
              ),
            ),
          );
        },
      ),
    ),
  ],
)
);
}
}