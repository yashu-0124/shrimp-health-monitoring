/// Weather Model
/// Data model for weather information
class WeatherModel {
  final String temperature;
  final String condition;
  final String humidity;
  final String windSpeed;
  final String rainfall;
  final String location;
  final String advisory;

  WeatherModel({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.rainfall,
    required this.location,
    required this.advisory,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'].round().toString(),
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'].toString(),
      windSpeed: (json['wind']['speed'] * 3.6).round().toString(), // m/s to km/h
      rainfall: json['clouds']['all'].toString(),
      location: json['name'],
      advisory: '',
    );
  }

  WeatherModel copyWith({String? advisory}) {
    return WeatherModel(
      temperature: temperature,
      condition: condition,
      humidity: humidity,
      windSpeed: windSpeed,
      rainfall: rainfall,
      location: location,
      advisory: advisory ?? this.advisory,
    );
  }
}
