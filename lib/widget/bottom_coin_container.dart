import 'package:flutter/material.dart';
import 'package:paistats/models/Coin.dart';
import '../themes/theme.dart';

class BottomCoinRow extends StatelessWidget {
  String selected;
  double spacing = 55;
  Function callback;

  BottomCoinRow({required this.callback, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Material();
  }
}
