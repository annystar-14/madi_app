import 'package:flutter/material.dart';
import 'package:medi_app/views/aprender_screen.dart';
import 'package:medi_app/views/historial_screen.dart';
import 'package:medi_app/views/home_screen.dart';
import 'package:medi_app/views/perfil_screen.dart';

import '../../core/theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HistorialScreen()),
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AprenderScreen()),
          (route) => false,
        );
        break;
      case 3:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PerfilScreen()),
          (route) => false,
        );
        break;
    }
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required int itemIndex,
    double iconSize = 35,
  }) {
    final bool isActive = currentIndex == itemIndex;
    final Color iconColor = isActive ? AppColors.primaryBlue : Colors.grey.shade600;
    final Color backgroundColor = isActive 
      ? AppColors.primaryBlue.withOpacity(0.2) 
      : Colors.transparent;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
            letterSpacing: -0.2,
          ),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.white,
          iconSize: 35,
          items: [
            _buildNavItem(
              icon: Icons.home,
              label: 'Inicio',
              itemIndex: 0,
            ),
            _buildNavItem(
              icon: Icons.history,
              label: 'Historial',
              itemIndex: 1,
            ),
            _buildNavItem(
              icon: Icons.book_outlined,
              label: 'Aprender',
              itemIndex: 2,
            ),
            _buildNavItem(
              icon: Icons.person_outline,
              label: 'Perfil',
              itemIndex: 3,
            ),
          ],
        ),
      ),
    );
  }
}