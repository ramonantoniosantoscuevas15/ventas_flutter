import 'package:flutter/material.dart';
import 'package:login_y_formulario/models/models.dart';
import 'package:login_y_formulario/screens/screens.dart';

import 'package:login_y_formulario/services/services.dart';
import 'package:provider/provider.dart';

import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    if (productsService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Productos'),
        actions: [
          IconButton(
              icon: const Icon(Icons.login_outlined),
              onPressed: (() {
                authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              }))
        ],
      ),
      body: ListView.builder(
          itemCount: productsService.products.length,
          itemBuilder: ((context, index) => GestureDetector(
              onTap: (() {
                productsService.selectedProduct =
                    productsService.products[index].copy();
                Navigator.pushNamed(context, 'product');
              }),
              child: ProductCard(
                product: productsService.products[index],
              )))),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productsService.selectedProduct =
              Product(available: true, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
