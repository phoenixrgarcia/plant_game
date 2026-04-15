import 'dart:math' as math;

import 'package:hive/hive.dart';
import 'package:plant_game/game_state_manager.dart';

part 'investor_state.g.dart';

@HiveType(typeId: 6)
class InvestorState extends HiveObject {
  @HiveField(0)
  int investorsAttracted;

  final functions = {
    'investorThreshold': (int currentInvestors) => currentInvestors * 2,
  };

  InvestorState({this.investorsAttracted = 0});

  void attractInvestor() {
    investorsAttracted++;
  }

  int nextInvestorThreshold() {
    return functions['investorThreshold']!(investorsAttracted);
  } 
}