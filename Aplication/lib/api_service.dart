// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<DatosClima> fetchDatosClima(String ciudad, String apiKey) async {
    // Construye la URL usando la ciudad y la clave API
    final response = await http.get(Uri.parse('$baseUrl/weather?q=$ciudad&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return DatosClima.fromJson(jsonData);
    } else {
      throw Exception('Failed to load climate data');
    }
  }
}

// Clase de modelo DatosClima
class DatosClima {
  final String nombre;
  final double temperatura;
  final double viento;

  DatosClima(this.nombre, this.temperatura, this.viento);

  factory DatosClima.fromJson(Map<String, dynamic> json) {
    return DatosClima(
      json['name'], // Nombre de la ciudad
      json['main']['temp'].toDouble(), // Temperatura
      json['wind']['speed'].toDouble(), // Velocidad del viento
    );
  }
}
