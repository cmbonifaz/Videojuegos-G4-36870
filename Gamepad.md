# Taller PRACT-EXP: Investigación de Dispositivo de Entrada (Gamepad)

Este repositorio contiene la investigación correspondiente al taller práctico de dispositivos de entrada para el desarrollo de videojuegos.

---

## 📋 Ficha de Dispositivo

* **NOMBRE:** Gamepad (Mando / Control de Videojuegos)
* **AÑO Y FABRICANTE:** 1983, lanzado globalmente por la compañía japonesa **Nintendo** (con el diseño clásico del NES Controller).
* **TECNOLOGÍA DE CAPTURA:** Emplea microinterruptores metálicos para botones digitales y potenciómetros/sensores magnéticos para las palancas analógicas, traduciendo la presión física y el movimiento en señales eléctricas comprensibles por el sistema.
* **TIPO DE SEÑAL:** **Digital** (en la cruceta y botones de acción) y **Analógica** (en los joysticks y gatillos de presión gradual).
* **JUEGO EJEMPLO:** *Super Mario Bros.* (NES) y *Halo: Combat Evolved* (Xbox).
* **FUENTE:** Investigación de evolución histórica de hardware e interfaces de usuario en videojuegos.

---

## 📜 1. Historia del Gamepad

El gamepad evolucionó para ofrecer una ergonomía superior en comparación con el teclado y el ratón o los joysticks de arcade primitivos. 
* **Aparición:** Aunque existieron mandos anteriores muy básicos, el estándar moderno de control plano con una cruceta direccional (*D-Pad*) y botones de acción (*A/B*) despegó masivamente en **1983** con la consola **NES (Nintendo Entertainment System)**.
* **Fabricante:** Nintendo popularizó la disposición geométrica de los botones que hoy en día sigue vigentes. Con los años, fabricantes como Sony (PlayStation) y Microsoft (Xbox) integraron los joysticks analógicos dobles, motores de vibración y gatillos ergonómicos.
* **Tecnología de captura:** Convierte el estímulo mecánico del pulgar y los dedos del jugador en impulsos eléctricos mediante contactos de carbón sobre circuitos impresos o sensores resistivos y magnéticos de alta precisión.

---

## ⚡ 2. Clasificación de la Señal

El gamepad es un dispositivo híbrido fascinante en cuanto a procesamiento de señales:
* **Señal Digital:** Se utiliza en la cruceta direccional y en los botones frontales y de hombro (*L/R*). Entrega datos binarios discretos: `0` (apagado/sin presionar) o `1` (encendido/presionado).
* **Señal Analógica:** Se encuentra en los *joysticks* (palancas) y gatillos avanzados. Entrega un flujo continuo de datos con valores numéricos flotantes (por ejemplo, coordenadas en ejes $X$ e $Y$ de `-1.0` a `1.0`), permitiendo calcular la dirección exacta y la velocidad con la que se inclina la palanca.

---

## 🎮 3. Videojuegos que lo Hicieron Popular

1. ***Super Mario Bros.* (Nintendo, 1985):** 
   * **Por qué lo hizo popular:** Exigía una precisión milimétrica combinando el salto y el movimiento direccional rápido, demostrando que la cruceta y los botones del pad clásico superaban con creces a los joysticks de palanca tradicionales en los juegos de plataformas en 2D.
2. ***Halo: Combat Evolved* (Bungie / Microsoft, 2001):** 
   * **Por qué lo hizo popular:** Demostró de manera definitiva que los shooters en primera persona (género dominado históricamente por PC con teclado y ratón) se podían jugar de forma sumamente fluida y natural en consola gracias a la estandarización del **doble joystick analógico** (uno para mover al personaje y otro para controlar la cámara libremente).

---

## 🚀 Instrucciones de Entrega
* Carpeta asignada en el repositorio de GitHub: `taller-2.1.1`
* Tiempo estimado de presentación en clase: 2 minutos.
