import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/providers/ingredients/ingredient_provider.dart';
import 'package:urban_toast/screens/product_detail_screen/components/landscape/product_content_landscape.dart';
import 'package:urban_toast/screens/product_detail_screen/components/landscape/product_img_landscape.dart';
import 'package:urban_toast/screens/product_detail_screen/components/product_content.dart';
import 'package:urban_toast/screens/product_detail_screen/components/product_img.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IngredientProvider(),
      child: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _portraitBuilder(context, product)
              : _landscapeBuilder(context, product);
        },
      ),
    );
  }
}

Widget _portraitBuilder(BuildContext context, Product product) {
  final ingredientProvider = context.watch<IngredientProvider>();

  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ProductImage(product: product),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await ingredientProvider.loadIngredients(product.id);
              if (!context.mounted) return;
              _showIngredientsSheet(context, ingredientProvider);
            },
            icon: const Icon(Icons.keyboard_arrow_up),
            label: const Text("More Details"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ProductContent(product: product),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _landscapeBuilder(BuildContext context, Product product) {
  final ingredientProvider = context.watch<IngredientProvider>();

  return SafeArea(
    child: Row(
      children: [
        Expanded(
          flex: 5,
          child: Center(
            child: ProductImageLandscape(product: product, height: 0.8),
          ),
        ),
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await ingredientProvider.loadIngredients(product.id);
                    if (!context.mounted) return;
                    _showIngredientsSheet(context, ingredientProvider);
                  },
                  icon: const Icon(Icons.keyboard_arrow_up),
                  label: const Text("More Details"),
                ),
                ProductContentLandscape(product: product),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

void _showIngredientsSheet(BuildContext context, IngredientProvider provider) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.ingredients.isEmpty
                ? const Center(
                    child: Text(
                      "No ingredient details available.",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ingredients",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...provider.ingredients.map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                "• $e",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    ),
  );
}

