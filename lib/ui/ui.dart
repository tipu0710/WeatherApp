import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/Data/utils.dart' as utils;
import 'package:http/http.dart' as http;

class CreateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AppWidgets();
  }
}

class _AppWidgets extends State<CreateWidget> {

  final String BACK = "back";
  final String CLOUD = "cloud";
  final String LAMP = "lamp";
  final String STAR = "star";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: updateTempWidget("Jessore"),
        ),
      ),
    );
  }

  Widget imageWidget(
      {double top,
      double right,
      double height,
      double width,
      String assetName}) {
    return new Positioned(
      top: top,
      right: right,
      height: height,
      width: width,
      child: Container(
        alignment: Alignment.center,
        child: Image.asset(assetName),
      ),
    );
  }

  Future<Map> getWeather(String apiId, String city) async {
    String apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${utils.apiId}&units=metric";

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
      future: getWeather(utils.apiId, city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          int temp = content['main']['temp'].round();
          List indicator = content['weather'];
          String s = indicator[0]['main'];
          var sun = content['sys']['sunset'];

          int currentHour = TimeOfDay.now().hour;
          int currentMinute = TimeOfDay.now().minute;
          int sunsetHour = DateTime.fromMillisecondsSinceEpoch(sun * 1000).hour;
          int sunsetMinute =
              DateTime.fromMillisecondsSinceEpoch(sun * 1000).minute;
          int sunriseHour = DateTime.fromMillisecondsSinceEpoch(sun * 1000).hour;
          int sunriseMinute =
              DateTime.fromMillisecondsSinceEpoch(sun * 1000).minute;

          return new Stack(
            children: <Widget>[
              Image.asset(
                getDynamicWid(currentHour, currentMinute, sunsetHour, sunsetMinute, sunriseHour, sunriseMinute, BACK),
                fit: BoxFit.fill,
              ),
              //home
              imageWidget(
                  top: 417,
                  right: 45,
                  height: 180.94,
                  width: 270.78,
                  assetName: "images/summer_house.png"),
              //lamp
              new Positioned(
                  top: 423.77,
                  left: 257.66,
                  height: 153.7,
                  width: 41.29,
                  child: Image.asset(getDynamicWid(currentHour, currentMinute, sunsetHour, sunsetMinute, sunriseHour, sunriseMinute, LAMP))),

              //sun/moon
              imageWidget(
                  top: 200.48,
                  right: 140.16,
                  height: 80.68,
                  width: 80.68,
                  assetName: getDynamicWid(currentHour, currentMinute, sunsetHour,
                      sunsetMinute, sunriseHour, sunriseMinute, STAR)),

              //cloud
              imageWidget(
                  top: 250,
                  right: 69,
                  height: 54,
                  width: 196.33,
                  assetName: getDynamicWid(currentHour, currentMinute, sunsetHour, sunsetMinute, sunriseHour, sunriseMinute, CLOUD)),
              //arrow
              imageWidget(
                  top: 618.44,
                  right: 167.17,
                  height: 13.11,
                  width: 25.17,
                  assetName: "images/arrow_night.png"),
              new Positioned(
                top: 30,
                left: 180,
                child: new Text(
                  temp.toString() + "°C",
                  style: new TextStyle(
                    fontSize: 70,
                    color: new Color(
                        int.parse("#818181".substring(1, 7), radix: 16) +
                            0xFF000000),
                  ),
                ),
              ),
              new Positioned(
                top: 112,
                left: 276,
                child: new Text(
                  s,
                  style: new TextStyle(
                      fontSize: 20,
                      color: new Color(
                          int.parse("#B5B5B5".substring(1, 7), radix: 16) +
                              0xFF000000)),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          );
        } else {
          return new Stack(
            children: <Widget>[
              //home
              imageWidget(
                  top: 417,
                  right: 45,
                  height: 180.94,
                  width: 270.78,
                  assetName: "images/summer_house.png"),
              //lamp
              new Positioned(
                  top: 423.77,
                  left: 257.66,
                  height: 153.7,
                  width: 41.29,
                  child: Image.asset("images/lamp_off.png")),
              //sun/moon
              imageWidget(
                  top: 200.48,
                  right: 140.16,
                  height: 80.68,
                  width: 80.68,
                  assetName: "images/sun.png"),
              //cloud
              imageWidget(
                  top: 250,
                  right: 69,
                  height: 54,
                  width: 196.33,
                  assetName: "images/cloud.png"),
              //arrow
              imageWidget(
                  top: 618.44,
                  right: 167.17,
                  height: 13.11,
                  width: 25.17,
                  assetName: "images/arrow_night.png"),
              new Positioned(
                top: 30,
                left: 180,
                child: new Text(
                  "N/A",
                  style: new TextStyle(
                    fontSize: 70,
                    color: new Color(
                        int.parse("#818181".substring(1, 7), radix: 16) +
                            0xFF000000),
                  ),
                ),
              ),
              new Positioned(
                top: 112,
                left: 260,
                child: new Text(
                  "N/A",
                  style: new TextStyle(
                      fontSize: 20,
                      color: new Color(
                          int.parse("#B5B5B5".substring(1, 7), radix: 16) +
                              0xFF000000)),
                ),
              )
            ],
          );
        }
      },
    );
  }

  String getDynamicWid(int currentHour, int currentMinute, int sunsetHour,
      int sunsetMinute, int sunriseHour, int sunriseMinute, String state) {
    bool isDay;

    if (currentHour < sunsetHour && currentHour>sunriseHour) {
      isDay = true;
    } else if (currentHour == sunsetHour) {
      if (currentMinute < sunsetMinute) {
        isDay = true;
      } else {
        isDay = false;
      }
    } else {
      isDay = false;
    }

    if(state == BACK){
      return isDay?"images/summer_back.png":"images/night_back.png";
    }else if(state == STAR){
      return isDay?"images/sun.png":"images/moon.png";
    }else if(state==LAMP){
      return isDay?"images/lamp_off.png":"images/lamp_on.png";
    }else{
      return isDay?"images/cloud.png":"images/balck_cloud.png";
    }
  }
}
