import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:plant_game/plant_game.dart';

class TickTimer extends PositionComponent with HasGameRef<PlantGame> {
  double progress = 0.0; // Current progress in seconds
  double tickRate; // Time (in seconds) for a full tick

  final Paint borderPaint;
  final Paint fillPaint;

  TickTimer({this.tickRate = 5.0}) // Default tick rate: 5 seconds
      : borderPaint = Paint()
          ..color = const Color(0xFF444444) // Border color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0,
        fillPaint = Paint()
          ..color = const Color(0xFF76C893) // Fill color (green)
          ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the border
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.y / 2));
    canvas.drawRRect(rrect, borderPaint);

    // Draw the filled progress bar
    final tickFraction = progress / tickRate;
    final fillWidth = tickFraction * size.x; // Calculate width based on progress
    final fillRect = Rect.fromLTWH(0, 0, fillWidth, size.y);
    final fillRRect =
        RRect.fromRectAndRadius(fillRect, Radius.circular(size.y / 2));
    canvas.drawRRect(fillRRect, fillPaint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update progress based on delta time
    progress += dt / tickRate;

    if (progress >= 1.0) {
      // Trigger a tick when the bar is full
      onTick();
      progress -= 1.0; // Reset progress
    }
  }

  void onTick() {
    gameRef.greenhouseWorld.tick();
  }
}
