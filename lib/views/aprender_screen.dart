import 'package:flutter/material.dart';
import 'package:medi_app/core/theme/app_colors.dart';
import './reutilizable/header.dart';
import './reutilizable/footer.dart';
import 'package:medi_app/views/reutilizable/sideMenu.dart';

class HealthCategory {
  final String id;
  final String name;
  final IconData icon;

  HealthCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class EducationalTopic {
  final String title;
  final String description;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String categoryId;
  final List<String> content;

  EducationalTopic({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.categoryId,
    required this.content,
  });
}

class AprenderScreen extends StatefulWidget {
  const AprenderScreen({Key? key}) : super(key: key);

  @override
  State<AprenderScreen> createState() => _AprenderScreenState();
}

class _AprenderScreenState extends State<AprenderScreen> {
  String _selectedCategoryId = 'respiratoria';

  final List<HealthCategory> _categories = [
    HealthCategory(
      id: 'respiratoria',
      name: 'Salud Respiratoria',
      icon: Icons.air,
    ),
    HealthCategory(
      id: 'nutricion',
      name: 'Nutrición',
      icon: Icons.restaurant,
    ),
    HealthCategory(
      id: 'mental',
      name: 'Salud Mental',
      icon: Icons.psychology,
    ),
    HealthCategory(
      id: 'ejercicio',
      name: 'Ejercicio',
      icon: Icons.fitness_center,
    ),
    HealthCategory(
      id: 'primeros_auxilios',
      name: 'Primeros Auxilios',
      icon: Icons.medical_services,
    ),
  ];

  final List<EducationalTopic> _allTopics = [
    // Salud Respiratoria
    EducationalTopic(
      title: 'Ventilación adecuada',
      description: 'Cómo mantener espacios ventilados',
      icon: Icons.wind_power,
      iconBgColor: const Color(0xFFE3F2FD),
      iconColor: const Color(0xFF2196F3),
      categoryId: 'respiratoria',
      content: [
        'Abre ventanas y puertas regularmente para permitir la circulación de aire fresco',
        'Ventila tu hogar al menos 10-15 minutos varias veces al día',
        'La ventilación cruzada es más efectiva: abre ventanas en lados opuestos',
        'Evita el uso excesivo de aire acondicionado sin ventilación natural',
        'Mantén las áreas húmedas (baños, cocina) bien ventiladas',
        'Los espacios cerrados sin ventilación pueden acumular CO2 y contaminantes',
      ],
    ),
    EducationalTopic(
      title: 'Gripe vs Resfriado',
      description: 'Aprende las diferencias',
      icon: Icons.thermostat,
      iconBgColor: const Color(0xFFF3E5F5),
      iconColor: const Color(0xFF9C27B0),
      categoryId: 'respiratoria',
      content: [
        'RESFRIADO: Síntomas graduales, congestión nasal, estornudos, dolor de garganta leve',
        'GRIPE: Inicio súbito, fiebre alta, dolores musculares intensos, fatiga extrema',
        'El resfriado común es más frecuente pero menos grave',
        'La gripe puede requerir atención médica, especialmente en grupos de riesgo',
        'Ambos son virales: los antibióticos NO son efectivos',
        'Prevención: lavado de manos, evitar contacto con personas enfermas, vacunación anual contra gripe',
      ],
    ),
    EducationalTopic(
      title: 'Asma: Cuidados básicos',
      description: 'Manejo y prevención de crisis',
      icon: Icons.healing,
      iconBgColor: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFFF9800),
      categoryId: 'respiratoria',
      content: [
        'Identifica y evita desencadenantes: polen, polvo, humo, pelo de mascotas',
        'Usa tu inhalador preventivo según prescripción médica',
        'Lleva siempre contigo tu inhalador de rescate',
        'Mantén un registro de tus síntomas y picos de flujo',
        'Evita hacer ejercicio intenso en ambientes fríos o contaminados',
        'Ten un plan de acción ante crisis asmáticas',
      ],
    ),
    EducationalTopic(
      title: 'Respiración profunda',
      description: 'Técnicas de respiración saludable',
      icon: Icons.self_improvement,
      iconBgColor: const Color(0xFFE8F5E9),
      iconColor: const Color(0xFF4CAF50),
      categoryId: 'respiratoria',
      content: [
        'Respiración diafragmática: inhala profundamente por la nariz expandiendo el abdomen',
        'Exhala lentamente por la boca durante más tiempo del que inhalaste',
        'Practica 5-10 minutos diarios para reducir estrés y mejorar oxigenación',
        'La respiración profunda fortalece los pulmones y mejora la capacidad respiratoria',
        'Útil antes de dormir, durante ansiedad o después de ejercicio',
        'Siéntate cómodamente con la espalda recta para mejor expansión pulmonar',
      ],
    ),

    // Nutrición
    EducationalTopic(
      title: 'Hidratación correcta',
      description: 'Importancia del agua en tu salud',
      icon: Icons.water_drop,
      iconBgColor: const Color(0xFFE0F7FA),
      iconColor: const Color(0xFF00BCD4),
      categoryId: 'nutricion',
      content: [
        'Bebe al menos 8 vasos (2 litros) de agua al día',
        'Aumenta consumo en climas calurosos o durante ejercicio',
        'La sed es señal de deshidratación leve: no esperes a tenerla',
        'Orina de color claro indica buena hidratación',
        'El agua ayuda a regular temperatura, transportar nutrientes y eliminar toxinas',
        'Alimentos con agua: sandía, pepino, naranjas también hidratan',
      ],
    ),
    EducationalTopic(
      title: 'Plato saludable',
      description: 'Cómo balancear tus comidas',
      icon: Icons.restaurant_menu,
      iconBgColor: const Color(0xFFF1F8E9),
      iconColor: const Color(0xFF8BC34A),
      categoryId: 'nutricion',
      content: [
        '50% de tu plato: verduras y frutas variadas',
        '25% proteínas: carnes magras, pescado, legumbres, huevo',
        '25% carbohidratos: cereales integrales, arroz, pasta, papa',
        'Incluye grasas saludables: aceite de oliva, aguacate, frutos secos',
        'Controla porciones: usa tu mano como referencia',
        'Varía colores en tu plato para diversidad de nutrientes',
      ],
    ),
    EducationalTopic(
      title: 'Azúcar oculta',
      description: 'Identifica azúcares añadidos',
      icon: Icons.warning_amber,
      iconBgColor: const Color(0xFFFFF9C4),
      iconColor: const Color(0xFFFBC02D),
      categoryId: 'nutricion',
      content: [
        'Lee etiquetas: busca palabras como jarabe, dextrosa, fructosa, sacarosa',
        'Bebidas azucaradas aportan calorías vacías sin nutrientes',
        'Límite recomendado: máximo 25g (6 cucharaditas) de azúcar añadida al día',
        'Yogures, cereales y salsas suelen contener azúcar oculta',
        'Elige versiones sin azúcar añadida o endulza naturalmente con fruta',
        'El consumo excesivo se asocia a diabetes, obesidad y caries',
      ],
    ),

    // Salud Mental
    EducationalTopic(
      title: 'Manejo del estrés',
      description: 'Técnicas para reducir la ansiedad',
      icon: Icons.spa,
      iconBgColor: const Color(0xFFF3E5F5),
      iconColor: const Color(0xFF9C27B0),
      categoryId: 'mental',
      content: [
        'Identifica tus fuentes de estrés y cómo te afectan',
        'Practica técnicas de relajación: respiración profunda, meditación',
        'Establece límites saludables en trabajo y relaciones',
        'Dedica tiempo a actividades que disfrutes',
        'Duerme 7-9 horas diarias para mejor manejo emocional',
        'Busca apoyo profesional si el estrés es abrumador',
      ],
    ),
    EducationalTopic(
      title: 'Sueño reparador',
      description: 'Mejora tu higiene del sueño',
      icon: Icons.bedtime,
      iconBgColor: const Color(0xFFE8EAF6),
      iconColor: const Color(0xFF3F51B5),
      categoryId: 'mental',
      content: [
        'Establece horarios regulares para dormir y despertar',
        'Evita pantallas 1 hora antes de dormir (luz azul afecta melatonina)',
        'Tu dormitorio debe ser oscuro, silencioso y fresco',
        'Evita cafeína después de las 2 PM',
        'Crea una rutina relajante antes de dormir: lectura, ducha tibia',
        'La falta de sueño afecta memoria, concentración y estado de ánimo',
      ],
    ),
    EducationalTopic(
      title: 'Conexiones sociales',
      description: 'Importancia de las relaciones',
      icon: Icons.groups,
      iconBgColor: const Color(0xFFFFE0B2),
      iconColor: const Color(0xFFFF9800),
      categoryId: 'mental',
      content: [
        'Las relaciones positivas protegen tu salud mental',
        'Dedica tiempo de calidad a familia y amigos',
        'Comunica tus sentimientos y escucha activamente',
        'Busca grupos con intereses comunes',
        'Limita relaciones tóxicas que drenan tu energía',
        'El apoyo social reduce estrés y aumenta resiliencia',
      ],
    ),

    // Ejercicio
    EducationalTopic(
      title: 'Actividad física diaria',
      description: 'Beneficios del movimiento',
      icon: Icons.directions_walk,
      iconBgColor: const Color(0xFFE1F5FE),
      iconColor: const Color(0xFF03A9F4),
      categoryId: 'ejercicio',
      content: [
        'Meta: al menos 150 minutos de actividad moderada por semana',
        'Caminar 30 minutos al día reduce riesgo de enfermedades crónicas',
        'El ejercicio libera endorfinas: mejora tu estado de ánimo',
        'Fortalece corazón, músculos y huesos',
        'Divide el ejercicio: 3 sesiones de 10 minutos son efectivas',
        'Elige actividades que disfrutes para mantener constancia',
      ],
    ),
    EducationalTopic(
      title: 'Estiramiento correcto',
      description: 'Previene lesiones y mejora flexibilidad',
      icon: Icons.accessibility_new,
      iconBgColor: const Color(0xFFF1F8E9),
      iconColor: const Color(0xFF689F38),
      categoryId: 'ejercicio',
      content: [
        'Estira después de calentar: músculos fríos son más propensos a lesiones',
        'Mantén cada estiramiento 15-30 segundos sin rebotar',
        'Respira profundamente: no contengas la respiración',
        'No debe doler: estira hasta sentir tensión leve',
        'Estira grupos musculares principales: piernas, espalda, hombros',
        'El estiramiento regular mejora postura y reduce dolores',
      ],
    ),
    EducationalTopic(
      title: 'Ejercicio en casa',
      description: 'Rutinas sin equipo necesario',
      icon: Icons.home,
      iconBgColor: const Color(0xFFFFECB3),
      iconColor: const Color(0xFFFFA726),
      categoryId: 'ejercicio',
      content: [
        'Sentadillas: fortalecen piernas y glúteos',
        'Flexiones: trabajan pecho, brazos y core',
        'Plancha: excelente para abdomen y espalda',
        'Escaleras: cardio efectivo subiendo y bajando',
        'Saltos: aumentan frecuencia cardíaca rápidamente',
        'No necesitas gimnasio para estar en forma',
      ],
    ),

    // Primeros Auxilios
    EducationalTopic(
      title: 'RCP básico',
      description: 'Puede salvar una vida',
      icon: Icons.favorite,
      iconBgColor: const Color(0xFFFFEBEE),
      iconColor: const Color(0xFFE53935),
      categoryId: 'primeros_auxilios',
      content: [
        'Verifica respuesta: toca y pregunta "¿Estás bien?"',
        'Llama al 911 o pide que alguien más lo haga',
        'Compresiones: centro del pecho, 100-120 por minuto',
        'Profundidad: 5-6 cm, deja que el pecho vuelva a su posición',
        'Si sabes, alterna 30 compresiones con 2 respiraciones',
        'No detengas hasta que llegue ayuda o la persona responda',
      ],
    ),
    EducationalTopic(
      title: 'Atragantamiento',
      description: 'Maniobra de Heimlich',
      icon: Icons.pan_tool,
      iconBgColor: const Color(0xFFFCE4EC),
      iconColor: const Color(0xFFEC407A),
      categoryId: 'primeros_auxilios',
      content: [
        'Señal universal: manos en el cuello',
        'Pregunta: "¿Te estás atragantando?"',
        'Si la persona no puede hablar, toser o respirar, actúa',
        'Párate detrás, abraza por la cintura',
        'Puño cerrado sobre el ombligo, cúbrelo con la otra mano',
        'Compresiones rápidas hacia adentro y arriba hasta expulsar objeto',
      ],
    ),
    EducationalTopic(
      title: 'Hemorragias',
      description: 'Cómo controlar sangrado',
      icon: Icons.bloodtype,
      iconBgColor: const Color(0xFFFFCDD2),
      iconColor: const Color(0xFFF44336),
      categoryId: 'primeros_auxilios',
      content: [
        'Presión directa: usa gasa o tela limpia sobre la herida',
        'Eleva la zona lesionada por encima del corazón si es posible',
        'Mantén presión constante durante al menos 10 minutos',
        'NO remuevas el primer apósito aunque se empape',
        'Si sangra profusamente o no para, busca ayuda médica inmediata',
        'Usa guantes si están disponibles para protegerte',
      ],
    ),
    EducationalTopic(
      title: 'Quemaduras leves',
      description: 'Tratamiento inicial',
      icon: Icons.local_fire_department,
      iconBgColor: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFFF6F00),
      categoryId: 'primeros_auxilios',
      content: [
        'Enfría inmediatamente con agua corriente fría (NO helada) 10-20 minutos',
        'NO uses hielo directo: puede dañar más tejido',
        'NO apliques mantequilla, pasta dental u otros remedios caseros',
        'Cubre con gasa estéril o paño limpio no adhesivo',
        'Si hay ampollas, NO las revientes',
        'Busca atención médica si: la quemadura es extensa, profunda o en cara/manos/genitales',
      ],
    ),
  ];

  List<EducationalTopic> get _filteredTopics {
    return _allTopics
        .where((topic) => topic.categoryId == _selectedCategoryId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _categories.firstWhere(
      (cat) => cat.id == _selectedCategoryId,
    );

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: const AppDrawer(),
      appBar: Header(
        title: 'Aprender',
        leadingIcon: const Icon(
          Icons.book_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: _buildTopicsList(),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildCategoryHeader(HealthCategory category) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.blueGradient,
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
                  'Aprende y Previene',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.favorite,
            color: Colors.white.withOpacity(0.7),
            size: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category.id == _selectedCategoryId;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: 18,
                    color: isSelected ? Colors.white : AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(category.name),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategoryId = category.id;
                });
              },
              selectedColor: AppColors.primaryBlue,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
              elevation: 2,
              pressElevation: 4,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _filteredTopics.length,
      itemBuilder: (context, index) {
        return _buildTopicCard(_filteredTopics[index]);
      },
    );
  }

  Widget _buildTopicCard(EducationalTopic topic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: () => _showTopicDetail(topic),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: topic.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  topic.icon,
                  color: topic.iconColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTopicDetail(EducationalTopic topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: topic.iconBgColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                topic.icon,
                                color: topic.iconColor,
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    topic.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Información importante:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...topic.content.map((point) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: topic.iconColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      point,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.5,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primaryBlue.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.primaryBlue,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Esta información es educativa. Ante cualquier duda o síntoma, consulta con un profesional de la salud.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}