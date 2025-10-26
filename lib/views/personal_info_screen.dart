/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medi_app/core/models/user_model.dart';
import 'package:medi_app/core/services/auth_service.dart';
import 'package:medi_app/views/home_screen.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  final String userId;
  const PersonalInfoScreen({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  int currentStep = 0;
  final UserInfo info = UserInfo();

  void _nextStep() {
    setState(() {
      currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      currentStep--;
    });
  }

  Future<void> _finishRegistration(UserInfo info) async {
    final authService = AuthService();

    try {
      // Guardar los datos personales en SQLite
      await authService.savePersonalInfo(
        info.userId!,
        UserModel(
          email: info.userId!,
          name: info.name,
          lastName: info.surname,
          gender: info.gender,
        ),
      );

      print('✅ Datos personales guardados en SQLite para ${info.userId}');
    } catch (e) {
      print('⚠️ Error al guardar datos personales en SQLite: $e');
    }

    // Ir al Home después del registro
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      PersonalInfoStep1(
        info: info,
        onNext: _nextStep,
      ),
      PersonalInfoStep2(
        info: info,
        onNext: _nextStep,
        onBack: _previousStep,
      ),
      PersonalInfoStep3(
        info: info,
        onFinish: () {
          info.userId = widget.userId;
          _finishRegistration(info);
        },
        onBack: _previousStep,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información personal'),
        centerTitle: true,
      ),
      body: steps[currentStep],
    );
  }
}

/// Modelo temporal para recopilar los datos del usuario antes de guardarlos
class UserInfo {
  String? userId;
  String name = '';
  String surname = '';
  String gender = '';
  double height = 0;
  double weight = 0;
}

/// --- PASO 1: Nombre y Apellido ---
class PersonalInfoStep1 extends StatelessWidget {
  final UserInfo info;
  final VoidCallback onNext;

  const PersonalInfoStep1({Key? key, required this.info, required this.onNext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: info.name);
    final surnameController = TextEditingController(text: info.surname);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Paso 1 de 3', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: surnameController,
            decoration: const InputDecoration(labelText: 'Apellido'),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              info.name = nameController.text;
              info.surname = surnameController.text;
              onNext();
            },
            child: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}

/// --- PASO 2: Género ---
class PersonalInfoStep2 extends StatelessWidget {
  final UserInfo info;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const PersonalInfoStep2({
    Key? key,
    required this.info,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selectedGender = info.gender;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Paso 2 de 3', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: selectedGender.isNotEmpty ? selectedGender : null,
            items: const [
              DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
              DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
              DropdownMenuItem(value: 'Otro', child: Text('Otro')),
            ],
            onChanged: (value) {
              info.gender = value ?? '';
            },
            decoration: const InputDecoration(labelText: 'Género'),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(onPressed: onBack, child: const Text('Atrás')),
              ElevatedButton(onPressed: onNext, child: const Text('Siguiente')),
            ],
          ),
        ],
      ),
    );
  }
}

/// --- PASO 3: Altura y Peso ---
class PersonalInfoStep3 extends StatelessWidget {
  final UserInfo info;
  final VoidCallback onFinish;
  final VoidCallback onBack;

  const PersonalInfoStep3({
    Key? key,
    required this.info,
    required this.onFinish,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightController =
        TextEditingController(text: info.height.toString());
    final weightController =
        TextEditingController(text: info.weight.toString());

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Paso 3 de 3', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Altura (cm)'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Peso (kg)'),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(onPressed: onBack, child: const Text('Atrás')),
              ElevatedButton(
                onPressed: () {
                  info.height = double.tryParse(heightController.text) ?? 0;
                  info.weight = double.tryParse(weightController.text) ?? 0;
                  onFinish();
                },
                child: const Text('Finalizar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/
