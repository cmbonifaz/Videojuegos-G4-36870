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

## Contenido de la carpeta

| Archivo / carpeta | Qué es |
| --- | --- |
| `Presentacion_Grupo4.pdf` | Presentación (10 diapositivas) |
| `Plan_de_Clase_Grupo4.pdf` / `.md` | Plan de clase completado: investigación (Paso 1), ejercicio con pasos escritos (Paso 3), reto, cronograma y referencias APA 7 |
| `ejercicio-g-4/` | Proyecto Godot del ejercicio (`Ejercicio_G4`) |
| `Reto_Grupo4.md` | Enunciado, requisitos, pista y solución del reto |
| `reto-g-4/` | Proyecto Godot con la solución del reto (`Reto_G4`) |

Repositorio: https://github.com/cmbonifaz/Videojuegos-G4-36870/tree/main/clase-2.1.4

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

---

## Cómo ejecutar el ejercicio del reto

El reto propone añadir **remapeo en tiempo de ejecución** a la acción `saltar` mediante `InputMap` sin modificar la lógica del salto (ver enunciado, requisitos, pista y solución en [Reto_Grupo4.md](Reto_Grupo4.md)).

1. Abre **Godot 4.7.x**.
2. En el gestor de proyectos, haz clic en **Importar** y selecciona el archivo `clase-2.1.4/reto-g-4/project.godot`.
3. Abre el proyecto **`Reto_G4`**.
4. Ejecuta el proyecto pulsando **`F5`** (escena principal `main.tscn`) o abre `main.tscn` y pulsa **`F6`**.
5. Prueba el remapeo en tiempo de ejecución:
   - Primero comprueba que `saltar` funciona con `Espacio` y `Clic izquierdo`.
   - Pulsa la tecla **`R`** (acción `remapear`): `Cuadro` cambia a color amarillo y el `Hud` muestra `Estado: Esperando nueva tecla o botón...`.
   - Presiona una nueva entrada de cualquier dispositivo, por ejemplo la tecla **`W`**, el **`Clic derecho`** del ratón o un botón de mando.
   - Verifica que `Espacio` y `Clic izquierdo` dejaron de activar `saltar`, mientras que el nuevo control asignado aparece en `Control asignado:` y hace saltar a `Cuadro` usando exactamente el mismo bloque de código de `saltar`.

> **Nota para el aula:** durante los 7 minutos del reto, los compañeros parten de `clase-2.1.4/ejercicio-g-4/` y construyen esta funcionalidad; el proyecto `clase-2.1.4/reto-g-4/` contiene la solución completa lista para mostrar en el cierre.
