import 'package:flutter/material.dart';
import 'package:paistats/models/Coin.dart';
import '../themes/theme.dart';

class CoinUI extends StatelessWidget {
  final Coin coin;
  final VoidCallback pressAction;

  CoinUI({required this.coin, required this.pressAction});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        print(coin.symbol);
      },
      child: Material(
        borderRadius: BorderRadius.circular(14.0),
        elevation: 0,
        child: Container(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(this.coin.base.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text("/" + this.coin.quote.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white60,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(this.coin.name.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.lime,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                )),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(5))),
      ),
    );
  }
}
