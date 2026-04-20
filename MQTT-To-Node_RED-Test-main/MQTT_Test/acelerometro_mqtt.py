import paho.mqtt.client as mqtt
import smbus2
import time
import json
import math

# --- Configuracion del Sensor (MPU6050) ---
MPU6050_ADDR = 0x68  # Direccion I2C del MPU6050
POWER_MGMT_1 = 0x6B
ACCEL_XOUT_H = 0x3B

bus = smbus2.SMBus(1)  # Usa el bus I2C-1 de la Raspberry Pi
# Despertar el MPU6050 (escribe 0 en el registro de gestion de energoa)
bus.write_byte_data(MPU6050_ADDR, POWER_MGMT_1, 0)

# --- Configuracion MQTT ---
MQTT_BROKER = "localhost"  # Direccion de tu broker MQTT (Mosquitto en la misma Pi)
MQTT_PORT = 1883
MQTT_TOPIC = "sensor/acelerometro"  # Topic donde se publicaron los datos
INTERVALO_SEGUNDOS = 1  # Frecuencia de lectura y envio

# Funcion para leer datos "crudos" del sensor
def read_raw_data(addr):
    # Leer dos bytes (high y low) y combinarlos
    high = bus.read_byte_data(MPU6050_ADDR, addr)
    low = bus.read_byte_data(MPU6050_ADDR, addr+1)
    value = (high << 8) | low
    # Convertir a valor con signo (complemento a dos)
    if value > 32768:
        value = value - 65536
    return value

# Configuracion del cliente MQTT
client = mqtt.Client()
try:
    client.connect(MQTT_BROKER, MQTT_PORT, 60)
    print(f"Conectado al broker MQTT {MQTT_BROKER}:{MQTT_PORT}")
except Exception as e:
    print(f"Error al conectar al broker: {e}")
    exit(1)

print(f"Publicando en topic '{MQTT_TOPIC}' cada {INTERVALO_SEGUNDOS} segundo(s)...")

try:
    while True:
        # Leer acelerometro (ejes X, Y, Z)
        accel_x = read_raw_data(ACCEL_XOUT_H)
        accel_y = read_raw_data(ACCEL_XOUT_H + 2)
        accel_z = read_raw_data(ACCEL_XOUT_H + 4)

        # Opcional: Convertir a gravedades (g) 
        # Dividir por la escala (por defecto 16384 para +-2g)
        # ax = accel_x / 16384.0
        # ay = accel_y / 16384.0
        # az = accel_z / 16384.0

        # Crear un payload en formato JSON
        payload = json.dumps({
            "x": accel_x,
            "y": accel_y,
            "z": accel_z
            # "x_g": round(ax, 3),
            # "y_g": round(ay, 3),
            # "z_g": round(az, 3)
        })

        # Publicar el mensaje
        result = client.publish(MQTT_TOPIC, payload)
        status = result.rc
        if status == mqtt.MQTT_ERR_SUCCESS:
            print(f"Enviado: {payload}")
        else:
            print(f"Error al enviar el mensaje, codigo: {status}")

        time.sleep(INTERVALO_SEGUNDOS)

except KeyboardInterrupt:
    print("Detenido por el usuario.")
finally:
    bus.close()
    client.disconnect()
    print("Conexion cerrada.")
