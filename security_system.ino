// Sistema de Seguridad para Caja Fuerte
// Descripción: Controla LEDs y solenoide basado en señales seriales desde MATLAB.

#define SOLENOIDE_PIN 7
#define LED_VERDE 5
#define LED_ROJO 6

void setup() {
  Serial.begin(9600);
  pinMode(SOLENOIDE_PIN, OUTPUT);
  pinMode(LED_VERDE, OUTPUT);
  pinMode(LED_ROJO, OUTPUT);
}

void loop() {
  if (Serial.available() > 0) {
    char command = Serial.read();
    
    switch (command) {
      case 'A': // Abrir cerradura
        digitalWrite(LED_VERDE, HIGH);
        digitalWrite(SOLENOIDE_PIN, HIGH);
        delay(5000); // 5 segundos abierto
        digitalWrite(SOLENOIDE_PIN, LOW);
        digitalWrite(LED_VERDE, LOW);
        break;
        
      case 'D': // Acceso denegado
        digitalWrite(LED_ROJO, HIGH);
        delay(3000);
        digitalWrite(LED_ROJO, LOW);
        break;
    }
  }
}