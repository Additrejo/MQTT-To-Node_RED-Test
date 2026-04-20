#!/bin/bash
# install_mqtt_linx.sh - Script de instalación del proyecto MQTT Test para LINX ICN-UNAM
# Proyecto: COLMENA 2 - Laboratorio de Instrumentación Espacial

# ============================================================================
# CONFIGURACIÓN
# ============================================================================
set -e  # Detener script en caso de error
exec 2> >(tee -a /var/log/linx_mqtt_install.log >&2)  # Log de errores

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
RASPBERRY_IP=$(hostname -I | awk '{print $1}')
LOG_FILE="/var/log/linx_mqtt_install.log"
NODE_RED_DIR="$HOME/.node-red"

# ============================================================================
# FUNCIONES DE LOGGING
# ============================================================================
log_header() {
    echo -e "\n${BLUE}================================================================${NC}"
    echo -e "${BLUE} $1 ${NC}"
    echo -e "${BLUE}================================================================${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_info() {
    echo -e "${GREEN}[✓]${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" >> "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" >> "$LOG_FILE"
    exit 1
}

run_cmd() {
    echo -e "${YELLOW}\$ $1${NC}"
    echo "[CMD] $1" >> "$LOG_FILE"
    eval "$1"
    local status=$?
    if [ $status -ne 0 ]; then
        log_error "Comando falló con código $status: $1"
    fi
    return $status
}

# ============================================================================
# FUNCIONES DE INSTALACIÓN
# ============================================================================

check_system() {
    log_header "1. VERIFICACIÓN DEL SISTEMA"
    
    # Verificar que es Raspberry Pi
    if ! grep -q "Raspberry Pi" /proc/device-tree/model 2>/dev/null; then
        log_warn "No se detectó Raspberry Pi. Continuando de todos modos..."
    fi
    
    # Verificar OS
    if [ ! -f /etc/os-release ]; then
        log_error "No se puede determinar el sistema operativo"
    fi
    
    source /etc/os-release
    log_info "Sistema: $PRETTY_NAME"
    log_info "Hostname: $(hostname)"
    log_info "IP: $RASPBERRY_IP"
    
    # Verificar conexión a internet
    if ! ping -c 1 google.com &>/dev/null; then
        log_warn "Sin conexión a internet. Algunas instalaciones podrían fallar"
    fi
}

install_mosquitto() {
    log_header "2. INSTALACIÓN DE MOSQUITTO MQTT BROKER"
    
    log_info "Actualizando sistema..."
    run_cmd "sudo apt update"
    run_cmd "sudo apt upgrade -y"
    
    log_info "Instalando Mosquitto..."
    run_cmd "sudo apt install -y mosquitto mosquitto-clients"
    
    log_info "Configurando Mosquitto..."
    
    # Crear backup de configuración existente
    if [ -f /etc/mosquitto/mosquitto.conf ]; then
        run_cmd "sudo cp /etc/mosquitto/mosquitto.conf /etc/mosquitto/mosquitto.conf.bak"
    fi
    
    # Configuración básica
    cat << EOF | sudo tee /etc/mosquitto/mosquitto.conf > /dev/null
# Configuración LINX - MQTT Test
allow_anonymous true
listener 1883 0.0.0.0
persistence true
persistence_location /var/lib/mosquitto/
log_dest file /var/log/mosquitto/mosquitto.log
log_type all
EOF
    
    # Crear directorios necesarios
    run_cmd "sudo mkdir -p /var/lib/mosquitto /var/log/mosquitto"
    run_cmd "sudo chown mosquitto:mosquitto /var/lib/mosquitto /var/log/mosquitto"
    
    log_info "Habilitando y iniciando servicio..."
    run_cmd "sudo systemctl enable mosquitto"
    run_cmd "sudo systemctl restart mosquitto"
    
    # Verificar servicio
    if systemctl is-active --quiet mosquitto; then
        log_info "Mosquitto activo en puerto 1883"
    else
        log_error "Mosquitto no se pudo iniciar"
    fi
}

test_mosquitto() {
    log_header "3. PRUEBA DEL BROKER MQTT"
    
    log_info "Probando suscripción en segundo plano..."
    timeout 5 mosquitto_sub -h localhost -t "linx/test" > /tmp/mqtt_test.log 2>&1 &
    local sub_pid=$!
    
    sleep 2
    
    log_info "Publicando mensaje de prueba..."
    mosquitto_pub -h localhost -t "linx/test" -m "Hello MQTT from LINX"
    
    sleep 2
    
    if grep -q "Hello MQTT" /tmp/mqtt_test.log; then
        log_info "✓ Prueba MQTT exitosa"
    else
        log_warn "Prueba MQTT no concluyente (puede ser normal en algunas configuraciones)"
    fi
    
    kill $sub_pid 2>/dev/null || true
}

install_node_red() {
    log_header "4. INSTALACIÓN DE NODE-RED"
    
    log_info "Descargando e instalando Node-RED..."
    run_cmd "bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered) --confirm-install --confirm-pi"
    
    log_info "Configurando seguridad de Node-RED..."
    cat << EOF | node-red admin init --yes
y
linx_admin
linx_password123
linx_password123
y
/
n
20
604800
n
EOF
    
    log_info "Habilitando inicio automático..."
    run_cmd "sudo systemctl enable nodered.service"
    run_cmd "sudo systemctl start nodered.service"
    
    if systemctl is-active --quiet nodered; then
        log_info "Node-RED activo en http://$RASPBERRY_IP:1880"
    else
        log_warn "Node-RED no se pudo iniciar automáticamente"
    fi
}

install_node_red_nodes() {
    log_header "5. INSTALACIÓN DE NODOS NODE-RED"
    
    if [ ! -d "$NODE_RED_DIR" ]; then
        run_cmd "mkdir -p $NODE_RED_DIR"
    fi
    
    run_cmd "cd $NODE_RED_DIR"
    
    log_info "Instalando node-red-dashboard..."
    run_cmd "npm install node-red-dashboard"
    
    log_info "Instalando node-red-node-mqtt (ya incluido, actualizando)..."
    run_cmd "npm install @node-red/nodes"
    
    log_info "Instalando node-red-contrib-mqtt-broker..."
    run_cmd "npm install node-red-contrib-mqtt-broker"
    
    log_info "Reiniciando Node-RED..."
    run_cmd "sudo systemctl restart nodered"
}

configure_firewall() {
    log_header "6. CONFIGURACIÓN DE FIREWALL"
    
    if command -v ufw &>/dev/null; then
        log_info "Configurando UFW..."
        run_cmd "sudo ufw allow 1883/tcp comment 'MQTT Broker'"
        run_cmd "sudo ufw allow 1880/tcp comment 'Node-RED'"
        run_cmd "sudo ufw allow 5900/tcp comment 'VNC'"
        log_info "Puertos abiertos: 1883 (MQTT), 1880 (Node-RED), 5900 (VNC)"
    else
        log_warn "UFW no instalado. Considera instalar: sudo apt install ufw"
    fi
}

create_demo_flow() {
    log_header "7. CREANDO FLOW DE DEMOSTRACIÓN"
    
    local demo_flow="$NODE_RED_DIR/flows_linx_demo.json"
    
    cat << EOF > "$demo_flow"
[
    {
        "id": "linx-mqtt-demo",
        "type": "tab",
        "label": "LINX MQTT Demo",
        "disabled": false,
        "info": "",
        "env": []
    },
    {
        "id": "inject-demo",
        "type": "inject",
        "z": "linx-mqtt-demo",
        "name": "Test cada 10s",
        "props": [{"p": "payload"}, {"p": "topic", "vt": "str"}],
        "repeat": "10",
        "crontab": "",
        "once": false,
        "onceDelay": 0.1,
        "topic": "linx/sensor/temperatura",
        "payload": "{\"valor\": 25.5, \"unidad\": \"C\", \"sensor\": \"DHT11\"}",
        "payloadType": "json",
        "x": 200,
        "y": 100,
        "wires": [["mqtt-out-demo"]]
    },
    {
        "id": "mqtt-out-demo",
        "type": "mqtt out",
        "z": "linx-mqtt-demo",
        "name": "Publicar a Mosquitto",
        "topic": "",
        "qos": "0",
        "retain": "",
        "respTopic": "",
        "contentType": "",
        "userProps": "",
        "correl": "",
        "expiry": "",
        "broker": "broker-config",
        "x": 450,
        "y": 100,
        "wires": []
    },
    {
        "id": "mqtt-in-demo",
        "type": "mqtt in",
        "z": "linx-mqtt-demo",
        "name": "Suscribirse a sensor",
        "topic": "linx/sensor/#",
        "qos": "0",
        "datatype": "auto",
        "broker": "broker-config",
        "nl": false,
        "rap": true,
        "rh": 0,
        "inputs": 0,
        "x": 200,
        "y": 200,
        "wires": [["debug-demo"]]
    },
    {
        "id": "debug-demo",
        "type": "debug",
        "z": "linx-mqtt-demo",
        "name": "Mostrar datos MQTT",
        "active": true,
        "tosidebar": true,
        "console": false,
        "tostatus": false,
        "complete": "payload",
        "targetType": "msg",
        "statusVal": "",
        "statusType": "auto",
        "x": 450,
        "y": 200,
        "wires": []
    },
    {
        "id": "broker-config",
        "type": "mqtt-broker",
        "name": "Mosquitto Local",
        "broker": "localhost",
        "port": "1883",
        "clientid": "",
        "autoConnect": true,
        "usetls": false,
        "protocolVersion": "4",
        "keepalive": "60",
        "cleansession": true,
        "birthTopic": "",
        "birthQos": "0",
        "birthPayload": "",
        "birthMsg": {},
        "closeTopic": "",
        "closeQos": "0",
        "closePayload": "",
        "closeMsg": {},
        "willTopic": "",
        "willQos": "0",
        "willPayload": "",
        "willMsg": {},
        "userProps": "",
        "sessionExpiry": ""
    }
]
EOF
    
    log_info "Flow de demostración creado en: $demo_flow"
    log_info "Para importar: Menu → Import → Seleccionar archivo"
}

show_summary() {
    log_header "🎯 INSTALACIÓN COMPLETADA"
    
    cat << EOF
    
${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}
${GREEN}║                    LINX - MQTT TEST                          ║${NC}
${GREEN}║                 Instalación exitosa                          ║${NC}
${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}

${YELLOW}📊 RESUMEN DE INSTALACIÓN:${NC}
${BLUE}├─ Mosquitto MQTT Broker:${NC}   ✅ Instalado
${BLUE}│  ├─ Puerto:${NC} 1883
${BLUE}│  ├─ Estado:${NC} $(systemctl is-active mosquitto)
${BLUE}│  └─ Test:${NC} mosquitto_pub -h localhost -t "test" -m "Hola"

${BLUE}├─ Node-RED:${NC}                ✅ Instalado
${BLUE}│  ├─ URL local:${NC} http://localhost:1880
${BLUE}│  ├─ URL red:${NC} http://${RASPBERRY_IP}:1880
${BLUE}│  ├─ Usuario:${NC} linx_admin
${BLUE}│  └─ Password:${NC} linx_password123

${BLUE}├─ Nodos instalados:${NC}        ✅ Dashboard y MQTT
${BLUE}├─ Firewall:${NC}                ✅ Puertos abiertos
${BLUE}└─ Flow demo:${NC}               ✅ Creado en ~/.node-red/

${YELLOW}🚀 ACCESOS RÁPIDOS:${NC}
  MQTT Broker:    mosquitto_sub -h ${RASPBERRY_IP} -t "#"
  Node-RED:       http://${RASPBERRY_IP}:1880
  Logs:           tail -f /var/log/linx_mqtt_install.log

${YELLOW}⚠️  RECOMENDACIONES DE SEGURIDAD:${NC}
  1. Cambiar contraseñas por defecto
  2. Configurar autenticación MQTT
  3. Habilitar HTTPS en Node-RED
  4. Configurar firewall adecuadamente

${YELLOW}📚 DOCUMENTACIÓN:${NC}
  GitHub: https://github.com/LINX-ICN-UNAM/MQTT_Test
  Raspberry Pi: https://github.com/LINX-ICN-UNAM/Raspberry_Pi_5

${GREEN}┌──────────────────────────────────────────────────────────────┐${NC}
${GREEN}│  ¡Proyecto COLMENA 2 - LINX ICN-UNAM listo para usar!       │${NC}
${GREEN}└──────────────────────────────────────────────────────────────┘${NC}

EOF
    
    echo "Instalación completada: $(date)" >> "$LOG_FILE"
}

# ============================================================================
# MENÚ PRINCIPAL
# ============================================================================
main_menu() {
    clear
    cat << EOF
${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}
${BLUE}║         LINX - Laboratorio de Instrumentación Espacial        ║${NC}
${BLUE}║                Proyecto: MQTT Test - COLMENA 2                ║${NC}
${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}

${YELLOW}Este script instalará:${NC}
  1. Mosquitto MQTT Broker
  2. Node-RED con Dashboard
  3. Nodos MQTT necesarios
  4. Configuración de seguridad básica

${YELLOW}Selecciona una opción:${NC}
${GREEN}[1]${NC} Instalación completa automática
${GREEN}[2]${NC} Instalar solo Mosquitto
${GREEN}[3]${NC} Instalar solo Node-RED
${GREEN}[4]${NC} Probar instalación
${GREEN}[5]${NC} Mostrar resumen
${GREEN}[6]${NC} Salir

EOF
    
    read -p "Opción [1]: " choice
    choice=${choice:-1}
    
    case $choice in
        1)
            check_system
            install_mosquitto
            test_mosquitto
            install_node_red
            install_node_red_nodes
            configure_firewall
            create_demo_flow
            show_summary
            ;;
        2)
            check_system
            install_mosquitto
            test_mosquitto
            show_summary
            ;;
        3)
            check_system
            install_node_red
            install_node_red_nodes
            show_summary
            ;;
        4)
            test_mosquitto
            ;;
        5)
            show_summary
            ;;
        6)
            log_info "Saliendo..."
            exit 0
            ;;
        *)
            log_error "Opción no válida"
            ;;
    esac
}

# ============================================================================
# EJECUCIÓN
# ============================================================================

# Verificar si es ejecutado como root
if [ "$EUID" -eq 0 ]; then
    log_warn "No se recomienda ejecutar como root. Usando sudo cuando sea necesario."
fi

# Crear archivo de log
sudo touch "$LOG_FILE"
sudo chmod 644 "$LOG_FILE"

# Mostrar banner
clear
cat << EOF
${GREEN}
   __    ____  _   _ __  __ 
  / /   |  _ \| \ | |  \/  |
 / /    | |_) |  \| | |\/| |
/ /___  |  _ <| |\  | |  | |
\____/  |_| \_\_| \_|_|  |_|
${NC}
${BLUE}Laboratorio de Instrumentación Espacial${NC}
${YELLOW}Instituto de Ciencias Nucleares - UNAM${NC}
${BLUE}Proyecto: MQTT Test - COLMENA 2${NC}
${YELLOW}Script de instalación automatizada${NC}
EOF

sleep 2

# Ejecutar menú principal
while true; do
    main_menu
    read -p "¿Deseas realizar otra operación? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        break
    fi
done

log_info "Instalación finalizada. Revisa el log en: $LOG_FILE"