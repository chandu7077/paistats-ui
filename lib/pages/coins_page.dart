import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:paistats/models/Coin.dart';
import 'package:paistats/models/Exchange.dart';
import 'package:paistats/widget/bottom_coin_container.dart';
import 'package:paistats/widget/coin_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/theme.dart';
import 'package:http/http.dart' as http;

class CoinsPage extends StatefulWidget {
  final String exchange;
  final String root_url;

  CoinsPage({required this.root_url, required this.exchange});

  @override
  _CoinsPageState createState() =>
      _CoinsPageState(root_url: this.root_url, exchange: this.exchange);
}

class _CoinsPageState extends State<CoinsPage> {
  String exchange;
  String root_url;
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  String selected = "1";
  int bolded = 1;
  bool _IsSearching = true;
  double spacing = 55;
  List<Coin> _list = [];
  List<Coin> _searchList = [];

  _CoinsPageState({required this.root_url, required this.exchange});

  Future<List<Coin>> _fetchCoins() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString(this.exchange + "_token");
    final response = await http.get(
        Uri.parse('http://${this.root_url}/${this.exchange}/get_pairs'),
        headers: {"Authorization": "Bearer " + token!});
    int statusCode = response.statusCode;
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((exchange) => new Coin.fromJson(exchange)).toList();
  }

  FutureBuilder<List<Coin>> _coinFuture() {
    return FutureBuilder<List<Coin>>(
      future: _fetchCoins(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Coin>? data = snapshot.data;
          return _coinGridListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  ListView _coinListView(coins) {
    return ListView.builder(
        itemCount: coins.length,
        itemBuilder: (context, index) {
          return CoinUI(coin: coins[index], pressAction: () {});
        });
  }

  GridView _coinGridListView(coins) {
    String _searchText = _searchQuery.text;
    if (_searchText.isNotEmpty) {
      List<Coin> searchedCoins = [];
      for (var i = 0; i < coins.length; i++) {
        if (coins[i].symbol.toLowerCase().contains(_searchText.toLowerCase()) ||
            coins[i].name.toLowerCase().contains(_searchText.toLowerCase())) {
          searchedCoins.add(coins[i]);
        }
      }

      return GridView.builder(
          itemCount: searchedCoins.length,
          itemBuilder: (context, index) {
            return CoinUI(coin: searchedCoins[index], pressAction: () {});
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10));
    } else {
      return GridView.builder(
          itemCount: coins.length,
          itemBuilder: (context, index) {
            return CoinUI(coin: coins[index], pressAction: () {});
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10));
    }
  }

  onSearchTextChanged(String text) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: const Color(0xFFFEFEFA),
        appBar: AppBar(
          backgroundColor: sigColor,
          centerTitle: true,
          foregroundColor: Colors.white,
          title: Text("Coins"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  onChanged: onSearchTextChanged,
                  controller: _searchQuery,
                  style: TextStyle(
                    color: sigColor,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      hintText: "Search your coins here..",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: _coinFuture(),
                ),
                SizedBox(
                  height: 10,
                ),
                Material(
                    color: Colors.white,
                    child: Row(children: [
                      SizedBox(
                        width: 20,
                      ),
                      new GestureDetector(
                        onTap: () {
                          setState(() {
                            this.selected = "1";
                            this.bolded = 1;
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.home,
                              color:
                                  this.selected == "1" ? sigColor : iconBlack,
                            ),
                            Text("HOME",
                                style: TextStyle(
                                    fontWeight: bolded == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: spacing,
                      ),
                      new GestureDetector(
                        onTap: () {
                          setState(() {
                            this.selected = "2";
                            this.bolded = 2;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              '\u{20B9}',
                              style: TextStyle(
                                color:
                                    this.selected == "2" ? sigColor : iconBlack,
                              ),
                            ),
                            Text("INR",
                                style: TextStyle(
                                    fontWeight: bolded == 2
                                        ? FontWeight.bold
                                        : FontWeight.normal))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: spacing,
                      ),
                      new GestureDetector(
                        onTap: () {
                          setState(() {
                            this.selected = "3";
                            this.bolded = 3;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              "₮",
                              style: TextStyle(
                                color:
                                    this.selected == "3" ? sigColor : iconBlack,
                              ),
                            ),
                            Text("USDT",
                                style: TextStyle(
                                    fontWeight: bolded == 3
                                        ? FontWeight.bold
                                        : FontWeight.normal))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: spacing,
                      ),
                      new GestureDetector(
                        onTap: () {
                          setState(() {
                            this.selected = "4";
                            this.bolded = 4;
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.home_filled,
                              color:
                                  this.selected == "4" ? sigColor : iconBlack,
                            ),
                            Text("HOME",
                                style: TextStyle(
                                    fontWeight: bolded == 4
                                        ? FontWeight.bold
                                        : FontWeight.normal))
                          ],
                        ),
                      ),
                    ]))
              ],
            ),
          ),
        ));
  }
}

class Uiitem extends StatelessWidget {
  final Coin coin;
  Uiitem(this.coin);

  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          print(coin.symbol);
        },
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
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ],
                )),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(5))));
  }
}
