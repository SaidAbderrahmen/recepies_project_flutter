import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'recipes_list_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import '../../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = Get.find<AuthController>();
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    RecipesListScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = ['Discover Recipes', 'My Favorites', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Makes content flow under the navigation bar
      body: Stack(
        children: [
          // Tab content
          _tabs[_currentIndex],

          // Custom Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCustomNavItem(
                    icon: Icons.restaurant_menu,
                    selectedIcon: Icons.restaurant_menu,
                    label: 'Recipes',
                    index: 0,
                  ),
                  _buildCustomNavItem(
                    icon: Icons.favorite_border,
                    selectedIcon: Icons.favorite,
                    label: 'Favorites',
                    index: 1,
                  ),
                  _buildCustomNavItem(
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                    label: 'Profile',
                    index: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        ScaffoldMessenger.of(context).clearSnackBars();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: Colors.white,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
