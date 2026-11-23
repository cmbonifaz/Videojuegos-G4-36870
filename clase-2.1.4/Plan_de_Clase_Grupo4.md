# Plan de clase — Clase magistral 2.1.4 (Grupo 4)

## Datos generales

| Dato | Detalle |
| --- | --- |
| **Asignatura / Unidad** | Desarrollo de Videojuegos · Unidad 2.1 |
| **Tema** | `2.1.4` Captura de la entrada |
| **Grupo** | Grupo 4 |
| **Subtema** | **4. Una acción, muchos dispositivos** |
| **Duración máxima** | 30 minutos |
| **Herramienta** | Godot 4.7.x · GDScript |
| **Integrantes** | `[Completar nombres del Grupo 4]` |

---

## Objetivos de aprendizaje

Al finalizar la clase magistral, los compañeros serán capaces de:

1. **Comprender** cómo las acciones del *Mapa de entrada* (*Input Map*) desacoplan la lógica del juego de los dispositivos físicos.
2. **Demostrar** en Godot 4.7.x cómo activar una misma acción (`saltar`) desde el teclado y desde un segundo dispositivo sin modificar el código.
3. **Reconocer** las ventajas de trabajar por acciones para facilitar las pruebas, el remapeo de controles y la accesibilidad.

---

## 1. Investigación del subtema (Paso 1)

### 1.1 Definición y utilidad en videojuegos

Una **acción** es un nombre simbólico que representa la intención del jugador (por ejemplo, `saltar`, `disparar` o `mover_derecha`), en lugar de atarse a una tecla o botón físico específico. En Godot, estas acciones se definen en el **Mapa de entrada** (*Proyecto → Configuración del proyecto → Mapa de entrada*), donde una misma acción puede recibir eventos de múltiples dispositivos: teclado, ratón, mando o pantalla táctil (Godot Engine, s. f.-a; Godot Engine, s. f.-b).

El código del juego solo consulta por el nombre de la acción (`"saltar"`). Si luego se añade otro dispositivo, el cambio ocurre únicamente en el *Mapa de entrada* y **el script permanece intacto**. Este diseño aplica el **patrón Command**, separando el botón físico de la orden lógica del juego (Nystrom, 2014).

| Ventaja | Para qué sirve en la práctica |
| --- | --- |
| **Pruebas** | Permite probar un juego diseñado para mando usando teclado o ratón durante el desarrollo, y evita duplicar código que habría que depurar varias veces. |
| **Remapeo** | Permite que el jugador cambie las teclas o botones asignados a una acción (incluso en tiempo de ejecución con `InputMap`) sin tocar la lógica del personaje (Godot Engine, s. f.-c). |
| **Accesibilidad** | Facilita que jugadores con distintas necesidades usen dispositivos alternativos, controles adaptados o múltiples entradas para una misma acción (Microsoft, 2023; Game Accessibility Guidelines, s. f.). |

---

### 1.2 Uso en Godot y código explicado línea por línea

#### Configuración en el editor (*Mapa de entrada*)
1. Abrir **Proyecto → Configuración del proyecto → Mapa de entrada**.
2. Crear la acción `saltar`.
3. Añadir los eventos físicos que la dispararán (por ejemplo, tecla `Espacio` y `Botón izquierdo del ratón`, o un botón de mando en *Todos los dispositivos*).

#### Fragmento del script (`ejercicio-g-4/main.gd`)

```gdscript
func _input(event: InputEvent) -> void:
	if event.is_echo():
		return

	if event.is_action_pressed("saltar"):
		activaciones += 1
		estado = "Saltando"

		if event is InputEventKey:
			dispositivo = "Teclado"
			ultimo_evento = "InputEventKey"
		elif event is InputEventMouseButton:
			dispositivo = "Ratón"
			ultimo_evento = "InputEventMouseButton"
		elif event is InputEventJoypadButton:
			dispositivo = "Mando"
			ultimo_evento = "InputEventJoypadButton"

		cuadro.position.y = posicion_inicial_y - 40
		cuadro.color = Color.GREEN
		actualizar_hud()
	elif event.is_action_released("saltar"):
		estado = "En reposo"
		cuadro.position.y = posicion_inicial_y
		cuadro.color = Color("#3380e6")
		actualizar_hud()
```

#### Explicación línea por línea

| Línea / Bloque | Qué hace |
| --- | --- |
| `func _input(event: InputEvent) -> void:` | Godot llama a esta función cada vez que ocurre un evento de entrada (tecla, clic, botón de mando, etc.). |
| `if event.is_echo(): return` | Ignora las repeticiones automáticas que envía el sistema cuando una tecla se mantiene presionada. |
| `if event.is_action_pressed("saltar"):` | Verifica si el evento recibido activa la acción `"saltar"`, **sin importar qué dispositivo lo envió**. |
| `activaciones += 1` / `estado = "Saltando"` | Actualiza el contador de activaciones y el texto de estado que verá el jugador. |
| `if event is InputEventKey:` / `elif ...` | Inspecciona la clase del evento únicamente para mostrar en el `Hud` qué hardware lo disparó (`Teclado`, `Ratón` o `Mando`). En un juego real este bloque no es necesario. |
| `cuadro.position.y = posicion_inicial_y - 40` | Mueve el `ColorRect` hacia arriba como respuesta visual en pantalla. |
| `cuadro.color = Color.GREEN` | Cambia el color del cuadro a verde mientras la acción está presionada. |
| `actualizar_hud()` | Refresca el texto del nodo `Label` (`Hud`) con los datos actuales. |
| `elif event.is_action_released("saltar"):` | Detecta cuando se suelta la acción `"saltar"` en cualquiera de los dispositivos asignados. |
| `estado = "En reposo"` / restauración visual | Devuelve el `Cuadro` a su altura inicial (`posicion_inicial_y`) y color azul (`#3380e6`), y actualiza el `Hud`. |

> **Remapeo en tiempo de ejecución:** si en un menú de opciones se quisiera cambiar la tecla o botón asignado a `"saltar"`, bastaría con usar `InputMap.action_erase_events("saltar")` y `InputMap.action_add_event("saltar", nuevo_evento)` (Godot Engine, s. f.-c); el bloque de `_input()` seguiría igual.

---

### 1.3 Error frecuente y cómo evitarlo

El error más común al empezar es **escribir teclas o botones fijos dentro del código**, atando la mecánica a un único dispositivo:

```gdscript
# ❌ Incorrecto: acoplado al teclado
if Input.is_key_pressed(KEY_SPACE):
	saltar()

# ❌ Incorrecto: obliga a duplicar condiciones por dispositivo
if event is InputEventKey and event.keycode == KEY_SPACE:
	saltar()
```

**Cómo evitarlo:** consultar siempre por la **acción** (`event.is_action_pressed("saltar")` o `Input.is_action_just_pressed("saltar")`) y asignar los dispositivos en el *Mapa de entrada*.

| Error secundario | Síntoma | Cómo evitarlo |
| --- | --- | --- |
| Escribir mal el nombre de la acción (`"Saltar"` vs `"saltar"`) | La acción no responde y aparece error en consola. | Copiar el nombre exacto del *Mapa de entrada* y usar minúsculas. |
| Asignar el mando a un único índice (`Device 0`) | Otro mando conectado no funciona. | Dejar *Todos los dispositivos* en juegos de un jugador. |
| *Deadzone* muy baja en sticks analógicos | El personaje se mueve solo (*drift*). | Ajustar la zona muerta de la acción en el *Mapa de entrada* (0,2–0,5) (Godot Engine, s. f.-b). |
| Ventana del juego sin foco | Ninguna entrada responde al probar. | Detener, volver a ejecutar y hacer clic dentro de la ventana. |

---

### 1.4 Videojuego real donde se nota el concepto

- ***Celeste* (Maddy Makes Games, 2018):** permite jugar indistintamente con teclado o mando y cambiar de dispositivo en medio de una partida sin pausar ni reiniciar, porque el personaje responde a acciones abstractas (saltar, *dash*, agarrar). Además, su menú permite remapear cada acción y asignar múltiples teclas a una misma función, lo cual junto al *Modo asistido* mejora la accesibilidad.
- **Ejemplo complementario — *The Last of Us Part II* (Naughty Dog, 2020):** permite reasignar por completo las acciones de su esquema de control, manteniendo intacta la lógica del juego sin importar qué botón ejecute cada acción.

---

## 2. Ejercicio práctico en vivo (Paso 3)

| Aspecto | Detalle |
| --- | --- |
| **Proyecto** | `clase-2.1.4/ejercicio-g-4/` (`Ejercicio_G4`) |
| **Escena y script** | `main.tscn` (`Main`, `Cuadro` [`ColorRect`], `Hud` [`Label`]) y `main.gd` |
| **Duración en vivo** | ~8 minutos |
| **Guía detallada** | Ver paso a paso replicable en [Guia_Ejercicio_Grupo4.md](file:///c:/Users/mateo/Desktop/Videojuegos/Videojuegos-G4-36870/clase-2.1.4/Guia_Ejercicio_Grupo4.md) |

### Flujo de la demostración en dos fases

1. **Fase 1 (Solo teclado):** se crea la escena con los 3 nodos, se configura la acción `saltar` únicamente con `Espacio` en el *Mapa de entrada* y se escribe `main.gd`. Al ejecutar (`F5` / `F6`), `Cuadro` sube 40 píxeles y cambia a verde al presionar `Espacio`, mientras `Hud` muestra `Dispositivo: Teclado` (`InputEventKey`). Al hacer clic con el ratón aún no ocurre nada.
2. **Fase 2 (Segundo dispositivo sin tocar el código):** se detiene la ejecución, se abre el *Mapa de entrada* y se agrega **Botón izquierdo del ratón** (y opcionalmente un botón de mando) a la acción `saltar`, **sin editar ni una línea de `main.gd`**. Al volver a ejecutar y alternar entre `Espacio` y `Clic izquierdo`, `Cuadro` reacciona exactamente igual y el `Hud` confirma el cambio de dispositivo.

---

## 3. Reto para los compañeros (Paso 4) — `[ESPACIO PENDIENTE — COMPAÑERO]`

> **Nota:** Esta sección queda reservada para el reto que está preparando el compañero encargado del Paso 4. Completar los cuatro apartados siguientes antes de la entrega.

- **Enunciado (1–2 frases):**
  `[Completar aquí el enunciado claro y breve del reto, pidiendo algo nuevo respecto al ejercicio]`

- **Requisitos comprobables (2–3 puntos):**
  1. `[Completar requisito 1]`
  2. `[Completar requisito 2]`
  3. `[Completar requisito 3 (opcional)]`

- **Tiempo estimado:** `7 minutos`

- **Cómo se sabe que está logrado (qué debe verse en pantalla):**
  `[Completar aquí el resultado visual esperado en pantalla]`

- **Pista (para apoyar al curso durante el reto):**
  `[Completar aquí la pista que el grupo dará si los compañeros se traban]`

- **Solución (para mostrar en el cierre):**

```gdscript
# [Completar aquí los pasos o el código solución del reto]
```

---

## 4. Cronograma de la clase magistral (30 minutos — Paso 5)

| Minutos | Momento | Qué se hace | Responsable |
| --- | --- | --- | --- |
| **0 – 3 min** | Apertura | Presentación del grupo, del subtema (*Una acción, muchos dispositivos*) y de los 3 objetivos de aprendizaje. | `[Integrante]` |
| **3 – 12 min** | Presentación | Explicación conceptual, ventajas (pruebas, remapeo y accesibilidad), error frecuente y ejemplo de *Celeste*. | `[Integrante(s)]` |
| **12 – 20 min** | Ejercicio en vivo | Demostración paso a paso en Godot 4.7.x (`ejercicio-g-4/`): teclado primero y segundo dispositivo sin cambiar el código. | `[Integrante(s)]` |
| **20 – 27 min** | Reto para el curso | `[Completar breve resumen del reto]` — el grupo acompaña y entrega la pista si hace falta. | `Todos` |
| **27 – 30 min** | Cierre | Mostrar la solución del reto y resumir las tres ideas clave. | `[Integrante]` |

---

## 5. Tres ideas clave para el cierre

1. **Programa acciones, no botones:** tu código debe preguntar por `"saltar"` o `"disparar"`, nunca por teclas o botones físicos concretos.
2. **Más dispositivos, cero cambios en el código:** agregar un ratón, un mando o un control adaptado se resuelve en el *Mapa de entrada*, manteniendo la lógica intacta.
3. **Mejor desarrollo y mejor experiencia:** separar la entrada de la lógica facilita las **pruebas**, habilita el **remapeo** y hace el juego más **accesible**.

---

## 6. Referencias (APA 7)

Game Accessibility Guidelines. (s. f.). *Allow controls to be remapped / reconfigured*. Recuperado el 23 de noviembre de 2026, de https://gameaccessibilityguidelines.com/allow-controls-to-be-remapped-reconfigured/

Godot Engine. (s. f.-a). *Using InputEvent*. En *Godot Engine documentation* (stable). Recuperado el 23 de noviembre de 2026, de https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html

Godot Engine. (s. f.-b). *Controllers, gamepads, and joysticks*. En *Godot Engine documentation* (stable). Recuperado el 23 de noviembre de 2026, de https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html

Godot Engine. (s. f.-c). *InputMap*. En *Godot Engine documentation* (stable). Recuperado el 23 de noviembre de 2026, de https://docs.godotengine.org/en/stable/classes/class_inputmap.html

Microsoft. (2023). *Xbox Accessibility Guideline 107: Input*. Microsoft Learn. https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/107

Nystrom, R. (2014). *Game programming patterns*. Genever Benning. https://gameprogrammingpatterns.com/command.html
