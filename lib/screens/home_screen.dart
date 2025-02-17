import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '/constants/app_colors.dart';
import '/screens/forecast_report_screen.dart';
import '/screens/search_screen.dart';
// import '/screens/settings_screen.dart';
import 'weather_screen/weather_screen.dart';
import '/services/api_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;

  final List<Widget> _screens = const [
    WeatherScreen(),
    SearchScreen(),
    ForecastReportScreen(),
    // SettingsScreen(),
  ];

  final List<String> _routes = [
    '/home',
    '/search',
    '/forecast',
    // '/settings',
  ];

  final List<String> _tabLabels = ['Home', 'Search', 'Forecast', // 'Settings'
  ];

  final List<IconData> _tabIcons = [
    Icons.home_outlined,
    Icons.search_outlined,
    Icons.wb_sunny_outlined,
    // Icons.settings_outlined,
  ];

  void _navigateToPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  void initState() {
    ApiHelper.getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          return _buildMobileLayout();
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: _screens[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _navigateToPage,
        backgroundColor: AppColors.accentBlue,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: List.generate(3, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_tabIcons[index]),
            label: _tabLabels[index],
          );
        }),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        title: const Text('Weather App'),
        actions: List.generate(3, (index) {
          return GestureDetector(
            onTap: () => _navigateToPage(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: _currentPageIndex == index
                    ? AppColors.lightBlue
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    _tabIcons[index],
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    _tabLabels[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      body: _screens[_currentPageIndex],
    );
  }
}
