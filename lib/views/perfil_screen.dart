import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medi_app/core/theme/app_colors.dart';
import 'package:medi_app/views/personal_info_screen.dart';
import './reutilizable/header.dart';
import './reutilizable/footer.dart';
import 'package:medi_app/views/reutilizable/sideMenu.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
  }

  InputDecoration get _inputDecoration => const InputDecoration(
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.0),
        ),
        labelStyle: TextStyle(color: AppColors.textSecondary),
      );

  void _showEditDialog(Map<String, dynamic> userData) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nombreController = TextEditingController(text: userData['nombre']);
    final TextEditingController apellidosController = TextEditingController(text: userData['apellidos']);
    final TextEditingController telefonoController = TextEditingController(text: userData['telefono']);
    final TextEditingController fechaController = TextEditingController(
      text: userData['fecha_nacimiento'] != null
          ? (() {
              final date = (userData['fecha_nacimiento'] as Timestamp).toDate();
              final day = date.day.toString().padLeft(2, '0');
              final month = date.month.toString().padLeft(2, '0');
              final year = date.year.toString();
              return '$day/$month/$year';
            })()
          : '',
    );

    DateTime? fechaNacimiento = userData['fecha_nacimiento'] != null
        ? (userData['fecha_nacimiento'] as Timestamp).toDate()
        : null;
    
    bool _isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => Dialog( 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Datos personales',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: nombreController,
                      decoration: _inputDecoration.copyWith(
                        labelText: 'Nombre',
                        hintText: 'Tu nombre',
                        prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: apellidosController,
                      decoration: _inputDecoration.copyWith(
                        labelText: 'Apellidos',
                        hintText: 'Tus apellidos',
                        prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Este campo es obligatorio';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: fechaController,
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: fechaNacimiento ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primaryBlue,
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.textSecondary,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setStateDialog(() {
                            fechaNacimiento = picked;
                            fechaController.text =
                                '${picked.day.toString().padLeft(2, '0')}/'
                                '${picked.month.toString().padLeft(2, '0')}/'
                                '${picked.year}';
                          });
                        }
                      },
                      decoration: _inputDecoration.copyWith(
                        labelText: 'Fecha de nacimiento',
                        hintText: 'dd/mm/aaaa',
                        suffixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primaryBlue),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: telefonoController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration.copyWith(
                        labelText: 'Teléfono',
                        hintText: 'Ej. 9611234567',
                        prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                      ),
                      validator: null, 
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setStateDialog(() => _isSaving = true);
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  try {
                                    await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).update({
                                      'nombre': nombreController.text.trim(),
                                      'apellidos': apellidosController.text.trim(),
                                      'telefono': telefonoController.text.trim().isEmpty ? null : telefonoController.text.trim(),
                                      'fecha_nacimiento': fechaNacimiento != null ? Timestamp.fromDate(fechaNacimiento!) : null,
                                    });

                                    if (mounted) Navigator.pop(context);
                                    if (mounted) setState(() {}); // Refresca la pantalla principal
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error al actualizar: $e')),
                                      );
                                    }
                                  } finally {
                                    if (mounted) setStateDialog(() => _isSaving = false);
                                  }
                                } else {
                                  if (mounted) setStateDialog(() => _isSaving = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentTurquoise,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Guardar datos',
                              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                    ),
                    
                    const SizedBox(height: 10),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar', style: TextStyle(color: AppColors.primaryBlue, fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: const AppDrawer(),
      appBar: Header(
        title: 'Perfil',
        leadingIcon: const Icon(
          Icons.account_circle_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¡Parece que aún no tienes información registrada!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PersonalInfoScreen(), 
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                      label: const Text(
                        'Agregar información',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final userData = snapshot.data!.data()!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _showEditDialog(userData),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentTurquoise,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Editar datos',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), 
                    side: const BorderSide(color: AppColors.inputBorder, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Mi información',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        _buildProfileListItem(
                          icon: Icons.email_outlined,
                          title: 'Correo electrónico',
                          subtitle: userData['correo'] ?? 'No disponible',
                          context: context,
                        ),
                        const SizedBox(height: 10),

                        _buildProfileListItem(
                          icon: Icons.person_outline,
                          title: 'Nombre(s)',
                          subtitle: userData['nombre'] ?? 'No asignado',
                          context: context,
                        ),
                        const SizedBox(height: 10),

                        _buildProfileListItem(
                          icon: Icons.person_outline,
                          title: 'Apellidos',
                          subtitle: userData['apellidos'] ?? 'No asignado',
                          context: context,
                        ),
                        const SizedBox(height: 10),

                        _buildProfileListItem(
                          icon: Icons.phone_outlined,
                          title: 'Teléfono',
                          subtitle: userData['telefono'] ?? 'No asignado',
                          context: context,
                        ),
                        const SizedBox(height: 10),

                        _buildProfileListItem(
                          icon: Icons.cake_outlined,
                          title: 'Fecha de nacimiento',
                          subtitle: userData['fecha_nacimiento'] != null
                              ? (() {
                                  final date = (userData['fecha_nacimiento'] as Timestamp).toDate();
                                  final day = date.day.toString().padLeft(2, '0');
                                  final month = date.month.toString().padLeft(2, '0');
                                  final year = date.year.toString();
                                  return '$day/$month/$year';
                                })()
                              : 'No asignado',
                          context: context,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildProfileListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}