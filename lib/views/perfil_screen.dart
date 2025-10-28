import 'package:flutter/material.dart';
import 'package:medi_app/core/theme/app_colors.dart';
import './reutilizable/header.dart';
import './reutilizable/footer.dart';
import 'package:medi_app/views/reutilizable/sideMenu.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: const AppDrawer(),
      
      appBar: Header(
     
        title: 'Mi perfil', // Título para el header simple
        onNotificationPressed: () {
          // Lógica para notificaciones
        },
      ),
      
      body: const Center(
        child: Text('Contenido del perfil'),
      ),
      
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}