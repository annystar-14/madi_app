import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:medi_app/core/theme/app_colors.dart';
import './reutilizable/header.dart';
import './reutilizable/footer.dart';
import 'package:medi_app/views/reutilizable/sideMenu.dart';

const String _apiKey = "AIzaSyCatsvDrs6Z5xdSGEXb7D4wtPcoWoXMqiY"; 
const String _apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=$_apiKey";

class Message {
  final String text;
  final bool isUser;
  final List<String>? quickReplies;
  Message({required this.text, required this.isUser, this.quickReplies});
}

class DiagnosisResult {
  final String name;
  final String description;
  final String treatmentAdvice;
  DiagnosisResult({
    required this.name,
    required this.description,
    required this.treatmentAdvice});
}

class StructuredResponse {
  final String status;
  final String? question;
  final List<String>? options;
  final List<DiagnosisResult>? conditions;
  final String? disclaimer;

  StructuredResponse(
      {required this.status,
      this.question,
      this.options,
      this.conditions,
      this.disclaimer});

  factory StructuredResponse.fromJson(Map<String, dynamic> json) {
    final disclaimer =
        json['advertencia'] ?? 'ADVERTENCIA: Consulta a un médico.';
    if (json['status'] == 'FOLLOW_UP') {
      return StructuredResponse(
        status: json['status'],
        question: json['data']['question'],
        options: List<String>.from(json['data']['options'] ?? []),
        disclaimer: disclaimer,
      );
    } else if (json['status'] == 'DIAGNOSIS_READY') {
      List<DiagnosisResult> conditions =
          (json['data']['conditions'] as List).map((item) {
        return DiagnosisResult(
          name: item['name'] ?? '',
          description: item['description'] ?? '',
          treatmentAdvice: item['treatment_advice'] ?? '',
        );
      }).toList();
      return StructuredResponse(
        status: json['status'],
        conditions: conditions,
        disclaimer: disclaimer,
      );
    }
    throw const FormatException("Respuesta de IA con formato JSON desconocido.");
  }
}

class ChatProvider extends ChangeNotifier {
  final List<Message> _messages = [];
  //nueva lista
  final List<String> _successfulUserQueries = [];

  bool _isLoading = false;
  final TextEditingController inputController = TextEditingController();

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendQuery({String? text, bool isQuickReply = false}) async {
    String userQuery = "";

    if (isQuickReply && text != null) {
      userQuery = text;
      _messages.add(Message(text: userQuery, isUser: true));
    } else {
      final freeText = inputController.text.trim();
      if (freeText.isEmpty) return;
      userQuery = freeText;
      _messages.add(Message(text: userQuery, isUser: true));
      inputController.clear();
    }

    final currentQueryToTrack = userQuery;

    _isLoading = true;
    notifyListeners();

    final conversationHistory = _messages
        .map((m) => "${m.isUser ? 'Usuario' : 'Asistente'}: ${m.text}")
        .join('\n');

    const systemPrompt =
        "Actúa como un asistente de triaje de síntomas no médico. Tu objetivo es guiar al usuario a través de preguntas de seguimiento o proporcionar una lista de posibles afecciones y consejos de autocuidado. NUNCA diagnostiques oficialmente una enfermedad. Siempre incluye una ADVERTENCIA estricta. Responde SIEMPRE con una única estructura JSON. Usa SOLO las claves: 'status', 'advertencia', 'data'. Para 'FOLLOW_UP', 'data' debe tener 'question' y 'options'. Para 'DIAGNOSIS_READY', 'data' debe tener 'conditions', donde CADA condición DEBE incluir los campos de 'name' que es el nombre de la afección, 'description' que la descripcion de la afección, y 'treatment_advice' que son los consejos de autocuidado.";

    final userInstruction =
        "Analiza esta conversación y la última entrada del usuario. Si es la primera interacción o si la información es insuficiente (ej: solo un síntoma muy vago), genera una pregunta de seguimiento relevante con tres opciones de respuesta. Si la información ingresada no esta relacionada con ningun síntoma recuerdale al usuario tu proposito amablemente sobre detectar afecciones con base a síntomas ingresados por el usuario. Si la información es suficiente (minimo 5 síntomas), genera un diagnóstico de posibles afecciones (máximo 3) con el nombre de la posible afección junto con sus descripciones y consejos de tratamiento/autocuidado. Historia: \n$conversationHistory\n\nÚltima entrada: $userQuery";

    final payload = json.encode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": userInstruction}
          ]
        }
      ],
      "systemInstruction": {
        "parts": [
          {"text": systemPrompt}
        ]
      },
      "generationConfig": {
        "responseMimeType": "application/json",
      }
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      if (response.statusCode != 200) {
        throw Exception('Error ${response.statusCode}');
      }

      final result = json.decode(response.body);

      final List candidates = result['candidates'] ?? [];
      if (candidates.isEmpty) {
        throw const FormatException("La IA no devolvió 'candidates'.");
      }

      final contentParts = candidates[0]['content']['parts'] ?? [];
      if (contentParts.isEmpty) {
        throw const FormatException("La IA no devolvió contenido de respuesta.");
      }

      final dynamic contentText = contentParts[0]['text'];

      String rawJson;
      if (contentText is String) {
        rawJson = contentText;
      } else if (contentText is Map<String, dynamic>) {

        rawJson = json.encode(contentText);
      } else {
        throw const FormatException("El contenido de la IA no es String ni Map.");
      }

      final cleanedJson = rawJson
          .trim()
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final Map<String, dynamic> jsonData = json.decode(cleanedJson) as Map<String, dynamic>;

      final structuredData = StructuredResponse.fromJson(jsonData);

      _successfulUserQueries.add(currentQueryToTrack);

      if (structuredData.status == "FOLLOW_UP") {
        _messages.add(Message(
          text: structuredData.question!,
          isUser: false,
          quickReplies: structuredData.options,
        ));
      } else if (structuredData.status == "DIAGNOSIS_READY") {
        String diagnosisText = "${structuredData.disclaimer}\n\n";
        diagnosisText +=
            "Basado en tu información, estas son posibles afecciones:\n";

        for (var cond in structuredData.conditions!) {
          diagnosisText += "\n--- ${cond.name.toUpperCase()} ---\n";
          diagnosisText += "Descripción: ${cond.description}\n";
          diagnosisText +=
              "Consejo de autocuidado: ${cond.treatmentAdvice}\n";
        }

        _messages.add(Message(text: diagnosisText, isUser: false));

        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final allSymptoms = _successfulUserQueries.join('; ');
            await FirebaseFirestore.instance
                .collection('usuarios')
                .doc(user.uid)
                .collection('consultas')
                .add({
              'fecha': Timestamp.now(),
              'sintomas': allSymptoms,
              'resultado': diagnosisText,
            });
            _successfulUserQueries.clear();
          }
        } catch (e) {
          debugPrint("Error al guardar la consulta en Firestore: $e");
        }
      }
    } catch (e) {
      _messages.add(Message(
          text:
              "Error de conexión o de la IA: Por favor, intenta de nuevo. $e",
          isUser: false));
    }

    _isLoading = false;
    notifyListeners();
  }

  void startConversation() {
    _messages.clear();
    _successfulUserQueries.clear();
    _messages.add(Message(
        text:
            "Hola, soy tu asistente médico virtual. Describe tus síntomas (por ejemplo: 'fiebre alta, tos seca') para empezar.",
        isUser: false));
    notifyListeners();
  }
}

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: chatProvider.messages.length,
                itemBuilder: (context, index) {
                  final message = chatProvider
                      .messages[chatProvider.messages.length - 1 - index];
                  return _buildMessage(context, message, chatProvider);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 40,
                          maxHeight: 100,
                        ),
                        child: Scrollbar(
                          thumbVisibility: false,
                          child: SingleChildScrollView(
                            reverse: true,
                            child: TextField(
                              controller: chatProvider.inputController,
                              maxLines: null, // crecimiento dinámico
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                hintText: 'Describe tus síntomas...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: chatProvider.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                  strokeWidth: 3, color: AppColors.primaryBlue),
                            ),
                          )
                        : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              if (chatProvider.inputController.text.isNotEmpty) {
                                chatProvider.sendQuery();
                              }
                            },
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.primaryBlue,
                              child: Icon(Icons.send, color: Colors.white),
                            ),
                          ),
                        ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildMessage(
      BuildContext context, Message message, ChatProvider provider) {
    final isUser = message.isUser;
    final alignment =
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUser ? AppColors.accentTurquoise : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isUser ? 18 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
              fontSize: 17,
              height: 1.4,
            ),
          ),
        ),
        if (message.quickReplies != null && message.quickReplies!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 4),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 6.0,
              children: message.quickReplies!.map((reply) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryBlue,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    provider.sendQuery(text: reply, isQuickReply: true);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      reply,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class ConsultaScreen extends StatelessWidget {
  const ConsultaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: const AppDrawer(),
      appBar: Header(
        title: 'Consulta médica IA',
        leadingIcon:
            const Icon(Icons.medical_services, color: Colors.white, size: 30),
      ),
      body: ChangeNotifierProvider(
        create: (context) {
          final provider = ChatProvider();
          provider.startConversation();
          return provider;
        },
        child: const ChatContent(),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
