import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:paistats/models/Coin.dart';
import 'package:paistats/models/Exchange.dart';
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
  bool _IsSearching = true;
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

  GridView _coinGridListView(coins) {
    String _searchText = _searchQuery.text;
    if (_searchText.isNotEmpty) {
      List<Coin> searchedCoins = [];
      for (var i = 0; i < coins.length; i++) {
        if (coins[i].symbol.toLowerCase().contains(_searchText.toLowerCase())) {
          searchedCoins.add(coins[i]);
        }
      }

      return GridView.builder(
          itemCount: searchedCoins.length,
          itemBuilder: (context, index) {
            return Uiitem(searchedCoins[index]);
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
            return Uiitem(coins[index]);
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
          title: Text("CryptoCurrencies"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                      hintText: "Search here..",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                SizedBox(
                  height: 40,
                ),
                Flexible(
                  child: _coinFuture(),
                )
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
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(this.coin.base.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text("/" + this.coin.quote.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.white60))
                  ],
                ),
                SizedBox(height: 10),
                Text(this.coin.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.limeAccent))
              ],
            ),
            decoration: BoxDecoration(
                color: sigColor, borderRadius: BorderRadius.circular(5))));
  }
}
