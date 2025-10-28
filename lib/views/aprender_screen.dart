import 'package:flutter/material.dart';
import 'package:medi_app/core/theme/app_colors.dart';
import './reutilizable/header.dart';
import './reutilizable/footer.dart';
import 'package:medi_app/views/reutilizable/sideMenu.dart';

class AprenderScreen extends StatelessWidget {
  const AprenderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: const AppDrawer(),
      
      appBar: Header(
     
        title: 'Aprender', // Título para el header simple
        onNotificationPressed: () {
          // Lógica para notificaciones
        },
      ),
      
      body: const Center(
        child: Text('Contenido de aprender'),
      ),
      
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}