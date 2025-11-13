import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/components/UI/tick_timer.dart';
import 'package:plant_game/components/plants/data/plant_data.dart';
import 'package:plant_game/components/state/game_state.dart';
import 'package:plant_game/components/state/pot_state.dart';
import 'package:plant_game/game_state_manager.dart';
import '../../plant_game.dart';

class PotSprite extends SpriteComponent
    with HasGameRef<PlantGame>, TapCallbacks {
  PotState potState; // Reference to the PotState
  GameStateManager gameStateManager = GameStateManager();
  late TickTimer tickTimer;

  Sprite? plantSprite;
  String? currentSpritePath;

  PotSprite(
      {required this.potState,
      required Vector2 size,
      required Vector2 position})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Load the initial pot sprite (this would be a generic pot image)
    sprite = await gameRef.loadSprite('sample_pot.webp');
    gameStateManager.addListener(_onGameStateChanged);
    tickTimer = TickTimer(tickRate: 1.0)
      ..size = Vector2(size.x * 0.8, size.y * 0.1)
      ..position = Vector2(size.x * .5, size.y * 0.9)
      ..anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent event) {
    gameRef.greenhouseWorld.selectPot(this);

    if (!potState.isOccupied) {
      moveCameraToPot("top");
      gameRef.overlays.add('inventory');
    } else {
      moveCameraToPot("bottom");
      gameRef.overlays.add('plant_info');
    }

    return true; // Event handled
  }

  //Here we are using Offset to store a fraction value for x and y coordinates.
  Map<String, Offset> targetPotPositions = {
    'top': const Offset(.5, .3),
    'bottom': const Offset(.5, .75),
  };

  void moveCameraToPot(String targetPosition) {
    final camera = gameRef.camera;
    final xPositionFraction = targetPotPositions[targetPosition]!.dx;
    final yPositionFraction = targetPotPositions[targetPosition]!.dy;

    // Calculate new camera position to center the pot at the top
    final newCameraPosition = Vector2(
      position.x -
          gameRef.size.x * xPositionFraction +
          size.y / 2, // Keep X position the same

      position.y -
          gameRef.size.y * yPositionFraction +
          size.y / 2, // Move Y so pot is at the top
    );

    // Move the camera smoothly
    camera.moveTo(newCameraPosition, speed: 1000);
  }

  @override
  void render(Canvas canvas) {
    if (gameRef.greenhouseWorld.selectedPot.value == this) {
      renderSelectedPot(canvas);
    }

    super.render(canvas);

    if (plantSprite != null) {
      plantSprite!
          .render(canvas, size: size, position: Vector2(0, -size.y * 0.4));
    } else {}
  }

  void renderSelectedPot(Canvas canvas) {
    final glowPaint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    //canvas.drawRect(rect, paint);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x * .6, glowPaint);
  }

  Future<void> updatePlantSprite() async {
    if (potState.isOccupied) {
      final plantData =
          PlantData.getById(potState.currentPlant!.plantDataName)!;

      // Check if spritePath changed (e.g. due to growth)
      if(!potState.currentPlant!.isFullyGrown){
        plantSprite = Sprite(gameRef.images.fromCache("sprout.png"));
      } else if (plantData.spritePath != currentSpritePath) {
        plantSprite = Sprite(gameRef.images.fromCache(plantData.spritePath));
        currentSpritePath = plantData.spritePath;
      }
    } else {
      plantSprite = null;
      currentSpritePath = null;
    }
  }

  Future<void> updateTickTimer() async {
    //if the pot is newly planted, it needs a timer and the timer is set to the growth time
    //When the timer elapses, the plant grows
    if (potState.isOccupied && !children.contains(tickTimer) && !potState.currentPlant!.isFullyGrown) {
      final plantData =
          PlantData.getById(potState.currentPlant!.plantDataName)!;
      tickTimer.tickRate =
          plantData.growthTime; // Adjust tick rate based on growth time
      tickTimer.progress = 0;
      tickTimer.onTickCallback = () {
        potState.currentPlant!.isFullyGrown = true;
        updateTickTimer();
        updatePlantSprite();
      };
      add(tickTimer);
      print("checking children: ${children.contains(tickTimer)}");
    } 
    //when the plant fully grows, the timer is adjusted to the tick rate time
    else if(potState.isOccupied && potState.currentPlant!.isFullyGrown){
      final plantData = PlantData.getById(potState.currentPlant!.plantDataName)!;
      tickTimer.tickRate = plantData.tickRate;
      tickTimer.onTickCallback = onTickCallback;
    }
    //when the plant is harvested, or the pot is unplanted, the timer is removed
    else if (!potState.isOccupied){
      if (children.contains(tickTimer)) {
        remove(tickTimer);
      }
    }
  }

  void onTickCallback(){
    if (potState.isOccupied){
      gameRef.greenhouseWorld.tickPot(potState);
    }
  }

  void _onGameStateChanged() {
    // Update the potState reference in case it was replaced
    // potState = gameStateManager.state.pots.where((p) => p.row == potState.row && p.col == potState.col).first;
    updatePlantSprite(); // Update the plant sprite if needed
    updateTickTimer(); // Update the plant sprite if needed
  }
}
