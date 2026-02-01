import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/game_state_provider.dart';

import '../components/plants/data/plant_data.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  static final Set<String> plantTypes = PlantData.plantTypes;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: plantTypes.length, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Upgrades"),
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: plantTypes.map((type) => Tab(text: type)).toList(),
          ),
        ),
        body: TabBarView(
          children:
              plantTypes.map((type) => UpgradeTab(category: type)).toList(),
        ),
      ),
    );
  }
}

class UpgradeTab extends ConsumerStatefulWidget {
  final String category;
  const UpgradeTab({super.key, required this.category});

  @override
  ConsumerState<UpgradeTab> createState() => _UpgradeTabState();
}

class _UpgradeTabState extends ConsumerState<UpgradeTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _globalFade;
  final Duration _stagger = const Duration(milliseconds: 120);

  Map<String, int> upgradeStates = {};

  @override
  void initState() {
    super.initState();

    upgradeStates.addAll(getUpgradesForCategory(widget.category));

    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: 400 + upgradeStates.length * _stagger.inMilliseconds),
    );
    _globalFade = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOut,
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(gameStateManagerProvider);
    final gamestate = manager.state;
    final plants = PlantData.getPlantsByType(widget.category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(upgradeStates.length, (index) {
          final upgrade = upgradeStates.keys.elementAt(index);
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: _UpgradeItemCard(
                      name: "${widget.category} ${upgrade} increase",
                      price: manager.state.upgradeState
                          .upgradesCost[widget.category]![upgrade]!,
                      image: "assets/images/upgrade_icon.png",
                      onBuy: () {
                        final success =
                            manager.purchaseUpgrade(widget.category, upgrade);
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Not enough money to purchase upgrade.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      })));
        })
      ],
    );
  }
}

class _UpgradeItemCard extends StatelessWidget {
  final String name;
  final int price;
  final String image;
  final VoidCallback onBuy;
  const _UpgradeItemCard({
    required this.name,
    required this.price,
    required this.image,
    required this.onBuy,
  });

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

Map<String, int> getUpgradesForCategory(String category) {
  return GameStateManager().state.upgradeState.upgradesPurchased[category]!;
}
