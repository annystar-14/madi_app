import 'package:flutter/material.dart';
import 'package:medi_app/views/aprender_screen.dart';
import 'package:medi_app/views/historial_screen.dart';
import 'package:medi_app/views/home_screen.dart';
import 'package:medi_app/views/perfil_screen.dart';
import '../../core/theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int? currentIndex;

  const AppBottomNavBar({super.key, this.currentIndex});

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
  }) {
    final bool isActive = currentIndex == itemIndex;
    final Color activeColor = AppColors.primaryBlue;
    final Color inactiveColor = Colors.grey.shade600;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: isActive ? 33 : 31,
          color: isActive ? activeColor : inactiveColor,
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
            color: Colors.black.withOpacity(0.12),
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
          currentIndex: currentIndex ?? 0,
          onTap: (index) => _onItemTapped(context, index),
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: Colors.grey.shade600,
          showUnselectedLabels: true,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          items: [
            _buildNavItem(icon: Icons.home_rounded, label: 'Inicio', itemIndex: 0),
            _buildNavItem(icon: Icons.history_rounded, label: 'Historial', itemIndex: 1),
            _buildNavItem(icon: Icons.tips_and_updates_outlined, label: 'Consejos', itemIndex: 2),
            _buildNavItem(icon: Icons.account_circle_outlined, label: 'Perfil', itemIndex: 3),
          ],
        ),
      ),
    );
  }
}
