import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/plants/plant.dart';
import 'package:plant_game/components/plants/plant_instance.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/game_state_provider.dart';
import 'seed_pick_overlay.dart';

// This screen is a flutter widget instead of a flame component.
// It displays a shop with different categories of items.

class ShopScreen extends StatelessWidget {

  const ShopScreen({super.key});

  static final Set<String> plantTypes = PlantData.plantTypes;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Shop"),
          bottom: TabBar(
            isScrollable: true,
            tabs: plantTypes.map((type) => Tab(text: type)).toList(),
          ),
        ),
        body: TabBarView(
          children: plantTypes.map((type) => ShopTab(category: type)).toList(),
        ),
      ),
    );
  }
}

class ShopTab extends ConsumerStatefulWidget {
  final String category;
  const ShopTab({super.key, required this.category});

  @override
  ConsumerState<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends ConsumerState<ShopTab> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _globalFade;
  final Duration _stagger = const Duration(milliseconds: 120);

  final items = <Map<String, dynamic>>[]; // fill in from your getItemsForCategory

  @override
  void initState() {
    super.initState();
    // copy items from your getItemsForCategory(widget.category)
    items.addAll(getItemsForCategory(widget.category));

    _ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 400 + items.length * 120));
    _globalFade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the GameStateManager so the tab rebuilds when game state changes.
    final manager = ref.watch(gameStateManagerProvider);
    final gameState = manager.state;

    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/blue_background.jpg', // pick a background you have
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.25),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        FadeTransition(
          opacity: _globalFade,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              // create staggered animation intervals
              final start = (i * _stagger.inMilliseconds) / _ctrl.duration!.inMilliseconds;
              final end = ((i * _stagger.inMilliseconds) + 400) / _ctrl.duration!.inMilliseconds;
              final animation = CurvedAnimation(
                parent: _ctrl,
                curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOut),
              );

              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final t = animation.value;
                  return Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, (1 - t) * 16),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: _ShopItemCard(
                    name: item['name'],
                    price: item['price'],
                    image: item['image'],
                    onBuy: () {
                      // Example: read a list from the game state and convert to overlay
                      // options. Here we use `nextSeeds` (List<PlantInstance>) as an
                      // example; replace with the list you actually want to check.
                      final nextSeeds = getThreePlants(manager);

                      final generated = nextSeeds.take(3).map((p) {
                        return {
                          'name': p.plantDataName,
                          'image': p.plantData.imagePath,
                          'stats': {'tier': p.tier}
                          // eventually change this to plant data card when you tap on one? 
                        };
                      }).toList();

                      showSeedPickOverlay(context, options: generated, onSelected: (chosen) {
                        // TODO: apply chosen to game state via manager (e.g., add to inventory)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Selected ${chosen['name']}')),
                        );
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final String name;
  final int price;
  final String image;
  final VoidCallback onBuy;
  const _ShopItemCard({required this.name, required this.price, required this.image, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Colors.green.shade50]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(image), fit: BoxFit.contain),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('\$${price}', style: const TextStyle(color: Colors.black54)),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(shape: const StadiumBorder(), elevation: 2),
            onPressed: onBuy,
            child: const Text('Buy'),
          ),
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> getItemsForCategory(String category) {
  switch (category) {
    case "Crop":
      return [
        {"name": "Basic Crop Seed", "price": 10, "image": "assets/images/flower-seed.png"},
        {"name": "Rare Crop Seed", "price": 100, "image": "assets/images/flower-seed.png"},
        {"name": "Mythic Crop Seed", "price": 500, "image": "assets/images/flower-seed.png"},
      ];
    case "Flower":
      return [
        {"name": "Basic Flower Seed", "price": 20, "image": "assets/images/flower-seed.png"},
        {"name": "Rare Flower Seed", "price": 200, "image": "assets/images/flower-seed.png"},
      ];
    case "Tree":
      return [
        {"name": "Basic Tree Seed", "price": 50, "image": "assets/images/flower-seed.png"},
        {"name": "Rare Tree Seed", "price": 500, "image": "assets/images/flower-seed.png"},
      ];
    default:
      return [];
  }
}

List<PlantInstance> getThreePlants(GameStateManager gameStateManager) {
  int seed = gameStateManager.state.nextShopRandomSeed;
  PlantInstance p1 = PlantInstance(plantDataName: PlantData.getWeightedRandom(seed), tier: randomTier(seed));
  seed++;
  PlantInstance p2 = PlantInstance(plantDataName: PlantData.getWeightedRandom(seed), tier: randomTier(seed));
  seed++;
  PlantInstance p3 = PlantInstance(plantDataName: PlantData.getWeightedRandom(seed), tier: randomTier(seed));
  return [p1, p2, p3];
}

int randomTier(int seed) {
  final random = Random(seed);
  int tier = 1;
  int probability = 60;
  int roll = random.nextInt(100);
  while (roll < probability) {
    tier++;
    if(probability > 20) probability -= 20;
    roll = random.nextInt(100);
  }
  return tier;
}