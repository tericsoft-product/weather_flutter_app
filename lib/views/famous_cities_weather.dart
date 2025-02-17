import 'package:flutter/material.dart';
import '/models/famous_city.dart';
import '/screens/weather_detail_screen.dart';
import '/widgets/city_weather_tile.dart';

class FamousCitiesWeather extends StatelessWidget {
  const FamousCitiesWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: famousCities.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final city = famousCities[index];

            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WeatherDetailScreen(
                      cityName: city.name,
                    ),
                  ),
                );
              },
              child: CityWeatherTile(
                index: index,
                city: city,
              ),
            );
          },
        );
      },
    );
  }
}
