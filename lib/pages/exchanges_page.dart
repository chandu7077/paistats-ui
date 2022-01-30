import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:paistats/models/Exchange.dart';
import 'package:paistats/pages/coins_page.dart';
import 'package:paistats/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/theme.dart';
import 'package:http/http.dart' as http;

class ExchangePage extends StatefulWidget {
  final String root_url;

  ExchangePage({required this.root_url});

  @override
  _ExchangePageState createState() =>
      _ExchangePageState(root_url: this.root_url);
}

class _ExchangePageState extends State<ExchangePage> {
  final String root_url;
  _ExchangePageState({required this.root_url});
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance!.addPostFrameCallback((_) async {
  //     final remoteConfig = await RemoteConfig.instance;

  //     await remoteConfig.fetchAndActivate();
  //     await remoteConfig.ensureInitialized();
  //     setState(() async {
  //       this.root_url = await remoteConfig.getString("rooturl");
  //     });
  //     print(this.root_url);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Future<List<Exchange>> _fetchExchanges() async {
      // String root_url = await remoteConfig.getString("rooturl");
      // if (root_url == "") {
      //   final globalRemoteConfig = await RemoteConfig.instance;
      //   await globalRemoteConfig.ensureInitialized();
      //   root_url = await globalRemoteConfig.getString("rooturl");
      // }
      final response = await http
          .get(Uri.parse('http://${this.root_url}/exchanges'), headers: {});
      int statusCode = response.statusCode;
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((exchange) => new Exchange.fromJson(exchange))
          .toList();
    }

    void switchToCoin(BuildContext context, String exchange) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (preferences.containsKey(exchange)) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CoinsPage(
                  root_url: this.root_url,
                  exchange: exchange,
                )));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginPage(
                  root_url: this.root_url,
                  exchange: exchange,
                )));
      }
    }

    ListView _exchangeListView(exchanges) {
      return ListView.builder(
          itemCount: exchanges.length,
          itemBuilder: (context, index) {
            return Card(
                elevation: 2,
                color: sigColor,
                margin: EdgeInsets.fromLTRB(20, 7, 20, 5),
                child: ListTile(
                  textColor: Colors.white,
                  title: Text(exchanges[index].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      )),
                  onTap: () {
                    switchToCoin(context, exchanges[index].name.toLowerCase());
                  },
                ));
          });
    }

    FutureBuilder<List<Exchange>> _exchangeFuture() {
      return FutureBuilder<List<Exchange>>(
        future: _fetchExchanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Exchange>? data = snapshot.data;
            return _exchangeListView(data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      );
    }

    return Scaffold(
        backgroundColor: const Color(0xFFFEFEFA),
        appBar: AppBar(
          backgroundColor: sigColor,
          centerTitle: true,
          foregroundColor: Colors.white,
          title: Text("Exchanges"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/icon.png",
                  width: 200,
                  height: 200,
                ),
                SizedBox(
                  height: 40,
                ),
                Flexible(
                  child: _exchangeFuture(),
                )
              ],
            ),
          ),
        ));
  }
}
