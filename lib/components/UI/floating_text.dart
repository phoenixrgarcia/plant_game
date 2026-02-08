import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/widgets.dart';

class FloatingText extends TextComponent {
  double lifetime; // Time in seconds the text will be visible
  double elapsedTime = 0.0; // Time elapsed since the text was created
  Vector2 velocity;

  FloatingText({
    required String text,
    required Vector2 position,
    Vector2? velocity,
    this.lifetime = 1.0,
  })  : velocity = velocity ?? Vector2(0, -50),
        super(
            text: text,
            position: position,
            textRenderer: TextPaint(
                style:
                    TextStyle(color: const Color(0xFFFFFFFF), fontSize: 24, fontWeight: FontWeight.bold)),
            anchor: Anchor.topLeft,
            );

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;

    // Move the text based on its velocity
    position += velocity * dt;
    textRenderer = TextPaint(
        style: TextStyle(
            color: const Color(0xFFFFFFFF)
                .withValues(alpha: max(1 - (elapsedTime / lifetime), .1) ),
            fontSize: 24,
            fontWeight: FontWeight.bold));

    // Remove the text after its lifetime has expired
    if (elapsedTime >= lifetime) {
      removeFromParent();
    }
  }
}
