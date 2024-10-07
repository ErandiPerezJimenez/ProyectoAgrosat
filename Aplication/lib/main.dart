import 'package:flutter/material.dart';
import 'dart:async'; // Para temporizadores
import 'api_service.dart'; // Asegúrate de importar tu servicio de API

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configurar la animación de opacidad
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Iniciar la animación
    _controller.forward();

    // Navegar a la siguiente pantalla después de 4 segundos
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PantallaPrincipal()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Para modificar el texto principal al abrir la aplicación
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: const Text(
            'AgrosatSolutions',
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AgrosatSolutions',
          style: TextStyle(
            fontSize: 24, // Tamaño más grande
            fontWeight: FontWeight.bold, // Negrita para que sea más ancha
          ),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Número de columnas
          childAspectRatio: 1, // Para hacer los botones cuadrados
          children: [
            _buildButton(context, 'Mediciones en Tiempo Real', const MedicionPantalla()),
            _buildButton(context, 'Mapas y Visualización Geoespacial', const MapaPantalla()),
            _buildButton(context, 'Gestión de Recursos y Simulaciones', const GestionRecursosPantalla()),
            _buildButton(context, 'Alertas y Recomendaciones', const AlertasPantalla()),
            _buildButton(context, 'Interacción y Aprendizaje', const InteraccionPantalla()),
            _buildButton(context, 'Tutoriales Centro de Alertas', const TutorialesPantalla()),
          ],
        ),
      ),
    );
  }

  // Método para construir botones cuadrados
  Widget _buildButton(BuildContext context, String title, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
      },
      child: Text(title),
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: const EdgeInsets.all(20), // Espaciado dentro del botón
      ),
    );
  }
}

// Pantallas adicionales (MedicionPantalla, MapaPantalla, etc.)

class MedicionPantalla extends StatefulWidget {
  const MedicionPantalla({Key? key}) : super(key: key);

  @override
  _MedicionPantallaState createState() => _MedicionPantallaState();
}

class _MedicionPantallaState extends State<MedicionPantalla> {
  late Future<DatosClima> _datosClima; // Define el futuro para los datos del clima
  final ApiService apiService = ApiService('https://api.openweathermap.org/data/2.5');

  @override
  void initState() {
    super.initState();
    // Reemplaza 'Ciudad' y 'tu-api-key' con los valores reales
    _datosClima = apiService.fetchDatosClima('Ciudad', 'tu-api-key');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mediciones en Tiempo Real'),
      ),
      body: FutureBuilder<DatosClima>(
        future: _datosClima,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            DatosClima datos = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ciudad: ${datos.nombre}', style: const TextStyle(fontSize: 24)),
                  Text('Temperatura: ${datos.temperatura}°C', style: const TextStyle(fontSize: 24)),
                  Text('Velocidad del viento: ${datos.viento} m/s', style: const TextStyle(fontSize: 24)),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }
}

// Clases de subpantallas
class MapaPantalla extends StatelessWidget {
  const MapaPantalla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapas y Visualización Geoespacial')),
      body: const Center(child: Text('Contenido de Mapas y Visualización Geoespacial')),
    );
  }
}

class GestionRecursosPantalla extends StatelessWidget {
  const GestionRecursosPantalla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Recursos y Simulaciones')),
      body: const Center(child: Text('Contenido de Gestión de Recursos y Simulaciones')),
    );
  }
}

class AlertasPantalla extends StatelessWidget {
  const AlertasPantalla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas y Recomendaciones')),
      body: const Center(child: Text('Contenido de Alertas y Recomendaciones')),
    );
  }
}

class InteraccionPantalla extends StatelessWidget {
  const InteraccionPantalla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interacción y Aprendizaje')),
      body: const Center(child: Text('Contenido de Interacción y Aprendizaje')),
    );
  }
}

class TutorialesPantalla extends StatelessWidget {
  const TutorialesPantalla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutoriales Centro de Alertas')),
      body: const Center(child: Text('Contenido de Tutoriales Centro de Alertas')),
    );
  }
}
