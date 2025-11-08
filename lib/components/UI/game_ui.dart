// import 'package:flame/components.dart';
import 'package:plant_game/components/UI/nav_bar.dart';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
class GameUI extends StatelessWidget {
  final Game gameRef;

  const GameUI({Key? key, required this.gameRef}) : super(key: key);

/*

  Currently this file is unused. Come back and make a text component that displays the player's money

*/


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.05,
            color: Colors.black54, // Background color
            child: const Center(
              child: Text(
                "Game UI Overlay",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          //child: NavBarWidget(),  // Place Nav Bar in the overlay
        ),
      ],
    );
  }
}