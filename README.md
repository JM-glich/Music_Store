# Music_Store
Nama: Jemis Movid (2409116070).

# 🎧 BeatMart - Music Equipment Store App

BeatMart adalah aplikasi mobile sederhana berbasis Flutter yang mensimulasikan sistem e-commerce untuk pembelian perlengkapan studio musik seperti audio interface, MIDI controller, microphone, dan aksesoris lainnya.

Aplikasi ini dibuat untuk memenuhi tugas mata kuliah Pemrograman Aplikasi Bergerak dengan fitur Shopping Cart Enhancement.

---

## 📱 Deskripsi Aplikasi

BeatMart memungkinkan pengguna untuk:

- Melihat daftar produk perlengkapan musik
- Mencari produk berdasarkan nama
- Memfilter produk berdasarkan kategori
- Menambahkan produk ke keranjang
- Mengatur jumlah produk di keranjang
- Menghapus produk dari keranjang
- Melihat total harga secara otomatis
- Melakukan checkout dengan mengisi data pelanggan

Aplikasi ini menggunakan pendekatan stateful widget dan manajemen state sederhana menggunakan setState().

---

## 🚀 Fitur Aplikasi

### ✅ Fitur Wajib
- Add to Cart dari halaman produk
- Menampilkan item dalam cart beserta quantity
- Update quantity (+ / -)
- Remove item dari cart
- Menampilkan total harga secara otomatis

### ⭐ Fitur Bonus
- Search produk berdasarkan nama
- Filter berdasarkan kategori
- Checkout page dengan order summary dan form (Nama, Alamat, No HP)
- Multi Page Navigation

---

## 🧩 Widget yang Digunakan

Beberapa widget utama yang digunakan dalam aplikasi ini:

- MaterialApp
- Scaffold
- AppBar
- ListView.builder
- Card
- ListTile
- TextField
- TextFormField
- DropdownButtonFormField
- ElevatedButton
- IconButton
- Navigator
- SnackBar
- Stack (untuk cart badge)
- Form & GlobalKey

---

## 🗂 Struktur Foldernya

<img width="208" height="427" alt="image" src="https://github.com/user-attachments/assets/46aeaee2-38b5-4668-aad7-3ed3e2edd871" />
---

## 🛠 Teknologi yang Digunakan

- Flutter
- Dart
- intl package (untuk formatting mata uang Rupiah)
- Material Design 3

## Code-nya
**Create new file**: `lib/models/product.dart`

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
  });
}
```

**Create new file**: `lib/models/cart_item.dart`

```dart
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice {
    return product.price * quantity;
  }
}
```

**Create new file**: `lib/screens/home_screen.dart`

```dart
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
```

**Create new file**: `lib/models/cart_screen.dart`

```dart
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
```

**Create new file**: `lib/models/cheackout_screen.dart`

```dart
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
```
# 🔎 Penjelasan Alur Program

## 1️⃣ Inisialisasi Aplikasi

Program dimulai dari file `main.dart`, di mana fungsi `main()` memanggil `runApp()` untuk menjalankan widget utama yaitu `MyApp`.

Pada bagian ini juga ditentukan:
- Tema aplikasi (ThemeData)
- Halaman awal (`HomeScreen`) sebagai entry point aplikasi

---

## 2️⃣ Home Screen (Halaman Produk)

`HomeScreen` merupakan halaman utama yang menampilkan daftar produk menggunakan `ListView.builder`.

### 🔹 Alur Kerja:

- Data produk disimpan dalam bentuk `List<Product>`
- User dapat melakukan pencarian melalui `TextField`
- User dapat memfilter produk berdasarkan kategori menggunakan `DropdownButtonFormField`
- Produk yang ditampilkan merupakan hasil filtering dari:
  - Search Query
  - Selected Category

### 🛒 Ketika tombol "Add" ditekan:

- Sistem mengecek apakah produk sudah ada di cart
- Jika sudah ada → quantity bertambah
- Jika belum ada → dibuat objek `CartItem` baru
- Badge pada icon cart otomatis ter-update

---

## 3️⃣ Cart Screen (Halaman Keranjang)

Halaman ini menerima parameter `List<CartItem>` dari `HomeScreen` melalui `Navigator.push()`.

### 🔹 Fitur yang tersedia:

- Menampilkan item cart menggunakan `ListView.builder`
- Menambah quantity dengan tombol (+)
- Mengurangi quantity dengan tombol (-)
- Menghapus item menggunakan tombol delete
- Menghitung total harga secara otomatis menggunakan method `fold()`

### 💰 Perhitungan Total Harga:

Total harga dihitung dengan menjumlahkan seluruh `totalPrice` dari setiap `CartItem`.

---

## 4️⃣ Checkout Screen

`CheckoutScreen` menerima data `cartItems` dari `CartScreen`.

### 🔹 Komponen pada halaman ini:

- Order Summary (menampilkan daftar item yang akan dibeli)
- Form input menggunakan `Form` dan `GlobalKey`
- 3 `TextFormField`:
  - Nama
  - Alamat
  - Nomor Telepon
- Validasi input sebelum pesanan diproses

### 📦 Ketika tombol "Place Order" ditekan:

- Sistem melakukan validasi form
- Jika valid → cart dikosongkan
- Snackbar ditampilkan sebagai notifikasi
- User kembali ke halaman sebelumnya

---

## 5️⃣ Manajemen State

Aplikasi ini menggunakan pendekatan sederhana dengan:

- `StatefulWidget`
- `setState()`

Digunakan untuk mengatur perubahan data seperti:
- Penambahan item ke cart
- Perubahan quantity
- Penghapusan item
- Filtering produk

Pendekatan ini cukup efektif untuk aplikasi skala kecil.

---

## 6️⃣ Navigasi Antar Halaman

Navigasi dilakukan menggunakan:

```dart
Navigator.push()

---


