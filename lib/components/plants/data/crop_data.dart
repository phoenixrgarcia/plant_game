import '../crop.dart';

final List<Crop> cropData = [
  Crop(
    name: 'Tomato',
    growthTime: 10,
    sellPrice: 15,
    incomeRate: 2,
    spritePath: 'assets/images/tomato.png',
    onHarvest: () => print('Tomato harvested!'),
    onTick: () => print('Tomato ticked!'),
  ),
  Crop(
    name: 'Carrot',
    growthTime: 15,
    sellPrice: 20,
    incomeRate: 3,
    spritePath: 'assets/images/carrot.png',
    onHarvest: () => print('Carrot harvested!'),
    onTick: () => print('Carrot ticked!'),
  ),
];
