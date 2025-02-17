import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/extensions/strings.dart';
import '/providers/get_current_weather_provider.dart';
import '/views/gradient_container.dart';
import '/views/hourly_forecast_view.dart';
import 'weather_info.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
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
    final weatherData = ref.watch(currentWeatherProvider);

    return weatherData.when(
      data: (weather) {
        return GradientContainer(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),

                // Animated Country Name
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Text(
                        weather.name,
                        style: TextStyles.h1.copyWith(
                          color: Colors.white.withOpacity(_fadeAnimation.value),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Animated Date
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Text(
                        DateTime.now().dateTime,
                        style: TextStyles.subtitleText,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Floating Animated Weather Icon
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatingAnimation.value),
                      child: Transform.rotate(
                        angle: math.sin(_animationController.value * math.pi) * 0.1,
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
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Animated Weather Description
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.blue.shade200, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    weather.weather[0].description.capitalize,
                    style: TextStyles.h2.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Weather info in a row
            WeatherInfo(weather: weather),

            const SizedBox(height: 40),

            // Today Daily Forecast with Animated Reveal
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Row(
                key: ValueKey(weather.name),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Today Report',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Hourly forecast
            const HourlyForecastView(),
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
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: AppColors.blueGrey,
              ),
            ),
            Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1).animate(
                  CurvedAnimation(
                    parent: AlwaysStoppedAnimation(0.5),
                    curve: Curves.elasticOut,
                  ),
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
