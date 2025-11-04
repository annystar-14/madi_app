import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medi_app/views/perfil_screen.dart';
import '../../core/theme/app_colors.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  // --- PARÁMETROS ---
  final bool isHomeScreen;
  final String? userName;
  final String? statusText;
  final VoidCallback? onStatusCardPressed;
  final String? title;
  final Widget? leadingIcon;

  // --- ALTURAS ---
  static const double _homeHeaderHeight = 200.0; // Altura para Home
  static const double _simpleHeaderHeight = 80.0; // Altura para otras vistas

  const Header({
    Key? key,
    this.isHomeScreen = false,
    this.userName,
    this.statusText,
    this.onStatusCardPressed,
    this.title,
    this.leadingIcon, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isHomeScreen
        ? _buildHomeScreenHeader(context)
        : _buildSimpleHeader(context);
  }

  /// -------------------------------------------
  /// CONSTRUCTOR PARA HOME
  /// -------------------------------------------
  Widget _buildHomeScreenHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
          child: Column(
            children: [
              // Fila superior (Saludo e Iconos)
              _buildHomeTopRow(context),
  
              const Spacer(), 

              // Tarjeta de estado
              _buildStatusCard(context),
            ],
          ),
        ),
      ),
    );
  }

  /// -------------------------------------------
  /// CONSTRUCTOR SIMPLE (OTRAS VISTAS)
  /// -------------------------------------------
  Widget _buildSimpleHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Center(
            child: _buildSimpleTopRow(context),
          ),
        ),
      ),
    );
  }


  // --- WIDGETS INTERNOS ---

  // fila superior para HOME (con saludo)
  Widget _buildHomeTopRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
             InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilScreen()),
                );
              },
              child: const Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, ${userName ?? 'Usuario'}!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Bienvenido a MediApp',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Iconos
        _buildActionIcons(context),
      ],
    );
  }

  // fila superior para OTRAS VISTAS
  Widget _buildSimpleTopRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            if (leadingIcon != null) // Mostrar icono si existe
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: leadingIcon!,
              ),
            Text(
              title ?? 'MediApp',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        // Iconos
        _buildActionIcons(context),
      ],
    );
  }

  Widget _buildActionIcons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(
          builder: (BuildContext innerContext) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 33),
              onPressed: () {
                Scaffold.of(innerContext).openDrawer();
              },
            );
          },
        ),
      ],
    );
  }

  // Widget para la tarjeta de estado (solo se usa en Home)
  Widget _buildStatusCard(BuildContext context) {
    return InkWell(
      onTap: onStatusCardPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estado actual',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText ?? 'Sin sintomas registrados',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Icon(
              CupertinoIcons.waveform_path_ecg,
              color: Color.fromARGB(171, 255, 255, 255),
              size: 60,
            ),
          ],
        ),
      ),
    );
  }

  /// -------------------------------------------
  /// TAMAÑO PREFERIDO (CONDICIONAL)
  /// -------------------------------------------
  @override
  Size get preferredSize => Size.fromHeight(
        // altura grande para el home, y la simple para el resto
        isHomeScreen ? _homeHeaderHeight : _simpleHeaderHeight,
      );
}