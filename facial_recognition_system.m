%% Sistema de Seguridad con Reconocimiento Facial para Caja Fuerte
% Descripción: Controla una caja fuerte con Arduino, ESP32-CAM y sensor ultrasónico.

%% 1. Configuración Inicial
clear; close all; clc;

% Conexión con Arduino
try
    arduinoObj = arduino('COM3', 'Uno', 'Libraries', {'Ultrasonic'});
    ultrasonicObj = ultrasonic(arduinoObj, 'D9', 'D10');
    disp('Arduino conectado correctamente.');
catch
    error('Error al conectar Arduino. Verifica el puerto COM.');
end

% Configuración de pines
solenoidPin = 'D7'; % Control del solenoide
ledVerde = 'D5';    % LED acceso concedido
ledRojo = 'D6';     % LED acceso denegado

% Configuración de la cámara ESP32-CAM
esp32_ip = '192.168.1.100'; % Cambiar según tu red
cam_url = strcat('http://', esp32_ip, '/capture');

%% 2. Detector de Rostros (Haar Cascade)
faceDetector = vision.CascadeObjectDetector(); % Modelo pre-entrenado

%% 3. Capturar Rostro de Referencia
disp('Capturando rostro de referencia...');
pause(2); % Espera para posicionamiento
refImage = imread(cam_url); % Captura imagen
refFace = faceDetector.step(im2gray(refImage)); % Detección

if isempty(refFace)
    error('No se detectó rostro en la imagen de referencia.');
end

%% 4. Bucle Principal de Reconocimiento
disp('Sistema activo. Monitoreando...');
while true
    % Lectura del sensor ultrasónico
    distancia = readDistance(ultrasonicObj);
    fprintf('Distancia: %.2f m\n', distancia);
    
    if distancia < 0.5 % Umbral = 50 cm
        % Captura y procesamiento de imagen
        currentImage = imread(cam_url);
        currentFaces = faceDetector.step(im2gray(currentImage));
        
        if ~isempty(currentFaces)
            % Comparación de rostros (similitud de píxeles)
            match = compareFaces(refImage, refFace, currentImage, currentFaces);
            
            if match
                % Acceso concedido
                disp('¡Rostro reconocido! Acceso concedido.');
                writeDigitalPin(arduinoObj, ledVerde, 1);
                writeDigitalPin(arduinoObj, solenoidPin, 1);
                pause(5); % Tiempo de apertura
                writeDigitalPin(arduinoObj, solenoidPin, 0);
                writeDigitalPin(arduinoObj, ledVerde, 0);
            else
                % Acceso denegado
                disp('Rostro no reconocido. Acceso denegado.');
                writeDigitalPin(arduinoObj, ledRojo, 1);
                pause(3);
                writeDigitalPin(arduinoObj, ledRojo, 0);
            end
        end
    end
    pause(0.5); % Evita saturación
end

%% Función de Comparación de Rostros
function match = compareFaces(refImg, refFace, currImg, currFace)
    % Extrae región de interés (ROI) del rostro
    refGray = im2gray(imcrop(refImg, refFace(1,:)));
    currGray = im2gray(imcrop(currImg, currFace(1,:)));
    
    % Redimensiona y normaliza
    refGray = imresize(refGray, [100 100]);
    currGray = imresize(currGray, [100 100]);
    
    % Calcula diferencia absoluta
    diff = sum(abs(double(refGray(:)) - double(currGray(:))));
    match = diff < 50000; % Umbral empírico (ajustable)
end