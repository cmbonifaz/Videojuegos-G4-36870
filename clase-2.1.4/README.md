# Clase magistral 2.1.4 — Grupo 4: Una acción, muchos dispositivos

## Datos generales

| Dato | Detalle |
| --- | --- |
| **Asignatura / Unidad** | Desarrollo de Videojuegos — Unidad 2.1, subtema `2.1.4` (Captura de la entrada) |
| **Grupo** | Grupo 4 |
| **Subtema** | **4. Una acción, muchos dispositivos** (por qué el código no cambia al agregar dispositivos; ventajas para pruebas, remapeo y accesibilidad) |
| **Versión de Godot** | **Godot 4.7.x** (GDScript, renderizador `GL Compatibility`) |

---

## Integrantes

- Christian Bonifaz
- Anabel Dávila
- Alejandro Montufar

---

## Cómo ejecutar el ejercicio

1. Abre **Godot 4.7.x**.
2. En el gestor de proyectos, haz clic en **Importar** y selecciona el archivo `clase-2.1.4/ejercicio-g-4/project.godot`.
3. Abre el proyecto **`Ejercicio_G4`**.
4. Ejecuta el proyecto pulsando **`F5`** (la escena principal configurada es `main.tscn`) o abre `main.tscn` y pulsa **`F6`**.
5. Prueba la acción **`saltar`** alternando entre los dispositivos ya configurados:
   - **Teclado:** tecla `Espacio`
   - **Ratón:** `Clic izquierdo`
   - *(Opcional)* Si tienes un mando conectado, puedes añadir un botón en **Proyecto → Configuración del proyecto → Mapa de entrada → `saltar`** sin modificar `main.gd`.

### Qué observar en pantalla

- Al presionar la acción `saltar`, el nodo `Cuadro` (`ColorRect`) sube `40` píxeles y cambia de color azul (`#3380e6`) a verde; al soltar, regresa a su posición y color iniciales.
- El nodo `Hud` (`Label`) muestra en tiempo real la acción (`saltar`), su estado (`Saltando` / `En reposo`), el contador de activaciones, el dispositivo detectado (`Teclado`, `Ratón` o `Mando`) y la clase del último evento recibido (`InputEventKey`, `InputEventMouseButton` o `InputEventJoypadButton`).

> **Consejo si no responde al probar:** detén el juego, vuelve a ejecutarlo y haz clic dentro de la ventana del juego para darle el foco.
