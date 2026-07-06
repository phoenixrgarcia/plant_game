import 'dart:math' as math;

import 'package:hive/hive.dart';
import 'package:plant_game/game_state_manager.dart';

part 'investor_state.g.dart';

@HiveType(typeId: 6)
class InvestorState extends HiveObject {
  @HiveField(0)
  int investorsAttracted;

  @HiveField(1)
  int currentInvestors;

  final functions = {
    'investorThreshold': (int investorsAttracted) =>
        50 * math.pow(2, investorsAttracted),
  };

  InvestorState({this.investorsAttracted = 0, this.currentInvestors = 0});

  void attractInvestor() {
    investorsAttracted++;
    currentInvestors++;
  }

  num nextInvestorThreshold() {
    return functions['investorThreshold']!(investorsAttracted);
  }

  void resetInvestors() {
    investorsAttracted = 0;
  }
}
