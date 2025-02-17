import 'package:flutter/material.dart';
import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/views/famous_cities_weather.dart';
import '/views/gradient_container.dart';
import '/widgets/round_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  bool _isSearchButtonAnimated = false;
  bool _isCardZoomed = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _onLocationIconClicked() {
    // Navigate to home screen when location icon is clicked
    Navigator.pushNamed(context, '/home');
  }

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

        // Pick location row with animation
        Row(
          children: [
            // Choose city text field with animated position
            Expanded(
              child: AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                left: _isSearchButtonAnimated ? 0 : -300, // Start off-screen and animate in
                child: RoundTextField(),
              ),
            ),
            SizedBox(width: 15),

            GestureDetector(
              onTap: _onLocationIconClicked,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: AppColors.accentBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 30),

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

