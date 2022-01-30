import 'package:flutter/material.dart';
import 'package:paistats/pages/exchanges_page.dart';
import 'package:paistats/themes/theme.dart';
import 'login_page.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  final String root_url;

  OnBoardingPage({required this.root_url});

  @override
  _OnBoardingPageState createState() =>
      _OnBoardingPageState(root_url: this.root_url);
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final String root_url;

  _OnBoardingPageState({required this.root_url});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Welcome to PaiStats',
            body: 'Analyse your crypto investments with paistats',
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Simple UI',
            body:
                ' The greatest value of a picture is when it forces us to notice what we never expected to see. \n \n ―John Tukey ',
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Today a reader, tomorrow a leader',
            body: 'Start your journey',
            decoration: getPageDecoration(),
          ),
        ],
        done: Text('Read',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        onDone: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('onBoard', 1);
          goToHome(context);
        },
        showSkipButton: true,
        skip: Text(
          'Skip',
          style: TextStyle(color: Colors.white),
        ),
        onSkip: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('onBoard', 1);
          print(await prefs.getInt('onBoard'));
          goToHome(context);
        },
        next: Icon(Icons.arrow_forward, color: Colors.white),
        dotsDecorator: getDotDecoration(),
        onChange: (index) => print('Page $index selected'),
        globalBackgroundColor: sigColor,
        skipFlex: 0,
        nextFlex: 0,
        // isProgressTap: false,
        // isProgress: false,
        // showNextButton: false,
        // freeze: true,
        // animationDuration: 1000,
      ),
    );
  }

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => ExchangePage(root_url: this.root_url)),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color(0xFFBDBDBD),
        //activeColor: Colors.orange,
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: sigColor),
        bodyTextStyle: TextStyle(fontSize: 20),
        descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );
}
