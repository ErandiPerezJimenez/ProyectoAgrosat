#include <SPI.h>
#include <LoRa.h>
#include <Wire.h>
#include <U8g2lib.h>

// Pines LoRa
#define SS 18
#define RST 14
#define DI0 26

// Inicializa la pantalla OLED
U8G2_SSD1306_128X64_NONAME_F_HW_I2C u8g2(U8G2_R0, /* reset=*/ U8X8_PIN_NONE, /* clock=*/ SCL, /* data=*/ SDA);

void setup() {
  Serial.begin(9600);
  while (!Serial);

  // Inicializa la pantalla
  u8g2.begin();
  u8g2.clearBuffer();
  u8g2.setFont(u8g2_font_ncenB08_tr);
  u8g2.drawStr(0, 10, "LoRa Receiver");
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
}

void loop() {
  // Intenta recibir un paquete
  int packetSize = LoRa.parsePacket();
  if (packetSize) {
    // Recibir paquete
    String received = "";
    while (LoRa.available()) {
      received += (char)LoRa.read();
    }

    // Mostrar mensaje en la pantalla OLED
    u8g2.clearBuffer();
    u8g2.drawStr(0, 10, "Received packet:");
    u8g2.drawStr(0, 30, received.c_str());
    u8g2.drawStr(0, 50, ("RSSI: " + String(LoRa.packetRssi())).c_str());
    u8g2.sendBuffer();

    // Mostrar mensaje en el monitor serie
    Serial.print("Received packet: ");
    Serial.print(received);
    Serial.print(" with RSSI ");
    Serial.println(LoRa.packetRssi());

    // Enviar datos recibidos al puerto serie de la computadora
    Serial.println(received); // Esto imprime el paquete recibido sin texto adicional
  }
}

