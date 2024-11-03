class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    String cityName = json['name'];

    double temperature = json['main']['temp'];

    String mainCondition = json['weather'][0]['main'];
    
    return Weather(
      cityName: cityName,
      temperature: temperature,
      mainCondition: mainCondition
    );
    // ^ updated the deprecated JSON format api response
  }
}
