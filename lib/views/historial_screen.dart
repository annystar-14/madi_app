import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:medi_app/core/theme/app_colors.dart';
import 'package:medi_app/views/consulta.dart';
import 'package:medi_app/views/reutilizable/header.dart';
import 'package:medi_app/views/reutilizable/footer.dart';
import 'package:medi_app/views/reutilizable/sideMenu.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<QuerySnapshot<Map<String, dynamic>>> getConsultas() async {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user!.uid)
        .collection('consultas')
        .orderBy('fecha', descending: true)
        .get();
  }

  Future<void> eliminarConsulta(String docId) async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user!.uid)
        .collection('consultas')
        .doc(docId)
        .delete();
    setState(() {});
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String docId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, 
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirmar eliminación'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '¿Estás seguro de que quieres eliminar esta consulta?',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text('Esta acción no se puede deshacer.',
                    style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar',
                  style: TextStyle(color: AppColors.primaryBlue)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                eliminarConsulta(docId);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Eliminar',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showRecipeDialog(
      BuildContext context, DateTime fecha, String sintomas, String diagnostico) {
      final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(fecha);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryBlue, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'lib/public/logo.png',
                        height: 30,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'MediApp',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryBlue),
                      ),
                      const Spacer(),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  const Divider(
                      height: 25, thickness: 2, color: AppColors.primaryBlue),
                  const Text(
                    'Síntomas ingresados:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.accentTurquoise),
                    ),
                    child: Text(
                      sintomas,
                      style: const TextStyle(
                          fontSize: 15, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Diagnóstico por IA:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.accentTurquoise),
                    ),
                    child: Text(
                      diagnostico,
                      style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                          height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Cerrar',
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                      child: Text(
                    'Esto no sustituye el consejo médico profesional.',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: const AppDrawer(),
      appBar: Header(
        title: 'Diagnósticos',
        leadingIcon: const Icon(Icons.history, color: Colors.white, size: 30),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: getConsultas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        size: 100, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text(
                      'Aún no tienes consultas registradas.',
                      style:
                          TextStyle(fontSize: 18, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ConsultaScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                      label: const Text(
                        'Iniciar nueva consulta',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final consultas = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 70),
            itemCount: consultas.length,
            itemBuilder: (context, index) {
              final consulta = consultas[index];
              final fecha = (consulta['fecha'] as Timestamp).toDate();
              final sintomas = consulta['sintomas'] ?? 'Síntomas no especificados';
              final diagnostico = consulta['resultado'] ?? 'Diagnóstico no disponible';
              final id = consulta.id;

              final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(fecha);
              final dateOnly = DateFormat('dd/MM/yyyy').format(fecha);
              final timeOnly = DateFormat('HH:mm').format(fecha);

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: InkWell(
                  onTap: () {
                    _showRecipeDialog(context, fecha, sintomas, diagnostico);
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.assignment, 
                                color: AppColors.primaryBlue, size: 28),
                            const SizedBox(width: 10),
                            Text(
                              'Consulta: $dateOnly',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accentTurquoise.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                timeOnly,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Colors.black12), // Separador
                        const SizedBox(height: 12),

                        Text(
                          'Síntomas:',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sintomas,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _ActionChip(
                              icon: Icons.visibility,
                              text: 'Ver receta',
                              color: AppColors.accentTurquoise,
                              onTap: () {
                                _showRecipeDialog(
                                    context, fecha, sintomas, diagnostico);
                              },
                            ),
                            const SizedBox(width: 15),
                            // Botón de Eliminar
                            _ActionChip(
                              icon: Icons.delete_outline,
                              text: 'Eliminar',
                              color: Colors.redAccent,
                              onTap: () {
                                _showDeleteConfirmationDialog(context, id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accentTurquoise,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConsultaScreen()),
          );
        },
        icon: const Icon(Icons.add_comment, color: Colors.white),
        label: const Text('Nueva consulta',
            style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(text,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}