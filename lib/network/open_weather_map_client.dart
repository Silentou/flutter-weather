import 'dart:convert';

import 'package:weather/models/forecast_result.dart';

import '../models/Weather_result.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import '../models/constants.dart';

class OpenWeatherMapClient{
  Constants? constants = Constants();

  Future<WeatherResult> getWeather(LocationData locationData) async{
      if(locationData.latitude != null && locationData.longitude != null){
        final res = await http.get(Uri.parse('${constants?.apiUrl}/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&units=metric&appid=${constants?.apiKey}'));
        if(res.statusCode == 200){
          return WeatherResult.fromJson(jsonDecode(res.body));
        }else{
          throw Exception("Bad Request");
        }
      }else{
        throw Exception('Wrong Location');
      }
  }

  Future<ForecastResult> getForecastWeather(LocationData locationData) async{
    if(locationData.latitude != null && locationData.longitude != null){
      final res = await http.get(Uri.parse('${constants?.apiUrl}/forecast?lat=${locationData.latitude}&lon=${locationData.longitude}&units=metric&appid=${constants?.apiKey}'));
      if(res.statusCode == 200){
        return ForecastResult.fromJson(jsonDecode(res.body));
      }else{
        throw Exception("Bad Request");
      }
    }else{
      throw Exception('Wrong Location');
    }
  }
}