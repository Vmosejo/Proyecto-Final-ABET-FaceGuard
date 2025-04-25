# Proyecto-Final-ABET---Caja-Fuerte-
FaceGuard - Access Control System with Face Recognition
# Sistema de Seguridad con Reconocimiento Facial

## 🔧 Requisitos
- **Hardware**:
  - Arduino Uno
  - ESP32-CAM
  - Sensor ultrasónico HC-SR04
  - Cerradura solenoide 12V
  - LEDs (rojo y verde)
- **Software**:
  - MATLAB R2020b+ (con Toolboxes de Visión Artificial)
  - Arduino IDE

## 🚀 Instalación
1. **Cargar firmware en Arduino**:
   - Abre `security_system.ino` en Arduino IDE.
   - Selecciona la placa "Arduino Uno" y puerto COM correcto.
   - Sube el código.

2. **Configurar ESP32-CAM**:
   - Usa el firmware AI-Thinker para streaming HTTP.
   - Configura WiFi en `config.h`:
     ```cpp
     const char* ssid = "TU_RED";
     const char* password = "TU_CONTRASEÑA";
     ```

3. **Ejecutar en MATLAB**:
   - Abre `facial_recognition_system.m`.
   - Ajusta `esp32_ip` según la IP asignada al ESP32.
   - Ejecuta el script (requiere conexión serial a Arduino).

## 📌 Notas
- La cerradura solenoide requiere fuente externa de 12V.
- Para mejor precisión, captura la imagen de referencia con buena iluminación.
