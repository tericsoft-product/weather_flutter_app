import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/providers/get_weekly_forecast_provider.dart';
import '/utils/get_weather_icons.dart';
import '/widgets/subscript_text.dart';

class WeeklyForecastView extends ConsumerWidget {
  const WeeklyForecastView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyForecast = ref.watch(weeklyForecastProvider);

    return weeklyForecast.when(
      data: (weatherData) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              itemCount: weatherData.daily.weatherCode.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
                childAspectRatio: constraints.maxWidth > 600 ? 2.5 : 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final dayOfWeek = DateTime.parse(weatherData.daily.time[index]).dayOfWeek;
                final date = weatherData.daily.time[index];
                final temp = weatherData.daily.temperature2mMax[index];
                final icon = weatherData.daily.weatherCode[index];

                return WeeklyForecastTile(
                  date: date,
                  day: dayOfWeek,
                  icon: getWeatherIcon2(icon),
                  temp: temp.round(),
                );
              },
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

class WeeklyForecastTile extends StatelessWidget {
  const WeeklyForecastTile({
    super.key,
    required this.day,
    required this.date,
    required this.temp,
    required this.icon,
  });

  final String day;
  final String date;
  final int temp;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                AppColors.accentBlue.withOpacity(0.7),
                AppColors.accentBlue.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: TextStyles.h3.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      date,
                      style: TextStyles.subtitleText.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              SuperscriptText(
                text: '$temp',
                color: AppColors.white,
                superScript: '°C',
                superscriptColor: AppColors.white,
              ),
              const SizedBox(width: 16),
              Image.asset(
                icon,
                width: constraints.maxWidth > 400 ? 80 : 60,
              ),
            ],
          ),
        );
      },
    );
  }
}
