import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  final VoidCallback onClose;
  final List<String> items = ["Carrot", "Rose", "Oak Tree"];
  final List<int> quantities = [5, 2, 1];

  InventoryScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // 👈 Wrap in Scaffold
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.4, // Takes up 40% of the screen
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Inventory",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onClose, // Close the inventory
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Material(
                        child: ListView.builder(
                  itemCount: items
                      .length, // Will loop through "Carrot", "Rose", "Oak Tree"
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: Text(items[index]), // "Carrot", "Rose", "Oak Tree"
                      subtitle: Text(
                          "Quantity: ${quantities[index]}"), // "5", "2", "1"
                    );
                  },
                ))),
              ],
            ),
          ),
        ));
  }
}
