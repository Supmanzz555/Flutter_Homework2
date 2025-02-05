import 'package:http/http.dart' as http;
import 'dart:convert';


class Fetching {
  static const String _token = "72747a590d3f7d96a86389e7e259add4a586679c";
  static const String _url = "https://api.waqi.info/feed/bankok/";


  Future<Map <String,dynamic>?> fetchAQI() async{
    // ignore: prefer_const_declarations
    final path = "$_url?token=$_token";

    try{
      final response = await http.get(Uri.parse(path));
      if(response.statusCode == 200){
        final data = json.decode(utf8.decode(response.bodyBytes));
        return{
            "city": data["data"]["city"]["name"] ?? "N/A",
            "aqi": data["data"]["aqi"] ?? "N/A",
            "temp": data["data"]["iaqi"]["t"]["v"] ?? 0.0,
            "humidity": data["data"]["iaqi"]["h"]["v"] ?? 0,
            "wind_speed": data["data"]["iaqi"]["w"]["v"] ?? 0.0,
        };
      }else{
        // ignore: avoid_print
        print("Network Error: ${response.statusCode}");
        return null;
      }
    }catch(e){
      // ignore: avoid_print
      print("Eror Fetching AQI data please try again: $e");
      return null;
    }
  }
}