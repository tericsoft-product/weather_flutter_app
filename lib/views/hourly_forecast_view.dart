import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/int.dart';
import '/providers/get_hourly_forecast_provider.dart';
import '/utils/get_weather_icons.dart';

class HourlyForecastView extends ConsumerWidget {
  const HourlyForecastView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return _buildWebView(ref);
        }
        return _buildMobileView(ref);
      },
    );
  }

  Widget _buildMobileView(WidgetRef ref) {
    final hourlyWeather = ref.watch(hourlyForecastProvider);

    return hourlyWeather.when(
      data: (hourlyForecast) {
        return SizedBox(
          height: 130,
          child: ListView.builder(
            itemCount: 12,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final forecast = hourlyForecast.list[index];
              return AnimatedHourlyTile(
                id: forecast.weather[0].id,
                hour: forecast.dt.time,
                temp: forecast.main.temp.round(),
                isActive: index == 0,
                fullForecast: forecast,
              );
            },
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text(error.toString()));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildWebView(WidgetRef ref) {
    final hourlyWeather = ref.watch(hourlyForecastProvider);

    return hourlyWeather.when(
      data: (hourlyForecast) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          itemBuilder: (context, index) {
            final forecast = hourlyForecast.list[index];
            return AnimatedHourlyTile(
              id: forecast.weather[0].id,
              hour: forecast.dt.time,
              temp: forecast.main.temp.round(),
              isActive: index == 0,
              fullForecast: forecast,
              isWeb: true,
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text(error.toString()));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class AnimatedHourlyTile extends StatefulWidget {
  final int id;
  final String hour;
  final int temp;
  final bool isActive;
  final dynamic fullForecast;
  final bool isWeb;

  const AnimatedHourlyTile({
    super.key,
    required this.id,
    required this.hour,
    required this.temp,
    required this.isActive,
    required this.fullForecast,
    this.isWeb = false,
  });

  @override
  _AnimatedHourlyTileState createState() => _AnimatedHourlyTileState();
}

class _AnimatedHourlyTileState extends State<AnimatedHourlyTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isInteracted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDetailModal(BuildContext context) {
    if (widget.isWeb) {
      showDialog(
        context: context,
        builder: (context) => _buildDetailDialog(),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => _buildDetailModal(),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
      );
    }
  }

  Widget _buildDetailDialog() {
    final forecast = widget.fullForecast;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.blueGrey.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detailed Forecast',
                  style: TextStyles.h2.copyWith(color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Temperature', '${forecast.main.temp.round()}°C'),
            _buildDetailRow('Feels Like', '${forecast.main.feelsLike.round()}°C'),
            _buildDetailRow('Humidity', '${forecast.main.humidity}%'),
            _buildDetailRow('Wind Speed', '${forecast.wind.speed} m/s'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailModal() {
    final forecast = widget.fullForecast;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blueGrey.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detailed Forecast',
                style: TextStyles.h2.copyWith(color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Temperature', '${forecast.main.temp.round()}°C'),
          _buildDetailRow('Feels Like', '${forecast.main.feelsLike.round()}°C'),
          _buildDetailRow('Humidity', '${forecast.main.humidity}%'),
          _buildDetailRow('Wind Speed', '${forecast.wind.speed} m/s'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.subtitleText.copyWith(color: Colors.white70)),
          Text(value, style: TextStyles.h3.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isWeb) {
      return MouseRegion(
        onEnter: (_) {
          setState(() => _isInteracted = true);
          _controller.forward();
        },
        onExit: (_) {
          setState(() => _isInteracted = false);
          _controller.reverse();
        },
        child: GestureDetector(
          onTap: () => _showDetailModal(context),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              color: widget.isActive ? AppColors.lightBlue : AppColors.accentBlue,
              borderRadius: BorderRadius.circular(20),
              elevation: _elevationAnimation.value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: 'weatherIcon${widget.id}',
                      child: Image.asset(
                        getWeatherIcon(weatherCode: widget.id),
                        width: 80,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.hour,
                          style: TextStyles.subtitleText.copyWith(color: AppColors.white),
                        ),
                        Text(
                          '${widget.temp}°',
                          style: TextStyles.h1.copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onLongPress: () {
        setState(() => _isInteracted = true);
        _controller.forward();
        _showDetailModal(context);
      },
      onLongPressEnd: (details) {
        setState(() => _isInteracted = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
          child: Material(
            color: widget.isActive ? AppColors.lightBlue : AppColors.accentBlue,
            borderRadius: BorderRadius.circular(15.0),
            elevation: _elevationAnimation.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'weatherIcon${widget.id}',
                    child: Image.asset(
                      getWeatherIcon(weatherCode: widget.id),
                      width: 50,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.hour,
                        style: const TextStyle(color: AppColors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${widget.temp}°',
                        style: TextStyles.h3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
