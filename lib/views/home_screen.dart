import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

import './reutilizable/header.dart';
import './reutilizable/footer.dart';
import 'package:medi_app/views/reutilizable/sideMenu.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

   @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Función para obtener el primer nombre del usuario desde Firestore
  Future<String> _fetchFirstName() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return 'Usuario';
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        // Obtenemos el nombre completo
        final fullName = doc.data()!['nombre'] as String? ?? 'Usuario';
        
        // Tomamos solo la primera palabra (el primer nombre)
        return fullName.trim().split(' ')[0];
      }
      return 'Usuario'; // Si el documento no existe
    } catch (e) {
      debugPrint('Error al obtener el nombre del usuario: $e');
      return 'Usuario'; // En caso de error
    }
  }

  @override
  Widget build(BuildContext context) {

    // Aquí puedes tomar el estado real desde un provider
    final String estadoActual = "Sin sintomas registrados";

    return FutureBuilder<String>(
      future: _fetchFirstName(),
      builder: (context, snapshot) {
        final String userName = snapshot.data ?? 'Usuario';

        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          drawer: const AppDrawer(), 
          
          appBar: Header(
            isHomeScreen: true,
            userName: userName,
            statusText: estadoActual,
            onStatusCardPressed: () {
              // Lógica para ir al historial de síntomas
            },
          ),

          body: _buildHomeBody(),

          bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
        );
      },
    );
  }

  // --- WIDGET DEL CONTENIDO DE LA PANTALLA DE INICIO ---
  Widget _buildHomeBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), 

            _buildEvaluationCard(),
            const SizedBox(height: 20),

            _buildInfoCard(
              icon: Icons.favorite_border,
              iconBgColor: const Color(0xFFFEEEEE),
              iconColor: const Color(0xFFE57373),
              title: 'Urgencias',
              subtitle: 'Cuando buscar ayuda',
              onTap: () { /* ... */ },
            ),
            const SizedBox(height: 20),

            _buildInfoCard(
              icon: Icons.tips_and_updates_outlined,
              iconBgColor: const Color(0xFFFFF8E1),
              iconColor: const Color(0xFFFFB74D),
              title: 'Consejos de salud',
              subtitle: 'Ventila tus espacios regularmente',
              onTap: () { /* ... */ },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- LOS WIDGETS DE LAS TARJETAS ---
  Widget _buildEvaluationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¿Como te sientes hoy?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Evalúa tus síntomas ahora',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla de Evaluación
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Iniciar evaluación',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.calendar_today_rounded, // Ícono de calendario
            color: Colors.white.withOpacity(0.5), // Sutil
            size: 70,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 45),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}