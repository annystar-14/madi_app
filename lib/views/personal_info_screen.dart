import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medi_app/views/home_screen.dart';
import '../core/theme/app_colors.dart'; 

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _fechaController = TextEditingController();
  final _telefonoController = TextEditingController();
  bool _isSaving = false;
  DateTime? _selectedDate;

  Future<void> guardarDatos() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
          'nombre': _nombreController.text.trim(),
          'apellidos': _apellidosController.text.trim(),
          'fecha_nacimiento': _selectedDate,
          'telefono': _telefonoController.text.trim(),
          'correo': user.email,
          'creadoEn': DateTime.now(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos personales guardados correctamente')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar datos: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), //no fechas futuras para nacimiento
      helpText: 'Selecciona tu fecha de nacimiento',
      confirmText: 'Seleccionar',
      cancelText: 'Cancelar',
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
      setState(() {
        _selectedDate = picked;
        _fechaController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground, 
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Logo y subtítulos
              Image.asset(
                'lib/public/logo.png',
                height: 100, 
                width: 100,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'MediApp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Registro de información personal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // 2. Tarjeta con el Formulario
              Card(
                color: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form( 
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
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
                          controller: _nombreController,
                          decoration: _inputDecoration.copyWith(
                            labelText: 'Nombre',
                            hintText: 'Tu nombre',
                            prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                          ),
                          validator: (v) => v == null || v.isEmpty ? "Ingresa tu nombre" : null,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _apellidosController,
                          decoration: _inputDecoration.copyWith(
                            labelText: "Apellidos",
                            hintText: "Tus apellidos",
                            prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                          ),
                          validator: (v) => v == null || v.isEmpty ? "Ingresa tus apellidos" : null,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _fechaController,
                          keyboardType: TextInputType.none, // Oculta el teclado
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: _inputDecoration.copyWith(
                            labelText: "Fecha de nacimiento",
                            hintText: "dd/mm/aaaa",
                            suffixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primaryBlue),
                          ),
                          validator: (v) {
                          if (v == null || v.isEmpty) return "Selecciona tu fecha de nacimiento";
                          if (_selectedDate == null) return "Fecha no válida";
                          return null;
                        },
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _telefonoController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration.copyWith(
                            labelText: "Teléfono",
                            hintText: "Ej. 9611234567",
                            prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                          ),
                          validator: null,
                        ),
                        const SizedBox(height: 25),

                        // Botón Registrar
                        ElevatedButton(
                          onPressed: _isSaving ? null : guardarDatos,
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
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ), 
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}
