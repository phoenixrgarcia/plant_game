import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:plant_game/game_state_manager.dart';
import 'package:plant_game/plant_game.dart';
import 'package:flame/text.dart';

class PurchasablePot extends SpriteComponent
    with HasGameRef<PlantGame>, TapCallbacks {
  final int row;
  final int col;
  final GameStateManager gameStateManager = GameStateManager();

  late final Sprite plusSprite;
  late final PriceBadgeComponent priceBadge;

  PurchasablePot(
      {required this.row,
      required this.col,
      required Vector2 size,
      required Vector2 position})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Load the initial pot sprite (this would be a generic pot image)
    sprite = await gameRef.loadSprite('sample_pot_grey.png');
    plusSprite = await gameRef.loadSprite('plus_icon.png');

    priceBadge = PriceBadgeComponent(
      cost: gameStateManager.state.potCost,
      position: Vector2(size.x / 2, size.y + 6),
    );

    add(priceBadge);
  }

  @override
  void update(double dt) {
    super.update(dt);
    priceBadge.cost = gameStateManager.state.potCost;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    gameRef.greenhouseWorld.pendingPotRow = row;
    gameRef.greenhouseWorld.pendingPotCol = col;
    gameRef.overlays.add('purchase_pot_dialog');
    return true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (gameStateManager.state.money >= gameStateManager.state.potCost) {
      plusSprite.render(canvas,
          size: Vector2(size.x * .45, size.y * .45),
          anchor: Anchor.center,
          position: size / 2 + Vector2(0, 4));
    }
  }

  @override
  void removeFromParent() {
    // Clean up resources if needed
    super.removeFromParent();
  }
}

class PriceBadgeComponent extends PositionComponent with HasGameRef<PlantGame> {
  double _cost;

  late final Sprite _coinSprite;
  late final TextComponent _costText;

  static const double _badgeHeight = 24;
  static const double _horizontalPadding = 8;
  static const double _iconSize = 14;
  static const double _gap = 4;
  static const double _cornerRadius = 999;

  final TextPaint _textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFFFFF),
    ),
  );

  final Paint _backgroundPaint = Paint()
    ..color = const Color(0xFF8F8F8F).withValues(alpha: 0.92);

  final Paint _borderPaint = Paint()
    ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.18)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  PriceBadgeComponent({
    required double cost,
    required Vector2 position,
  })  : _cost = cost,
        super(
          position: position,
          anchor: Anchor.topCenter,
        );

  set cost(double value) {
    if (_cost == value) return;
    _cost = value;
    _costText.text = _label;
    _relayout();
  }

  String get _label => _cost.toStringAsFixed(0);

  @override
  Future<void> onLoad() async {
    _coinSprite = await gameRef.loadSprite('coin.png');

    _costText = TextComponent(
      text: _label,
      textRenderer: _textPaint,
      anchor: Anchor.centerLeft,
    );

    add(_costText);
    _relayout();
  }

  void _relayout() {
    //TODO find a better way to resize the badge based on the number of chars in the number. Replace the 18 in the formula below.
    size =
        Vector2(_horizontalPadding * 2 + _iconSize + _gap + 18, _badgeHeight);

    _costText.position = Vector2(
      _horizontalPadding + _iconSize + _gap,
      size.y / 2,
    );
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(_cornerRadius),
    );

    canvas.drawRRect(rrect, _backgroundPaint);
    canvas.drawRRect(rrect, _borderPaint);

    _coinSprite.render(
      canvas,
      position: Vector2(_horizontalPadding + _iconSize / 2, size.y / 2),
      size: Vector2.all(_iconSize),
      anchor: Anchor.center,
    );

    super.render(canvas);
  }
}
