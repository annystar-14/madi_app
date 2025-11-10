import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medi_app/controllers/auth_provider.dart';
import 'package:medi_app/core/theme/app_colors.dart';
import 'package:medi_app/views/aprender_screen.dart';
import 'package:medi_app/views/consulta.dart';
import 'package:medi_app/views/historial_screen.dart';
import 'package:medi_app/views/home_screen.dart';
import 'package:medi_app/views/perfil_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({Key? key}) : super(key: key);

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar tu sesión actual?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: AppColors.primaryBlue)),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () async {
                Navigator.of(context).pop(); 

                await ref.read(authStateProvider.notifier).signOut();

                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              child: const Text('Cerrar sesión',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(25)),
      ),
      child: Container(
        decoration: const BoxDecoration(
        gradient: AppColors.blueGradient,
      ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //botón de cerrar (X)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),

              _buildDrawerItem(
                context: context,
                icon: Icons.home_rounded,
                text: 'Inicio',
                onTap: () {
                  Navigator.of(context).pop();
                  _navigateToScreen(context, const HomeScreen());
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.medical_services,
                text: 'Consulta médica IA',
                onTap: () {
                  Navigator.of(context).pop();
                  _navigateToScreen(context, const ConsultaScreen());
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.history,
                text: 'Historial',
                onTap: () {
                 Navigator.of(context).pop();
                  _navigateToScreen(context, const HistorialScreen());
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.book_outlined,
                text: 'Aprender',
                onTap: () {
                  Navigator.of(context).pop();
                  _navigateToScreen(context, const AprenderScreen());
                },
              ),
              
              const Spacer(),

              const Divider(color: Colors.white38, indent: 20, endIndent: 20),
              
              _buildDrawerItem(
                context: context,
                icon: Icons.account_circle_outlined,
                text: 'Mi perfil',
                onTap: () {
                  Navigator.of(context).pop();
                  _navigateToScreen(context, const PerfilScreen());
                },
              ),
      
              _buildDrawerItem(
                context: context,
                icon: Icons.logout,
                text: 'Cerrar sesión',
                onTap: ()  {
                  _showLogoutConfirmationDialog(context, ref);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 28),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 10,
    );
  }
}