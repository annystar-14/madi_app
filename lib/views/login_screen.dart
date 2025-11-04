import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medi_app/controllers/auth_provider.dart';
import 'package:medi_app/views/home_screen.dart';
import 'package:medi_app/views/registrer_screen.dart';
import '../core/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Estado para controlar la visibilidad de la contraseña
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authNotifier = ref.read(authStateProvider.notifier);
      try {
        await authNotifier.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
    
      } catch (e) {
        await Future.delayed(const Duration(milliseconds: 300));
        final user = ref.read(authStateProvider);
        if (user == null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error de inicio de sesión. Verifica tu correo y contraseña.')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<User?>(authStateProvider, (prev, next) {
    if (next != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  });

    return Scaffold(
      backgroundColor: AppColors.lightBackground, // Fondo claro
      body: Center( 
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Logo y subtítulos (fuera de la tarjeta)
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
                'Orientación en síntomas respiratorios',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // 2. Tarjeta con el Formulario de inicio de sesión
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
                        // Título "Iniciar Sesión"
                        const Text(
                          'Iniciar sesión',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration.copyWith(
                            labelText: 'Correo electrónico',
                            hintText: 'ejemplo@email.com',
                            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || !value.contains('@')) {
                              return 'Ingresa un correo válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: _inputDecoration.copyWith(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu contraseña';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Botón
                        ElevatedButton(
                          onPressed: _isLoading ? null : login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentTurquoise, 
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '¿No tienes cuenta?',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                );
                              },
                              child: const Text(
                                'Regístrate aquí',
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              const Text(
                'Tus datos están protegidos por encriptación',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Estilo de decoración de campos de texto reutilizable
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