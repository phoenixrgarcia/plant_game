import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Shop"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Vegetables"),
              Tab(text: "Flowers"),
              Tab(text: "Trees"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ShopTab(category: "Vegetables"),
            ShopTab(category: "Flowers"),
            ShopTab(category: "Trees"),
          ],
        ),
      ),
    );
  }
}

class ShopTab extends StatelessWidget {
  final String category;

  const ShopTab({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = getItemsForCategory(category);

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Image.asset(item["image"], width: 50, height: 50),
            title: Text(item["name"]),
            subtitle: Text("\$${item["price"]}"),
            trailing: ElevatedButton(
              onPressed: () {
                // Handle purchase logic here
                print("Buying ${item["name"]}");
              },
              child: const Text("Buy"),
            ),
          ),
        );
      },
    );
  }
}

/// Function to return items based on the category
List<Map<String, dynamic>> getItemsForCategory(String category) {
  switch (category) {
    case "Vegetables":
      return [
        {"name": "Carrot", "price": 10, "image": "assets/images/carrot.png"},
        {"name": "Tomato", "price": 15, "image": "assets/images/tomato.png"},
      ];
    case "Flowers":
      return [
        {"name": "Rose", "price": 20, "image": "assets/images/rose.png"},
        {"name": "Tulip", "price": 25, "image": "assets/images/tulip.jpg"},
      ];
    case "Trees":
      return [
        {"name": "Oak Tree", "price": 50, "image": "assets/images/oak_tree.jpg"},
        {"name": "Pine Tree", "price": 60, "image": "assets/images/pine_tree.png"},
      ];
    default:
      return [];
  }
}
