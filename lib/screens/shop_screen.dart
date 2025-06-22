import 'package:flutter/material.dart';

// This screen is a flutter widget instead of a flame component.
// It displays a shop with different categories of items.

class ShopScreen extends StatelessWidget {
  final void Function(String itemName, int price) onBuy;

  const ShopScreen({super.key, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Shop"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Crops"),
              Tab(text: "Flowers"),
              Tab(text: "Trees"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ShopTab(category: "Crops", onBuy: onBuy,),
            ShopTab(category: "Flowers", onBuy: onBuy,),
            ShopTab(category: "Trees", onBuy: onBuy,),
          ],
        ),
      ),
    );
  }
}

class ShopTab extends StatelessWidget {
  final String category;
  final void Function(String itemName, int price) onBuy;

  const ShopTab({super.key, required this.category, required this.onBuy});

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
                onBuy(item["name"], item["price"]);
              },
              child: const Text("Buy"),
            ),
          ),
        );
      },
    );
  }
}

/// TODO: eventually, these will have to be replaced with something like ShopEntry. This will allow the shop price to increase every time. This will also allow the rarities of specific plants to change as well. 
/// Function to return items based on the category
List<Map<String, dynamic>> getItemsForCategory(String category) {
  switch (category) {
    case "Crops":
      return [
        {"name": "Basic Crop Seed", "price": 10, "image": "assets/images/carrot.png"},
        {"name": "Rare Crop Seed", "price": 15, "image": "assets/images/tomato.png"},
        {"name": "Mythic Crop Seed", "price": 15, "image": "assets/images/tomato.png"},
      ];
    case "Flowers":
      return [
        {"name": "Basic Flower Seed", "price": 20, "image": "assets/images/rose.png"},
        {"name": "Rare Flower Seed", "price": 25, "image": "assets/images/tulip.jpg"},
      ];
    case "Trees":
      return [
        {"name": "Basic Tree Seed", "price": 50, "image": "assets/images/oak_tree.jpg"},
        {"name": "Rare Tree Seed", "price": 60, "image": "assets/images/pine_tree.png"},
      ];
    default:
      return [];
  }
}
