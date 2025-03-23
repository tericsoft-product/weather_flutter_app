import 'package:flutter/material.dart';
import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/views/famous_cities_weather.dart';
import '/views/gradient_container.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isCardZoomed = false;

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      children: [
        // Page title
        Align(
          alignment: Alignment.center,
          child: Text(
            'Pick Location',
            style: TextStyles.h1,
          ),
        ),
        SizedBox(height: 20),

        // Page subtitle
        Text(
          'Find the area or city that you want to know the detailed weather info at this time',
          style: TextStyles.subtitleText,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),

        // Famous cities weather cards with zoom animation
        GestureDetector(
          onTap: () {
            setState(() {
              _isCardZoomed = !_isCardZoomed; // Toggle zoom effect
            });
          },
          child: AnimatedScale(
            scale: _isCardZoomed ? 1.2 : 1.0, // Scale factor when clicked
            duration: Duration(milliseconds: 300),
            child: FamousCitiesWeather(),
          ),
        ),
        SizedBox(height: 12), // Adds bottom margin
      ],
    );
  }
}
