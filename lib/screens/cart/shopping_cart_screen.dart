import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shopping_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<ShoppingProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F4), // off-white background
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: cartProvider.itemCount == 0
          ? Center(
              child: Text(
                "Your cart is empty!",
                style: GoogleFonts.poppins(
                    fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cartProvider.ingredients.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.ingredients[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Card(
                          color: Colors.white, // off-white card
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Text(
                              item,
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                cartProvider.removeIngredient(item);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement checkout or export list
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Proceed to buy functionality")),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag),
                    label: Text(
                      "Checkout (${cartProvider.itemCount})",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
