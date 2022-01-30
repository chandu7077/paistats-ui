import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/theme.dart';
import '../widget/button_container.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  TextEditingController apikeycontroller = TextEditingController();
  TextEditingController secretkeycontroller = TextEditingController();
  RemoteConfig remoteConfig = RemoteConfig.instance;
  final String exchange;
  final String root_url;

  LoginPage({required this.root_url, required this.exchange});

  void saveDetails(String apiKey, String secret) async {
    final response = await http
        .post(Uri.parse('http://${this.root_url}/auth/store'), headers: {
      "exchange": this.exchange,
      "secret": secret,
      "api_key": apiKey
    });
    int statusCode = response.statusCode;
    dynamic responseBody = json.decode(response.body);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(this.exchange, true);
    preferences.setString(
        responseBody["exchange"] + "_token", responseBody["token"]);
    preferences.setString(
        responseBody["exchange"] + "_identifier", responseBody["identifier"]);
    print(preferences.getString(responseBody["exchange"] + "_identifier"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: sigColor,
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text("PaiStats"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Api and Secret Key',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
              SizedBox(
                height: 48,
              ),
              Form(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: apikeycontroller,
                        decoration: InputDecoration(
                          hintText: 'API Key',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: secretkeycontroller,
                        decoration: InputDecoration(
                          hintText: 'Secret',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              SizedBox(
                height: 32,
              ),
              CustomPrimaryButton(
                  buttonColor: sigColor,
                  textValue: 'Fetch Details',
                  textColor: Colors.white,
                  pressAction: () {
                    saveDetails(
                        apikeycontroller.text, secretkeycontroller.text);
                  }),
              SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please make sure that the Api and Secret keys \nare valid and has only read access",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
