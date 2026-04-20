#include <WiFi.h>
#include <PubSubClient.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

// === CONFIGURACIÓN WI-FI ===
const char* ssid = "SterenC";
const char* password = "unodostrescuatro";

// === CONFIGURACIÓN MQTT (RASPBERRY PI) ===
const char* mqtt_server = "192.168.1.229"; // <<<--- ¡LA IP DE TU RASPBERRY PI!
const int mqtt_port = 1883;
const char* mqtt_topic_accel = "casa/esp32/mpu6050/accel";
const char* mqtt_topic_temp = "casa/esp32/mpu6050/temp";

// Objetos
WiFiClient espClient;
PubSubClient client(espClient);
Adafruit_MPU6050 mpu;

// Variables para tiempo
unsigned long lastMsg = 0;
const long interval = 2000; // Publicar cada 2 segundos

// === FUNCIÓN PARA CONECTAR A WI-FI ===
void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Conectando a ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi conectado");
  Serial.print("Dirección IP ESP32: ");
  Serial.println(WiFi.localIP());
}

// === FUNCIÓN PARA RECONECTAR AL BROKER MQTT ===
void reconnect() {
  while (!client.connected()) {
    Serial.print("Intentando conexión MQTT...");
    String clientId = "ESP32_MPU6050_";
    clientId += String(random(0xffff), HEX);
    
    if (client.connect(clientId.c_str())) {
      Serial.println("conectada");
    } else {
      Serial.print("falló, rc=");
      Serial.print(client.state());
      Serial.println(" intentando de nuevo en 5 segundos");
      delay(5000);
    }
  }
}

// === SETUP ===
void setup() {
  Serial.begin(115200);
  
  // Inicializar MPU6050
  if (!mpu.begin()) {
    Serial.println("No se encontró el sensor MPU6050. Revisa el cableado.");
    while (1) {
      delay(10);
    }
  }
  Serial.println("MPU6050 encontrado!");
  
  // Configurar rangos del sensor (opcional, valores por defecto)
  mpu.setAccelerometerRange(MPU6050_RANGE_2_G);
  mpu.setGyroRange(MPU6050_RANGE_250_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  // Conectar a WiFi
  setup_wifi();
  
  // Configurar servidor MQTT
  client.setServer(mqtt_server, mqtt_port);
}

// === LOOP PRINCIPAL ===
void loop() {
  // Reconectar a MQTT si es necesario
  if (!client.connected()) {
    reconnect();
  }
  client.loop(); // Mantener la comunicación MQTT activa

  unsigned long now = millis();
  if (now - lastMsg > interval) {
    lastMsg = now;
    
    // Obtener nuevos eventos del sensor
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);

    // --- Publicar datos de aceleración (como JSON) ---
    String accelPayload = "{\"x\":";
    accelPayload += a.acceleration.x;
    accelPayload += ",\"y\":";
    accelPayload += a.acceleration.y;
    accelPayload += ",\"z\":";
    accelPayload += a.acceleration.z;
    accelPayload += "}";
    
    client.publish(mqtt_topic_accel, accelPayload.c_str());
    Serial.print("Aceleración publicada: ");
    Serial.println(accelPayload);

    // --- Publicar datos de temperatura (como string simple) ---
    String tempPayload = String(temp.temperature);
    client.publish(mqtt_topic_temp, tempPayload.c_str());
    Serial.print("Temperatura publicada: ");
    Serial.println(tempPayload);
  }
}