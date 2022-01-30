import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paistats/pages/exchanges_page.dart';
import './pages/onboarding_page.dart';
import 'firebase_options.dart';
import './pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import "globals.dart" as globals;

int? isviewed;
String rooturl = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  RemoteConfig remoteConfig = await RemoteConfig.instance;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = await prefs.getInt('onBoard');
  await remoteConfig.ensureInitialized();
  await remoteConfig.fetchAndActivate();
  rooturl = await remoteConfig.getString("rooturl");
  print(rooturl.isEmpty);
  if (rooturl.isEmpty) {
    rooturl = "65.2.152.141:3000";
  }
  runApp(PaiStats());
}

class PaiStats extends StatefulWidget {
  @override
  _PaiStatsState createState() => _PaiStatsState();
}

class _PaiStatsState extends State<PaiStats> {
  static final String title = 'PaiStats';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: isviewed == 1 ? "exchanges" : "/",
      routes: {
        "/": (context) => OnBoardingPage(
              root_url: rooturl,
            ),
        "exchanges": (context) => ExchangePage(root_url: rooturl)
      },
    );
  }
}
