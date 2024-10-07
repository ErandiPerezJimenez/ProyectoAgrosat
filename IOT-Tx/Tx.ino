#include <SPI.h>
#include <LoRa.h>
#include <Wire.h>
#include <U8g2lib.h>

// Pines LoRa
#define SS 18
#define RST 14
#define DI0 26

// Inicializa la pantalla OLED
U8G2_SSD1306_128X64_NONAME_F_HW_I2C u8g2(U8G2_R0, /* reset=*/ U8X8_PIN_NONE);

// Variables globales
int packetCounter = 0;
unsigned long lastMillis = 0;
unsigned long previousMillis = 0;
const long interval = 500; // Intervalo de 500 milisegundos

void setup() {
  Serial.begin(9600);
  while (!Serial);

  // Inicializa la pantalla OLED
  u8g2.begin();
  u8g2.clearBuffer();
  u8g2.setFont(u8g2_font_ncenB08_tr);
  u8g2.drawStr(0, 10, "LoRa Transmitter");
  u8g2.sendBuffer();

  // Inicializa los pines del LoRa
  LoRa.setPins(SS, RST, DI0);

  if (!LoRa.begin(915E6)) {
    Serial.println("Starting LoRa failed!");
    u8g2.clearBuffer();
    u8g2.drawStr(0, 10, "Starting LoRa failed!");
    u8g2.sendBuffer();
    while (1);
  }

  // Sincroniza los milisegundos
  lastMillis = millis();
  previousMillis = millis();
}

void loop() {
  unsigned long currentMillis = millis();

  // Verificar si ha pasado el intervalo de tiempo
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;

    packetCounter++;

    // Genera valores aleatorios para los parámetros esperados
    char resistenciaStr[8];
    sprintf(resistenciaStr, "%+06.2f", random(0, 30000000) / 10.0);

    char altitudeStr[9];
    sprintf(altitudeStr, "%+07.2f", random(0, 10000) / 10.0);

    char latitudeStr[9];
    sprintf(latitudeStr, "%+07.2f", random(-900, 900) / 10.0);

    char longitudeStr[10];
    sprintf(longitudeStr, "%+07.2f", random(-1800, 1800) / 10.0);

    char temperatureStr[8];
    sprintf(temperatureStr, "%+06.2f", random(0, 500) / 10.0);

    char batteryLevelStr[8];
    sprintf(batteryLevelStr, "%+06.2f", random(0, 100) / 10.0);

    String transmission_status = "active";  // Puede ser cualquier valor string que desees

    // Crea el mensaje en el formato requerido
    String message = String(resistenciaStr) + "," + String(altitudeStr) + "," + 
                     String(latitudeStr) + "," + String(longitudeStr) + "," + 
                     String(temperatureStr) + "," + String(batteryLevelStr) + "," + 

    Serial.print("Sending packet: ");
    Serial.println(message);

    // Actualiza la pantalla OLED
    u8g2.clearBuffer();
    u8g2.drawStr(0, 10, "Sending packet:");
    u8g2.drawStr(0, 30, message.c_str());
    u8g2.sendBuffer();

    // Enviar paquete
    LoRa.beginPacket();
    LoRa.print(message);
    LoRa.endPacket();
  }
}