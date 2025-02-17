import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/extensions/strings.dart';
import '/providers/get_city_forecast_provider.dart';
import '/screens/weather_screen/weather_info.dart';
import '/views/gradient_container.dart';

class WeatherDetailScreen extends ConsumerStatefulWidget {
  const WeatherDetailScreen({
    Key? key,
    required this.cityName,
  }) : super(key: key);

  final String cityName;

  @override
  ConsumerState<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends ConsumerState<WeatherDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatingAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Floating animation for weather icon
    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Slide animation for city name
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    // Blinking animation
    _blinkAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = ref.watch(cityForecastProvider(widget.cityName));

    return Scaffold(
      body: weatherData.when(
        data: (weather) {
          return GradientContainer(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                    width: double.infinity,
                  ),
                  // Animated city name
                  SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      weather.name,
                      style: TextStyles.h1,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Today's date
                  Text(
                    DateTime.now().dateTime,
                    style: TextStyles.subtitleText,
                  ),

                  const SizedBox(height: 50),

                  // Animated weather icon with floating and rotation
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value),
                        child: Transform.rotate(
                          angle: math.sin(_animationController.value * math.pi) * 0.1,
                          child: Opacity(
                            opacity: _blinkAnimation.value,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: SizedBox(
                                height: 260,
                                child: Image.asset(
                                  'assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 50),

                  // Weather description with blinking effect
                  FadeTransition(
                    opacity: _blinkAnimation,
                    child: Text(
                      weather.weather[0].description.capitalize,
                      style: TextStyles.h2,
                    ),
                  ),
                ],
              ),

                  const SizedBox(height: 40),

                  // Weather info in a row
                  WeatherInfo(weather: weather),

                  const SizedBox(height: 15),
                ],
              );
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text(
              'An error has occurred',
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
