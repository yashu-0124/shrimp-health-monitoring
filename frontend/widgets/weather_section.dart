import 'package:flutter/material.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

/// Weather Widget
/// Displays weather information for shrimp farming locations
class WeatherSection extends StatefulWidget {
  const WeatherSection({super.key});

  @override
  State<WeatherSection> createState() => _WeatherSectionState();
}

class _WeatherSectionState extends State<WeatherSection> {
  bool _isLoading = false;
  WeatherModel? _weatherData;
  String _selectedLocation = 'Kakinada';
  final WeatherService _weatherService = WeatherService();

  // Shrimp farming locations
  final List<String> _locations = [
    'Kakinada',
    'Nellore',
    'Machilipatnam',
    'Bhimavaram',
    'Nagapattinam',
  ];

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF357ABD),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            : _weatherData == null
                ? _buildErrorState()
                : _buildWeatherContent(),
      ),
    );
  }

  Widget _buildWeatherContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.cloud, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.weatherForecast,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _loadWeather,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Location Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLocation,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                dropdownColor: const Color(0xFF357ABD),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                items: _locations.map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white70, size: 18),
                        const SizedBox(width: 8),
                        Text(location),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null && newValue != _selectedLocation) {
                    setState(() {
                      _selectedLocation = newValue;
                    });
                    _loadWeather();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Main Weather Info
          Row(
            children: [
              // Temperature
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weatherData!.temperature,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _weatherData!.condition,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Weather Icon
              Icon(
                _getWeatherIcon(_weatherData!.condition),
                size: 80,
                color: Colors.white.withOpacity(0.8),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Weather Details Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(
                Icons.water_drop,
                AppLocalizations.of(context)!.humidity,
                '${_weatherData!.humidity}%',
              ),
              _buildWeatherDetail(
                Icons.air,
                AppLocalizations.of(context)!.windSpeed,
                '${_weatherData!.windSpeed} km/h',
              ),
              _buildWeatherDetail(
                Icons.umbrella,
                AppLocalizations.of(context)!.rainfall,
                '${_weatherData!.rainfall}%',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Advisory
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _weatherData!.advisory,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.weatherUnavailable,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
      case 'rain':
        return Icons.beach_access;
      case 'partly cloudy':
        return Icons.wb_cloudy;
      default:
        return Icons.cloud;
    }
  }

  Future<void> _loadWeather() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _weatherData = null;
    });

    try {
      final weather = await _weatherService.getWeatherByCity(_selectedLocation);
      
      if (!mounted) return;

      if (weather != null) {
        // Get current language code
        final locale = Localizations.localeOf(context);
        final languageCode = locale.languageCode;

        // Generate shrimp-specific advisory
        final advisory = _weatherService.generateShrimpAdvisory(
          weather,
          languageCode,
        );

        setState(() {
          _weatherData = weather.copyWith(advisory: advisory);
          _isLoading = false;
        });
      } else {
        setState(() {
          _weatherData = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _weatherData = null;
        _isLoading = false;
      });
    }
  }
}
