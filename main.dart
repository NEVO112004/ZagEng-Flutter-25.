import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(fontFamily: 'Roboto'),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final String _apiKey = "161d941566524791ba913755251903";
  Map<String, dynamic>? _weatherData;
  List<dynamic>? _forecastData;
  bool _isLoading = false;

  Future<void> fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
    });

    final weatherUrl =
        "https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$city";
    final forecastUrl =
        "https://api.weatherapi.com/v1/forecast.json?key=$_apiKey&q=$city&days=3";

    try {
      final weatherResponse = await http.get(Uri.parse(weatherUrl));
      final forecastResponse = await http.get(Uri.parse(forecastUrl));

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        setState(() {
          _weatherData = json.decode(weatherResponse.body);
          _forecastData =
              json.decode(forecastResponse.body)['forecast']['forecastday'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _weatherData = null;
          _forecastData = null;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _weatherData = null;
        _forecastData = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFA957),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Weather",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Search here ...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.black54, size: 28),
                      onPressed: () {
                        fetchWeather(_cityController.text);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : _weatherData != null
                  ? WeatherInfo(
                    weatherData: _weatherData!,
                    forecastData: _forecastData!,
                  )
                  : Text(
                    "Enter a city to get weather data.",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final List<dynamic> forecastData;

  const WeatherInfo({
    super.key,
    required this.weatherData,
    required this.forecastData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weatherData['location']['name'],
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Text(
          weatherData['location']['country'],
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        SizedBox(height: 20),
        Text(
          weatherData['current']['condition']['text'],
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        SizedBox(height: 10),
        Text(
          "${weatherData['current']['temp_c']}°C",
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Icon(Icons.wb_sunny, size: 80, color: Colors.white),
        SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              forecastData.map((day) {
                return WeatherCard(
                  day: day['date'].split('-').last, // رقم اليوم
                  condition: day['day']['condition']['text'],
                  temp: day['day']['avgtemp_c'].toString(),
                );
              }).toList(),
        ),
      ],
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String day;
  final String condition;
  final String temp;

  const WeatherCard({
    super.key,
    required this.day,
    required this.condition,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Icon(Icons.wb_sunny, size: 30, color: Colors.black54),
          SizedBox(height: 5),
          Text(
            "$temp°C",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
