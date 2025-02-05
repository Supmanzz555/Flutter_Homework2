import 'package:flutter/material.dart';
import 'fetching.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeWork2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade200),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String city = "Please Wait...";
  dynamic aqi = 0;
  dynamic temperature = 0.0;
  dynamic humidity = 0;
  double windSpeed = 0.0;
  Timer? _timer;
  String status = "";

  @override
  void initState() {
    super.initState();
    fetchData();
    _startTimer(); // Start the timer when the app loads
  }

  void stopTimer() {
    _timer?.cancel();
  }
  

  // Fetch AQI Data from API
  Future<void> fetchData() async {
    final fetching = Fetching();
    final data = await fetching.fetchAQI();

    if (data != null) {
      setState(() {
        city = data["city"] ?? "Unknown";
        aqi = data["aqi"] ?? 0;
        temperature = data["temp"] ?? 0.0;
        humidity = data["humidity"] ?? 0;
        windSpeed = data["wind_speed"] ?? 0.0;
      });
    }
  }

  // Function to determine background color based on AQI value
  Color getAQIColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.black;
  }

  // Status based on AQI value
  String getAQIStatus(int aqi) {
    if (aqi <= 50) return "Good";
    if (aqi <= 100) return "Moderate";
    if (aqi <= 150) return "Unhealthy for Sensitive Groups";
    if (aqi <= 200) return "Unhealthy";
    if (aqi <= 300) return "Very Unhealthy";
    return "Hazardous";
  }

  // Start the timer that runs every 5 minutes
  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    status = getAQIStatus(aqi); //text status
    return Scaffold(
      backgroundColor: Colors.grey[250],
      appBar: AppBar(
        centerTitle: true,
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Air',
                style: TextStyle(
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' Quality Index (AQI)',
                style: TextStyle(
                  fontFamily: "Manrope",
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 3.0,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // City Name
              Text(
                city,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // AQI Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: getAQIColor(aqi),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    // Mask Icon
                    const Icon(Icons.masks, size: 50, color: Colors.white),

                    // AQI Value
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            aqi.toString(),
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            status,
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            "US AQI",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3.5),

              // Weather Information
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Temperature
                    _buildWeatherInfo(Icons.thermostat, "$temperature°C", "Temperature"),
                    const SizedBox(height: 10),

                    // Humidity
                    _buildWeatherInfo(Icons.water_drop, "$humidity%", "Humidity"),
                    const SizedBox(height: 10),

                    // Wind Speed
                    _buildWeatherInfo(Icons.air, "$windSpeed km/h", "Wind Speed"),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              //Timer Text
               const Text(
                "Data refreshes every 5 minutes or ",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              // Manual Refresh Button
              ElevatedButton(
                onPressed:(){
                  fetchData();
                },
                child: const Text("Refresh The Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Weather Info
  Widget _buildWeatherInfo(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
