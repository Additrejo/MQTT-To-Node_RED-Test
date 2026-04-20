# LINX – Laboratorio de Instrumentación Espacial.
# Proyecto: MQTT Test.  


![Proyecto](https://img.shields.io/badge/Proyecto-COLMENA%202-darkorange?style=for-the-badge) ![Área](https://img.shields.io/badge/Área-Programación-blue?style=for-the-badge) ![Área](https://img.shields.io/badge/Comunicaciones-yellow?style=for-the-badge) ![Status](https://img.shields.io/badge/Status-Activo-brightgreen?style=for-the-badge)

![MQTT_test_img](https://github.com/user-attachments/assets/f876b873-b5e6-48ee-9fd7-8a6d4f443be7)  
<!--------------------- PROYECTO DE LABORATORIO -------------------------->
<!--![Proyecto](https://img.shields.io/badge/Proyecto-NANOSWAI-blueviolet?style=for-the-badge) -->


<!--------------------- ETIQUETAS DE ÁREA DEL PROYECTO -------------------------->
<!--![Área](https://img.shields.io/badge/Área-Electrónica-blue?style=for-the-badge) -->   

<!--![Área](https://img.shields.io/badge/Área-Estructuras%20(CAD)-orange?style=for-the-badge) -->
<!-- ![Área](https://img.shields.io/badge/Área-Robótica-purple?style=for-the-badge) -->

<!-------------------- ETIQUETAS DE ESTATUS DEL PROYECTO ------------------------->

<!-- ![Área](https://img.shields.io/badge/Área-Simulación-green?style=for-the-badge) -->
<!--![Status](https://img.shields.io/badge/Status-En%20Pausa-yellow?style=for-the-badge) -->
<!--![Status](https://img.shields.io/badge/Status-Completado-blue?style=for-the-badge) -->
<!-- ![Status](https://img.shields.io/badge/Status-Archivado-gray?style=for-the-badge) -->

---
<!-------------------- DESCRIPCIÓN Y OBJETIVOS DEL PROYECTO ------------------------->


# 🎯 Descripción y objetivos

Este proyecto implementa un sistema IoT utilizando el protocolo MQTT para comunicación entre dispositivos. Utiliza una Raspberry Pi 5 como broker MQTT, una ESP32 con sensores y actuadores como cliente, y Node-RED para visualización y control en tiempo real.

* **Objetivo Principal:** Aprender a crear un broker y containers con comunicación MQTT para la interconección de diferentes dispositivos.
* **Objetivos Secundarios:**
    * Crear un broker.
    * Crear Docker containers que contengan sistemas y a su vez que se conecten al broker.
    * Aplicarlo de forma física en una maqueta.
    * Realizar pruebas de estabilidad.
    * Documentar el procedimiento para futuros proyectos que utilicen este tipo de protocolo. 
---

# 📊 Gestión del Proyecto

Toda la gestión de tareas, sprints y seguimiento de issues se maneja a través de nuestro tablero de GitHub Projects.

**➡️ [Ir al Tablero del Proyecto](httpsEscribe-aqui-el-enlace-a-tu-GitHub-Project)**

---
<!--
# 📜 Tabla de Contenidos

* [🎯 Objetivos](#-objetivos)
* [👥 Equipo y Responsables](#-equipo-y-responsables)
* [🛠️ Stack Tecnológico y Componentes](#-stack-tecnológico-y-componentes)
* [📁 Estructura del Repositorio](#-estructura-del-repositorio)
* [🚀 Instalación y Puesta en Marcha](#-instalación-y-puesta-en-marcha)
* [💡 Uso y Operación](#-uso-y-operación)
* [📚 Documentación Adicional](#-documentación-adicional)
* [⚖️ Licencia](#-licencia)
-->

# 📜 Tabla de Contenidos

* [🎯 Descripción y objetivos](#-descripción-y-objetivos)
* [📊 Gestión del Proyecto](#-gestión-del-proyecto)
* [👥 Equipo y Responsables](#-equipo-y-responsables)
* [🛠️ Stack Tecnológico y Componentes](#-stack-tecnológico-y-componentes)
  * [Software en Raspberry Pi 5](#software-en-raspberry-pi-5)
  * [Software en PC](#software-en-pc)
  * [Hardware y Componentes Clave](#hardware-y-componentes-clave)
* [📁 Estructura del Repositorio](#-estructura-del-repositorio)
* [⚠️ Aviso de buenas prácticas](#⚠️-aviso-de-buenas-prácticas)
* [Arquitectura del proyecto](#arquitectura-del-proyecto)
* [🚀 **Instalación y Puesta en Marcha**](#-instalación-y-puesta-en-marcha)
  * [1. Configuración Raspberry pi 5](#1-configuración-raspberry-pi-5)
  * [2. Configuración del Broker MQTT en Raspberry Pi](#2-configuración-del-broker-mqtt-en-raspberry-pi)
    * [Mosquitto](#mosquitto)
    * [2.1 Instalación de Mosquitto](#21-instalación-de-mosquitto)
    * [2.2 Actualizar el sistema](#22-actualizar-el-sistema)
    * [2.3 Instalar Mosquitto MQTT Broker](#23-instalar-mosquitto-mqtt-broker)
    * [2.4 Habilitar e iniciar el servicio](#24-habilitar-e-iniciar-el-servicio)
    * [2.6 Habilitar e iniciar el servicio](#26-habilitar-e-iniciar-el-servicio)
  * [3. Configuración de Mosquitto](#3-configuración-de-mosquitto)
    * [3.1 Editar configuración de Mosquitto](#31-editar-configuración-de-mosquitto)
    * [3.2 Agregar líneas al archivo](#32-agregar-las-siguientes-líneas-al-archivo)
    * [3.3 Reiniciar Mosquitto](#33-reiniciar-mosquitto)
  * [4. Probar el Broker](#4-probar-el-broker)
    * [4.1 Suscribirse a un topic](#41-suscribirse-a-un-topic-de-prueba-en-una-terminal)
    * [4.2 Publicar un mensaje](#42-en-otra-terminal-publicar-un-mensaje)
  * [5. Configuración de Node-RED en Raspberry Pi](#5-configuración-de-node-red-en-raspberry-pi)
    * [5.1. Instalación de Node-RED](#51-instalación-de-node-red)
    * [5.2. Configuraciones de seguridad de Node-RED](#52-configuraciones-de-seguridad-de-node-red)
    * [5.2. Configuraciones de control de versiones GIT de Node-RED](#52-configuraciones-de-control-de-versiones-git-de-node-red)
    * [5.3. Configuraciones de nombre del archivo de flows](#53-configuraciones-de-nombre-del-archivo-donde-se-guardarán-los-flows-de-node-red)
    * [5.4. Seleccionar tema y texto del editor](#54-seleccionar-tema-y-texto-del-editor-de-node-red)
    * [5.5. Habilitar nodos Function](#55-habilitar-nodos-function-node-red)
    * [5.6. Configurar inicio automático](#56-configurar-node-red-para-iniciar-automáticamente)
    * [5.7. Iniciar Node-RED](#57-iniciar-node-red)
    * [5.8. Instalar Nodes necesarios](#58-instalar-nodes-necesarios)
    * [5.8. Acceder al directorio de Node-RED](#58-acceder-al-directorio-de-node-red)
    * [5.9. Instalar node-red-dashboard](#59-instalar-node-red-dashboard)
    * [5.10. Instalar node-red-contrib-mqtt-broker](#510-instalar-node-red-contrib-mqtt-broker-si-no-está-incluido)
  * [6. Acceder a Node-RED](#6-acceder-a-node-red)
    * [6.1. Abrir navegador web en Raspberry Pi](#61-abrir-navegador-web-en-raspberry-pi)
    * [6.2. Abrir Node-RED desde cualquier dispositivo](#62-abrir-node-red-desde-cualquier-dispositivo-conectado-en-la-misma-red)
* [💡 Uso y Operación](#-uso-y-operación)
  * [1. Instalar las librerías necesarias](#1-instalar-las-librerías-necesarias)
    * [1.1 Habilita la interfaz I2C](#11-habilita-la-interfaz-i2c)
  * [2. Conecta tu sensor](#2-conecta-tu-sensor)
  * [3. Crear el script de python](#3-crear-el-script-de-python)
  * [2: Configurar el Flujo en Node-RED](#2-configurar-el-flujo-en-node-red)
    * [2.1 Accede a Node-RED](#21-accede-a-node-red)
    * [2.2 Instala los nodos del dashboard](#22-instala-los-nodos-del-dashboard-si-no-los-tienes)
    * [2.3 Construye el flujo (Flow)](#23-construye-el-flujo-flow)
      * [Nodo de Entrada (MQTT)](#-nodo-de-entrada-mqtt)
      * [Nodo de Función](#nodo-de-función-opcional-pero-recomendado)
      * [Nodos Gauge (Dashboard)](#nodos-gauge-dashboard)
      * [Conecta los nodos](#conecta-los-nodos)
      * [Despliega y visualiza](#despliega-y-visualiza)
* [📚 Documentación Adicional](#-documentación-adicional)
* [⚖️ Licencia](#-licencia)

---

# 👥 Equipo y Responsables

| Nombre | Rol en el Proyecto | GitHub |
| :--- | :--- | :--- |
| Addi Trejo | Desarrollador |[@Additrejo](https://github.com/Additrejo) | 

---

# 🛠️ Stack Tecnológico y Componentes

## Software en Raspberry Pi 5.
* **OS:** Raspberry Pi OS (64-bit Bullseye o posterior)
* **Broker:** [Mosquitto MQTT](https://mosquitto.org/)
* **Dockers:** [Docker y Docker Compose](https://docs.docker.com/compose/)
* **Programación:** [Node Red](https://nodered.org/), [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/), [Geany](https://www.geany.org/).

## Software en PC.
* **Interfaz Visual:** [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/), 
* **Navegador/Dashboard:** [Navegador de internet](https://www.google.com/intl/es_es/chrome/).   
* **Simulación:** [Cisco Packet Tracer](https://learningnetwork.cisco.com/s/question/0D53i00000Kt599CAB/download-packet-tracer).

## Hardware y Componentes Clave
* **Microcontrolador:** Raspberry pi 5, ESP32.
* **Sensores:**  SR04(Distancia), DTH11 (Temperatura), 

---

# 📁 Estructura del Repositorio

Una descripción de alto nivel de las carpetas más importantes para que cualquiera pueda encontrar lo que busca.

---

# ⚠️ Aviso de buenas prácticas. 

Estas son las instrucciones paso a paso sobre como usar un protocolo MQTT en una Raspberri Pi 5 y diferentes componentes, está pensando para que cualquier miembro del laboratorio pueda configurar el entorno para trabajar en este proyecto.

Para este ejemplo usaremos una **Raspberri pi 5**. Si es la primera vez usando la placa revisar la documentación de configuraciónes básicas en [Raspberry PI 5](https://github.com/LINX-ICN-UNAM/Raspberry_Pi_5) ya que son necesarias para el despliegue de este proyecto, así como revisar la documentación al final del repositorio ante cualquier duda.

⚠️ Si vas a hacer una prueba de conexión usando el protocolo MQTT de este repositorio y tienes mejoras de implementación, te invitamos a hacer un **Branch** un **Fork** o clonar este repositorio de forma local en tu PC y solicitar el  pull request, uno de los desarrolladores de este proyecto lo revisaremos para su consideración.  
Clona este repositorio: `git clone https://github.com/LINX-ICN-UNAM/MQTT_Test`

⚠️ Si aún no dominas GIT y GITHUB te invitamos a revisar el curso [Curso GIT Y GitHub](https://github.com/LINX-ICN-UNAM/Curso-GIT-Github) que hemos preparado.  

⚠️ No es necesario hacer todos los avisos para realizar el proyecto pero si ayudará a mejorar el desarrollo de proyectos en el laboratorio.

Todo esto con el fin de mantener el repositorio original funcional.

---

# Arquitectura del proyecto.

```text
┌─────────────────┐       MQTT        ┌─────────────────┐   HTTP/WebSocket    ┌─────────────────┐
│   ESP32 DevKit  │◀────────────────▶│  Raspberry Pi 5 │◀──────────────────▶│    Node-RED     │
│   (Cliente)     │                   │   (Broker MQTT) │                     │   (Dashboard)   │
│                 │                   │                 │                     │                 │
│ • Sensores      │                   │ • Mosquitto     │                     │ • Visualización │
│ • Actuadores    │                   │ • Docker        │                     │ • Control       │
└─────────────────┘                   └─────────────────┘                     └─────────────────┘
```

---

# 🚀 Instalación y Puesta en Marcha.


## **1. Configuración Raspberry pi 5.**

 Es necesario conectarse al escritorio de la raspberry Pi 5  de manera remota a traves de RealVNC Viewer en tu PC.  
    [Conexión RealVNC Viewever a PC](https://github.com/LINX-ICN-UNAM/Raspberry_Pi_5/blob/main/Seccion_1.md#%EF%B8%8F-conexi%C3%B3n-con-realvnc).

## **2. Configuración del Broker MQTT en Raspberry Pi**  
### Mosquitto.  
Mosquitto es un broker MQTT de código abierto y muy popular, desarrollado por la fundación Eclipse. Su nombre completo es Eclipse Mosquitto.

**Broker MQTT ligero y eficiente:**
Implementa los protocolos MQTT (versiones 3.1, 3.1.1 y 5.0) de forma optimizada para bajo consumo de recursos.
Ideal para sistemas embebidos, servidores de baja potencia o entornos con alta concurrencia de clientes.

**Multiplataforma:**
Funciona en Linux, Windows, macOS y sistemas embebidos como Raspberry Pi.

**Funcionalidades estándar y extendidas:**
Soporta QoS 0, 1 y 2.
Incluye autenticación (usuarios/contraseñas, TLS/SSL) y ACLs para control de acceso.
Bridge o puente entre brokers para interconectar redes MQTT.
Persistencia de mensajes (opcional).
WebSockets para conexiones desde navegadores web.

**Herramientas incluidas:**
Viene con clientes CLI (mosquitto_pub y mosquitto_sub) para pruebas y depuración.

### 2.1 Instalación de Mosquitto.  

### 2.2 Actualizar el sistema con el siguiente comando:

```Shell
sudo apt update
sudo apt upgrade -y
```
### 2.3 Instalar Mosquitto MQTT Broker.

```Shell
sudo apt install -y mosquitto mosquitto-clients
```

### 2.4 Habilitar e iniciar el servicio
```Shell
sudo systemctl enable mosquitto
```

### 2.6 Habilitar e iniciar el servicio
```Shell
sudo systemctl start mosquitto
```

## **3. Configuración de Mosquitto.**

### 3.1 Editar configuración de Mosquitto
```Shell
sudo nano /etc/mosquitto/mosquitto.conf
```

### 3.2 Agregar las siguientes líneas al archivo:

 * Permitir conexiones anónimas (para desarrollo)
```Shell
allow_anonymous true
```

 * Escuchar en todas las interfaces
```Shell
listener 1883 0.0.0.0
```

 * Persistencia de mensajes
```Shell
persistence true
persistence_location /var/lib/mosquitto/
```

 * Log
```Shell
log_dest file /var/log/mosquitto/mosquitto.log
```

Deben quedar de la siguiente forma:

<img width="793" height="513" alt="image" src="https://github.com/user-attachments/assets/3b01a97c-f5ee-424a-977b-2f34d22feb89" />

**Nota:**
**Ctrl + O (Guardar)**
**Enter (Confirmar nombre del archivo)**
**Ctrl + X (Salir)**



### 3.3 Reiniciar Mosquitto.
```Shell
sudo systemctl restart mosquitto
```

## **4. Probar el Broker.**

### 4.1  Suscribirse a un topic de prueba en una terminal:
```Shell
mosquitto_sub -h localhost -t "test"
```

### 4.2 En otra terminal, publicar un mensaje:
```Shell
mosquitto_pub -h localhost -t "test" -m "Hello MQTT"
```

Obtendremos el mensaje enviado por sub en el pub.

<img width="1189" height="442" alt="image" src="https://github.com/user-attachments/assets/0bb67c8a-74a3-42f9-b623-46e276196e8f" />

### **¡Con esto tenemos el Broker listo!**

## **5. Configuración de Node-RED en Raspberry Pi.**

### 5.1. Instalación de Node-RED.

Instalar Node-RED
```Shell
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
```

<img width="822" height="381" alt="image" src="https://github.com/user-attachments/assets/6e46f9a8-106d-4675-b663-2c74fe211c2d" />

Aceptamos los cambios.

Se tienen que instalar todas las dependencias sin errores:

<img width="679" height="412" alt="image" src="https://github.com/user-attachments/assets/2b13d9f6-7b83-4fbf-9272-6d549ec503fd" />  

Como podemos ver, nos ha asignado el **localhost:1880**

<img width="678" height="415" alt="image" src="https://github.com/user-attachments/assets/609362ed-9a38-43ef-9006-ed0a5cc1a22d" />  

También nos da una advertencia de seguridad la cual nos recomienta configurar.

### 5.2. Configuraciones de seguridad de Node-RED.
Ejecuta el siguiente comando.
```Shell
node-red admin init
```
<img width="342" height="118" alt="image" src="https://github.com/user-attachments/assets/f14195a0-f946-46ac-abf9-d6606713e977" />

### 5.2. Configuraciones de control de versiones GIT de Node-RED.

<img width="685" height="91" alt="image" src="https://github.com/user-attachments/assets/4833fc7b-9b1b-4749-987a-211b203f51a7" />

Por el momento no lo configuraremos. 

### 5.3. Configuraciones de nombre del archivo donde se guardarán los flows de Node-RED.

lo dejamos predefnido **flows.json**
Nos pedirá agregar una **passphrase** para encriptar las credenciales.
Por el momento lo dejaremos así, aun que si constituye en riesgo de seguridad.

<img width="428" height="75" alt="image" src="https://github.com/user-attachments/assets/133626b9-40cb-4a22-a659-7c6edb3c29f7" />  

### 5.4. Seleccionar tema y texto del editor de Node-RED.

Seleccionamos los dos por default que nos recomienda.

<img width="1167" height="103" alt="image" src="https://github.com/user-attachments/assets/29108180-cf56-4ad3-9251-aa8dd8b4deb7" />

### 5.5. Habilitar nodos Function Node-RED.

Permite módulos externos para flexibilidad. permiten escribir código JavaScript personalizado. Esta opción controla si ese código puede usar.
* Más poder y flexibilidad.
* Puedes acceder a archivos del sistema.
* Puedes hacer peticiones HTTP complejas.
* Puedes conectar a bases de datos.
* Necesario para muchas integraciones avanzada.

⚠️ Yes (PERMITIR) - RIESGOS:
* Código malicioso podría acceder al sistema
* Podría eliminar archivos si hay bugs
* Mayor superficie de ataque
* Usuario podría ejecutar código peligroso

 No (NO PERMITIR) - SEGURIDAD:
* Sandbox completo, más seguro
* Ataques limitados incluso si hay vulnerabilidad
* Ideal para entornos multi-usuario

⚠️ No (NO PERMITIR) - LIMITACIONES:
* No podrás usar módulos npm en Functions
* Menos flexibilidad para integraciones
* Muchos flows avanzados no funcionarán

Pregunta clave:
* ¿Vas a conectar Node-RED con:
Bases de datos? → Necesitas Yes
* APIs externas? → Necesitas Yes
* Archivos locales? → Necesitas Yes
* Solo flows simples sin código? → No está bien

<img width="600" height="100" alt="image" src="https://github.com/user-attachments/assets/9852e703-5361-48e9-8eaf-33a4f1602641" />

### 5.6.  Configurar Node-RED para iniciar automáticamente.
```Shell
sudo systemctl enable nodered.service
```

### 5.7. Iniciar Node-RED.
```Shell
sudo systemctl start nodered.service
```

## **6. Acceder a Node-RED.**

### 6.1. Abrir navegador web en Raspberry Pi y agregar la siguiente dirección:
```Shell
http://localhost:1880
```

Nos mostrará la ventana de iniciar sesión. 

<img width="1227" height="691" alt="image" src="https://github.com/user-attachments/assets/d3b00915-176e-4c44-b300-986290e95ab3" />


### 6.2. Abrir Node-RED desde cualquier dispositivo conectado en la misma red.
Abrir cualquier navegador y agregar la siguiente ruta.
⚠️ **Nota:* La IP de las Raspberry Pi puede cambiar al conectarse a una nueva red, verificarla primero.

```Shell
http://[IP_RASPBERRY_PI]:1880
```
**Ejemplo**  
<img width="1361" height="727" alt="image" src="https://github.com/user-attachments/assets/bf1d985b-cc74-4e2c-b157-4ebf257bef29" />

Agregar las credenciales establecidas.

<img width="1280" height="982" alt="image" src="https://github.com/user-attachments/assets/23c51990-d453-4e78-9a4e-4d27fb58aea1" />  
Al entrar veremos la siguiente pantalla que es el panel de despliegue de Node-Red listo para maquetar.

---

# 💡 Uso y Operación

Una vez en Node Red se hace una prueba con cualquier sensor, en este caso usaremos el acelerometro MPU6050.

## 1. Instalar las librerías necesarias.

1.  Ejecutar en la terminal de la raspberry pi el siguiente comando:
    ```bash
    sudo apt update
    ```
    ```bash
    sudo apt install python3-paho-mqtt
    ```
donde:
**paho-mqtt:** Para la comunicación MQTT.
    
   Comprobar si se instaló correctamente con el siguiente comando:
   
 ```bash
    pip3 list | grep paho
 ```

<img width="424" height="48" alt="image" src="https://github.com/user-attachments/assets/110d3160-e631-468c-ba87-c39789e0c04f" />



### 1.1 Habilita la interfaz I2C:
 ```bash
sudo raspi-config
  ```

Navega a Interface Options -> I2C -> Yes para habilitarlo. Luego, reinicia.

<img width="573" height="411" alt="image" src="https://github.com/user-attachments/assets/85be8ccc-0001-496b-892e-579c00d8529d" />

### 2. Conecta tu sensor.
En este caso estaremos usando un sensor MPU6050.

*Pinout*
VCC (sensor) a un pin 3.3V de la Pi.  
GND (sensor) a un pin GND de la Pi.  
SCL (sensor) al pin GPIO 3 (SCL) de la Pi.  
SDA (sensor) al pin GPIO 2 (SDA) de la Pi.  

<img width="958" height="675" alt="image" src="https://github.com/user-attachments/assets/17334a57-ab50-4cd1-9870-f780a127993f" />

### 3. Crear el script de python.
Crea un nuevo archivo, por ejemplo, acelerometro_mqtt.py, y pega el siguiente código. Este ejemplo está escrito para un sensor MPU6050 genérico, pero deberás adaptar la parte de la lectura si tu sensor es de otro modelo.
 ```python
import paho.mqtt.client as mqtt
import smbus2
import time
import json
import math

# --- Configuración del Sensor (MPU6050) ---
MPU6050_ADDR = 0x68  # Dirección I2C del MPU6050
POWER_MGMT_1 = 0x6B
ACCEL_XOUT_H = 0x3B

bus = smbus2.SMBus(1)  # Usa el bus I2C-1 de la Raspberry Pi
# Despertar el MPU6050 (escribe 0 en el registro de gestión de energía)
bus.write_byte_data(MPU6050_ADDR, POWER_MGMT_1, 0)

# --- Configuración MQTT ---
MQTT_BROKER = "localhost"  # Dirección de tu broker MQTT (Mosquitto en la misma Pi)
MQTT_PORT = 1883
MQTT_TOPIC = "sensor/acelerometro"  # Topic donde se publicarán los datos
INTERVALO_SEGUNDOS = 1  # Frecuencia de lectura y envío

# Función para leer datos "crudos" del sensor
def read_raw_data(addr):
    # Leer dos bytes (high y low) y combinarlos
    high = bus.read_byte_data(MPU6050_ADDR, addr)
    low = bus.read_byte_data(MPU6050_ADDR, addr+1)
    value = (high << 8) | low
    # Convertir a valor con signo (complemento a dos)
    if value > 32768:
        value = value - 65536
    return value

# Configuración del cliente MQTT
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
        # Leer acelerómetro (ejes X, Y, Z)
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
            print(f"Error al enviar el mensaje, código: {status}")

        time.sleep(INTERVALO_SEGUNDOS)

except KeyboardInterrupt:
    print("Detenido por el usuario.")
finally:
    bus.close()
    client.disconnect()
    print("Conexión cerrada.")
  ```
Nota importante: Este script es un punto de partida. Dependiendo de tu sensor específico, la dirección I2C, los registros a leer y la fórmula de conversión pueden variar.

Al ejecutar el script podemos ver en el script los valores obtenidos del sensor:

<img width="429" height="106" alt="image" src="https://github.com/user-attachments/assets/2deb2f6f-e622-497e-b1b5-b4292fd3d7ef" />


## 2: Configurar el Flujo en Node-RED.

Ahora configuraremos Node-RED para que se suscriba al topic MQTT y muestre los valores en un gauge.

### 2.1 Accede a Node-RED: Abre un navegador web y ve a http://<IP-de-tu-raspberry>:1880. El <IP-de-tu-raspberry> es la dirección IP de tu Pi 5.

 Se tiene que ver el siguiente panel:   
 <img width="1280" height="583" alt="image" src="https://github.com/user-attachments/assets/09c08e7f-d3b0-4d61-a072-d7d7a5ed916c" />


### 2.2 Instala los nodos del dashboard - FlowFuse Dashboard (si no los tienes).
* En Node-RED, ve al menú (esquina superior derecha) → "Manage palette"
* Ve a la pestaña "Install"
* Busca @flowfuse/node-red-dashboard
* Haz clic en "Install"

![NR-FlowFuse Dashboard](https://github.com/user-attachments/assets/fa66d930-9561-4ef8-baf4-e34d02d7ee3d)



### 2.3 Construye el flujo (Flow).

#### - **Nodo de Entrada (MQTT):**   
* Arrastra un nodo **mqtt in** desde la categoría "network" al área de trabajo.  
* Haz doble click sobre el nodo y verás las propiedades.
  * Propiedades:
   * Server: Asegúrate de que apunte a tu broker MQTT. Si es el mismo equipo, debe decir localhost:1883. 
    * Si no ves el servidor, haz doble clic en el nodo y añade uno nuevo con localhost y 1883.  

![NR-Mqqt configuracion de puerto](https://github.com/user-attachments/assets/f766add6-0d7e-4f1a-817c-02e388efd090)

Las propiedades del nodo deben quedar de la siguiente forma:
* Action: Subscribe to single topic.
* Topic: sensor/acelerometro (el mismo que usaste en el script Python).
* Output: "a parsed JSON object" (para que interprete automáticamente el JSON que enviamos).  
* Haz clic en "Done".

![NR-configuracion de puerto mqqt general](https://github.com/user-attachments/assets/c84d03a8-9fc7-49a1-9dbb-c7260c06f764)


### - **Nodo de Función (Opcional pero recomendado):**  
Para separar los ejes. Arrastra un nodo function desde la categoría "function". Este nodo tomará el objeto JSON completo y lo dividirá en tres mensajes separados, uno para cada eje.

* Arrastra el nodo de función al panel.
* Doble click sobre el para editarlo.
* En la pestaña **configuración** agregar 3 salidas (cada una es para un eje x,y,z).
* En la pestaña en mensaje ("On Message") agregar el siguiente código:
 ```JSON
// Asumiendo que msg.payload tiene {x: valor, y: valor, z: valor}
var ejeX = { payload: msg.payload.x, topic: "ejeX" };
var ejeY = { payload: msg.payload.y, topic: "ejeY" };
var ejeZ = { payload: msg.payload.z, topic: "ejeZ" };
// Envía los tres mensajes en orden
return [ejeX, ejeY, ejeZ];
  ```

*Da click en Done ("Hecho")

![4  configuracion function](https://github.com/user-attachments/assets/7c5657cd-6ee7-4dcf-8387-7e2ec8a735a8)


### - ** Configurar los 3 nodos ui-gauge (Dashboard 2):** 

Arrastra tres nodos gauge desde la categoría "dashboard" al área de trabajo.  

![5  Nodos gauge](https://github.com/user-attachments/assets/9cfbe236-6544-43f2-8168-e4199d088eaa)

  Paso 1: Configurar el primer gauge (Eje X)

# PENDIENTE
---

# CONEXIÓN ESP32  -> Raspberry Pi 5.

 1. **Programar el ESP32 (El Recolector de Datos).**
     prepararemos  la ESP32 DevKit para que lea el MPU6050 y envíe los datos a la Raspberry Pi.

    El MPU6050 se comunica mediante el protocolo I2C. Las conexiones son:
    | Pin MPU6050 | Pin ESP32 DevKit V1 |
    |-------------|----------------------|
    | VCC         | 3.3V                 |
    | GND         | GND                  |
    | SCL         | GPIO 22              |
    | SDA         | GPIO 21              |

2. **Librerias en Arduino IDE.**

* **Adafruit MPU6050**   de Adafruit (esta incluirá automáticamente Adafruit Unified Sensor y Adafruit BusIO como dependencias).  
* **PubSubClient**       de Nick O'Leary. Esta es la librería que usaremos para la comunicación MQTT.

3. **Código para el ESP32**  
   Abre un nuevo sketch y pega el siguiente código.  
   Recuerda cambiar las variables de WIFI_SSID, WIFI_PASSWORD y la IP de tu Raspberry Pi por las tuyas.

Este código hace lo siguiente:  
* Conecta el ESP32 a tu red Wi-Fi.
* Inicializa el sensor MPU6050.
* Se conecta al broker MQTT en tu Raspberry Pi.
* En un bucle continuo, lee la aceleración y la temperatura (el MPU6050 también tiene sensor de temperatura) del sensor 
* Publica estos datos en dos temas MQTT distintos cada 2 segundos.

 ```C++
#include <WiFi.h>
#include <PubSubClient.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

// === CONFIGURACIÓN WI-FI ===
const char* ssid = "TU_SSID";
const char* password = "TU_CONTRASENA";

// === CONFIGURACIÓN MQTT (RASPBERRY PI) ===
const char* mqtt_server = "192.168.1.X"; // <<<--- ¡LA IP DE TU RASPBERRY PI!
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
  ```   

 4. Visualizar en Node-RED (Dashboard)  
    Con la Raspberry Pi lista y el ESP32 enviando datos, el último paso es crear el "cuadro de mandos" en Node-RED.  

    **Crear el Flujo**  
    En tu navegador, ve a http://<IP-de-tu-RPi>:1880. Vamos a construir el flujo arrastrando nodos desde la izquierda y conectándolos.

    Necesitaremos:

    * 2 nodos mqtt in (de la sección "network").
    * 2 nodos json (de la sección "parser").
    * 2 nodos chart (de la sección "dashboard").
    * 1 nodo gauge (de la sección "dashboard").  
    Varios nodos function (opcional, para procesar datos).

    **Nodo MQTT para Aceleración:**  
    <img width="1046" height="598" alt="image" src="https://github.com/user-attachments/assets/86ddb928-4cc8-4c15-8f27-1ea5092a2cce" />  
    - Arrastra un nodo mqtt in al canvas.
    - Haz doble clic en él. En "Server", añade una nueva conexión a tu Raspberry Pi (localhost:1883).
    - En "Topic", escribe: casa/esp32/mpu6050/accel.
    - En "Output", selecciona "a parsed JSON object". Así Node-RED convertirá automáticamente el JSON {"x":..., "y":..., "z":...} que envía el ESP32 en un objeto que podemos usar.
    - Ponle nombre "Aceleración RAW".  
    <img width="1049" height="643" alt="image" src="https://github.com/user-attachments/assets/49c4869f-4b78-448f-8e86-f155ed2a4b8d" />

   
    **Separar Ejes X, Y, Z (Opcional pero recomendado):**  
    - La salida del nodo MQTT ya es un objeto con msg.payload.x, msg.payload.y, msg.payload.z. Para graficarlos por separado, podemos usar nodos function.  
    - Arrastra tres nodos function. Conéctalos en paralelo a la salida del nodo MQTT.  

    <img width="1052" height="639" alt="image" src="https://github.com/user-attachments/assets/3e3579c2-21ad-4c9e-bbb5-d5cbe8fbf637" />  

    - En el primer function, escribe el siguiente código para quedarnos solo con el eje X y asignarlo a msg.payload:

     ```Javascript
      // Código para el Eje X
      msg.payload = msg.payload.x;
      msg.topic = "Eje X";
      return msg;
     ```
     <img width="1052" height="643" alt="image" src="https://github.com/user-attachments/assets/b706753f-bb93-4344-a1de-3ec7ab641783" />  

     Haz lo mismo para los otros dos nodos, cambiando msg.payload.x por msg.payload.y y msg.payload.z, y el msg.topic en consecuencia.
     
    <img width="642" height="233" alt="image" src="https://github.com/user-attachments/assets/a8bc9e39-d690-4809-bcff-0b586d466af1" />
    <img width="643" height="237" alt="image" src="https://github.com/user-attachments/assets/761d3665-35ba-418a-bb09-e53d7a931f44" />  


     **Nodos Chart (Gráficos):**  

     - Arrastra tres nodos chart (de la sección dashboard). Conecta cada uno a la salida de cada nodo function que creamos.
       
       <img width="1052" height="637" alt="image" src="https://github.com/user-attachments/assets/2df1f7f4-d099-4a6d-a600-5416eac6c324" />  

     - Haz doble clic en el primero (Eje X). En la pestaña "Appearance", asígnale un Grupo. Si es la primera vez, tendrás que crear uno nuevo: ve a la pestaña "Dashboard" (en la barra           lateral derecha) y crea una nueva pestaña (Tab) y un nuevo grupo (Group). Luego vuelve al nodo y selecciona ese grupo.
       
     - En la pestaña "Appearance", ponle etiqueta como "Aceleración Eje X". Puedes ajustar el rango del eje Y (por ejemplo, de -15 a 15) y el número de puntos a mostrar.
   
       <img width="1050" height="642" alt="image" src="https://github.com/user-attachments/assets/d0c98e45-e810-4bed-a42c-34ad65f64409" />


   6. **Desplegar (Deploy):**  
       Haz clic en el botón rojo "Deploy" en la esquina superior derecha.  
      <img width="1366" height="652" alt="image" src="https://github.com/user-attachments/assets/27b4cad2-0f0a-43fe-9b17-08baa7a51c83" />


   8. **Ver los Datos en Vivo**
      Ahora, abre una nueva pestaña en tu navegador y ve a http://<IP-de-tu-RPi>:1880/. ¡Deberías ver tu dashboard con los gráficos de aceleración actualizándose en tiempo real
    

## 📚 Documentación Adicional

Enlaces a documentación más detallada, que no encaja en el README.

* [Repositorio Configuración Raspberry Pi 5](https://github.com/LINX-ICN-UNAM/Raspberry_Pi_5)
* [Documentación Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5/)

---

## ⚖️ Licencia

Este proyecto está bajo la licencia *Space Instrumentation Laboratory, LINX. Institute of Nuclear Sciences ICN, UNAM. All rights reserved.*.

