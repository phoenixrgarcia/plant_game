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

  static final Set<String> plantTypes = PlantData
      .plantTypes; //{"Crop", "Flower", "Tree", "Summer", "Winter", "Space", "Weapon"}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: plantTypes.length, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Shop"),
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
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

class _ShopTabState extends ConsumerState<ShopTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _globalFade;
  final Duration _stagger = const Duration(milliseconds: 120);

  final items =
      <Map<String, dynamic>>[]; // fill in from your getItemsForCategory

  @override
  void initState() {
    super.initState();
    // copy items from your getItemsForCategory(widget.category)
    items.addAll(getItemsForCategory(widget.category));

    _ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + items.length * 120));
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
    final plants = PlantData.getPlantsByType(widget.category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Theme description and tappable plant pictures
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme description
              Text(
                'Discover the ${widget.category} Plants!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              // Tappable pictures of plants sorted by rarity
              SizedBox(
                height: 100, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: plants.length, // Replace with your plant list
                  itemBuilder: (context, index) {
                    final plant = plants[index]; // Replace with your plant data
                    return GestureDetector(
                      onTap: () {
                        // Handle tap on plant picture
                        print('Tapped on ${plant.name}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Image.asset(
                              plant.imagePath, // Replace with your image path
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              plant.name, // Replace with your plant name
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Existing shop item cards
        ...List.generate(items.length, (index) {
          final item = items[index];
          final start = _stagger * index;
          final end = start + Duration(milliseconds: 400);
          final animation = CurvedAnimation(
            parent: _globalFade,
            curve: Interval(
              start.inMilliseconds / _ctrl.duration!.inMilliseconds,
              end.inMilliseconds / _ctrl.duration!.inMilliseconds,
              curve: Curves.easeOut,
            ),
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
                  final nextSeeds = getThreePlants(manager, plantType: widget.category);
                  final generated = nextSeeds.take(3).map((p) {
                    return {
                      'name': p.plantDataName,
                      'image': p.plantData.imagePath,
                      'stats': {'tier': p.tier},
                    };
                  }).toList();
                  // Handle buy action
                  showSeedPickOverlay(context, options: generated, onSelected: (chosen) {});
                },
              ),
            ),
          );
        }),
        ClassUpgradeCard(category: widget.category)
      ],
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final String name;
  final int price;
  final String image;
  final VoidCallback onBuy;
  const _ShopItemCard(
      {required this.name,
      required this.price,
      required this.image,
      required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.white, Colors.green.shade50]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(image), fit: BoxFit.contain),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          title:
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle:
              Text('\$${price}', style: const TextStyle(color: Colors.black54)),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(), elevation: 2),
            onPressed: onBuy,
            child: const Text('Buy'),
          ),
        ),
      ),
    );
  }
}

class ClassUpgradeCard extends StatelessWidget{
  final String category;
  final String image = "assets/images/upgrade_icon.png";

  ClassUpgradeCard({super.key, required this.category});

  @override
  Widget build(BuildContext context){
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.white, Colors.green.shade50]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(image), fit: BoxFit.contain),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          title:
              Text("Unlock ${category} seeds in the upgrade menu", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
    );
  }
}

List<Map<String, dynamic>> getItemsForCategory(String category) {
  bool isUnlocked =
      GameStateManager().state.shopState.unlockedPlantTypes[category] ?? false;
  int numberUnlocked =
      GameStateManager().state.shopState.seedTierUpgradeLevel[category]!;
  List<int> seedCosts =
      GameStateManager().state.shopState.seedCostMap[category]!;

  List<Map<String, dynamic>> items = [];
  List<String> rarityNames = [
    "Basic",
    "Rare",
    "Epic",
    "Legendary",
    "Mythic",
  ];

  if (!isUnlocked) {
    return [];
  }

  for (int i = 0; i < numberUnlocked; i++) {
    items.add({
      "name": "${rarityNames[i]} $category Seed",
      "price": seedCosts[i],
      "image": "assets/images/flower-seed.png"
    });
  }

  return items;
}

List<PlantInstance> getThreePlants(GameStateManager gameStateManager, {String? plantType}) {
  int seed = gameStateManager.state.nextShopRandomSeed;
  PlantInstance p1 = PlantInstance(
      plantDataName: PlantData.getWeightedRandom(seed, plantType: plantType), tier: randomTier(seed));
  seed++;
  PlantInstance p2 = PlantInstance(
      plantDataName: PlantData.getWeightedRandom(seed, plantType: plantType), tier: randomTier(seed));
  seed++;
  PlantInstance p3 = PlantInstance(
      plantDataName: PlantData.getWeightedRandom(seed, plantType: plantType), tier: randomTier(seed));
  return [p1, p2, p3];
}

int randomTier(int seed) {
  final random = Random(seed);
  int tier = 1;
  int probability = 60;
  int roll = random.nextInt(100);
  while (roll < probability) {
    tier++;
    if (probability > 20) probability -= 20;
    roll = random.nextInt(100);
  }
  return tier;
}
