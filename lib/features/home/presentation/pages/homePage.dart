import 'package:flutter/material.dart';
import 'package:sesan_travel/features/home/presentation/widgets/category_widget.dart';
import 'package:sesan_travel/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:sesan_travel/features/home/presentation/widgets/home_slider_widget.dart';
import 'package:sesan_travel/features/home/presentation/widgets/title_widget.dart';
import 'package:sesan_travel/features/home/presentation/widgets/tour_list_widget.dart';

import '../widgets/search_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomeTab() {
    return const SingleChildScrollView(
      child: Column(
        children: [
          HomeSliderWidget(),
          SizedBox(height: 12),
          SearchWidget(),
          SizedBox(height: 12),
          CategoryWidget(),
          SizedBox(height: 12),
          TitleWidget(),
          SizedBox(height: 12),
          TourListWidget(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SESAN TRAVEL', style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: _selectedIndex == 0 
          ? _buildHomeTab() 
          : Center(child: Text('Màn hình của tab $_selectedIndex đang phát triển')),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
