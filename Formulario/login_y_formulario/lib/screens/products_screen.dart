import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_y_formulario/providers/product_form_provider.dart';
import 'package:login_y_formulario/services/services.dart';

import 'package:login_y_formulario/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../ui/input_decoration.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct),
      child: _ProductScreenBody(productsService: productsService),
    );
    //return _ProductScreenBody(productsService: productsService);
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        //controller: controller,
        child: Column(
          children: [
            Stack(
              children: [
                Productimage(
                  url: productsService.selectedProduct.picture,
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.camera);
                      productsService
                          .updatedSelectProductImage(pickedFile!.path);
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const _ProductForm(),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (productsService.isSaving
        ? null
        :()async {
          if (!productForm.isValidForm()) return;
          final String? imageurl = await productsService.uploadImage();
          if (imageurl != null) {
            productForm.product.picture = imageurl;
          }
          await productsService.saveOrCreateProduct(productForm.product);
        }),
        child: productsService.isSaving
        ? const CircularProgressIndicator(color:  Colors.white,)
        :const Icon(Icons.save_outlined),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: productForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: product.name,
                  onChanged: ((value) => product.name = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El Nombre Es Obligatorio';
                    }
                  },
                  decoration: InputDecorations.authInputDecoration(
                      hintext: 'Nombre del Producto', labelText: 'Nombre:'),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: '${product.price}',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: ((value) {
                    if (double.tryParse(value) == null) {
                      product.price = 0;
                    } else {
                      product.price = double.parse(value);
                    }
                  }),
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                      hintext: '\$150', labelText: 'Precio:'),
                ),
                const SizedBox(
                  height: 30,
                ),
                SwitchListTile.adaptive(
                    value: product.available,
                    title: const Text('Disponible'),
                    activeColor: Colors.indigo,
                    onChanged: productForm.updateAvailability),
                const SizedBox(
                  height: 30,
                ),
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]);
}
