

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/game_state_provider.dart';

import '../components/plants/data/plant_data.dart';

class UpgradeScreen extends StatelessWidget{
  const UpgradeScreen({super.key});

  static final Set<String> plantTypes = PlantData.plantTypes; 

  @override 
  Widget build(BuildContext context){
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
          children: plantTypes.map((type) => UpgradeTab(category: type)).toList(),
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

class _UpgradeTabState extends ConsumerState<UpgradeTab> with SingleTickerProviderStateMixin{
  late final AnimationController _ctrl;
  late final Animation<double> _globalFade;
  final Duration _stagger = const Duration(milliseconds: 120);

  Map<String, int> upgradeStates = {};

  @override 
  void initState(){
    super.initState();

    upgradeStates.addAll(getUpgradesForCategory(widget.category));

    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + upgradeStates.length * _stagger.inMilliseconds),
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
      
    );
  }
}

Map<String, int> getUpgradesForCategory(String category) {
  return GameStateManager().state.upgradeState.upgradesPurchased[category]!;
}
  