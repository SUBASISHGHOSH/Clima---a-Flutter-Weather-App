import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

class LocationScreen extends StatefulWidget {
  final dynamic locWeatherData;
  LocationScreen({this.locWeatherData});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  double? temperature;
  String? condition;
  String? message;
  String? city;
  void updateUI(weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 404;
        message = 'Please check your GPS and Internet!';
        condition = '';
        city = 'lala Land';
      }
      temperature = weatherData['main']['temp'];
      message = weather.getMessage(temperature!.toInt());
      condition = weather.getWeatherIcon(weatherData['weather'][0]['id']);
      city = weatherData['name'];
    });
  }

  @override
  void initState() {
    super.initState();
    updateUI(widget.locWeatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      updateUI(await weather.locationWeather());
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var newCity = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityScreen(city),
                        ),
                      );
                      if (newCity != null) {
                        updateUI(
                          await weather.cityWeather(newCity),
                        );
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      temperature!.toInt().toString() + '°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      condition!,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$message in $city!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
