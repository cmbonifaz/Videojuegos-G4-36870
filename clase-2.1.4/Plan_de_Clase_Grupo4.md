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
| **Integrantes** | Christian Bonifaz <br> Anabel Dávila <br> Alejandro Montufar |

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

## 3. Reto para los compañeros (Paso 4)

> **Guía completa y proyecto solución:** ver [Reto_Grupo4.md](Reto_Grupo4.md) y el proyecto ejecutable en `clase-2.1.4/reto-g-4/`.

- **Enunciado (2 frases):**
  Partiendo del proyecto del ejercicio (`Ejercicio_G4`), añade una función de **remapeo en tiempo de ejecución** para que el jugador pueda reasignar la acción `saltar` a cualquier otra tecla o botón (por ejemplo, `W`, `Clic derecho` o un botón de mando) sin detener el juego. La lógica que ejecuta el salto (`is_action_pressed("saltar")` e `is_action_released("saltar")`) **no debe modificarse**.

- **Requisitos comprobables (3 puntos):**
  1. Crear una nueva acción **`remapear`** en el *Mapa de entrada* (asignada a la tecla **`R`**) que ponga el juego en modo de espera para capturar la nueva entrada.
  2. Al presionar la siguiente tecla, botón del ratón o botón de mando, reemplazar los eventos de la acción **`saltar`** mediante `InputMap` (`action_erase_events` y `action_add_event`), sin tocar el bloque de código que maneja `"saltar"`.
  3. Mostrar en el **`Hud`** el estado de espera y el nuevo control asignado (`event.as_text()`), comprobando que el control anterior dejó de activar `saltar` y el nuevo sí lo activa.

- **Tiempo estimado:** `7 minutos` (1 min *Mapa de entrada*, 3,5 min captura y `InputMap` en `main.gd`, 1 min actualización del `Hud`, 1,5 min pruebas con teclado y ratón).

- **Cómo se sabe que está logrado (qué debe verse en pantalla):**
  Al pulsar **`R`**, `Cuadro` cambia a amarillo y el `Hud` muestra `Estado: Esperando nueva tecla o botón...` sin reaccionar al movimiento del ratón. Al pulsar una nueva entrada (por ejemplo, `W` o `Clic derecho`), `Cuadro` vuelve a azul, el `Hud` actualiza `Control asignado:` con el nuevo botón, `Espacio` y `Clic izquierdo` dejan de activar `saltar`, y el nuevo botón eleva `Cuadro` 40 píxeles en verde sumando en `Activaciones` y actualizando `Dispositivo` y `Último evento`.

- **Pista (para apoyar al curso durante el reto — guardar hasta la mitad del tiempo):**
  Usa una variable booleana `remapeando := false` que cambie a `true` al pulsar `remapear` (`R`) y haz `return`. Mientras `remapeando` sea `true`, comprueba `event.is_pressed()` y filtra la clase (`event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton`) para que mover el ratón o soltar `R` no sobrescriban el control; luego llama a `InputMap.action_erase_events("saltar")` y `InputMap.action_add_event("saltar", event)`.

- **Solución (para mostrar en el cierre — `reto-g-4/main.gd`):**

```gdscript
# Variables nuevas del reto
var remapeando := false
var control_actual := "Espacio / Clic izquierdo"

# Al inicio de _input(event), antes del bloque original de "saltar":
	if remapeando:
		var es_entrada_valida := (
			event is InputEventKey
			or event is InputEventMouseButton
			or event is InputEventJoypadButton
		)
		if event.is_pressed() and es_entrada_valida and not event.is_action("remapear"):
			InputMap.action_erase_events("saltar")
			InputMap.action_add_event("saltar", event)
			remapeando = false
			control_actual = event.as_text()
			estado = "Control remapeado"
			cuadro.color = Color("#3380e6")
			actualizar_hud()
		return

	if event.is_action_pressed("remapear"):
		remapeando = true
		estado = "Esperando nueva tecla o botón..."
		cuadro.color = Color.GOLD
		actualizar_hud()
		return
```

---

## 4. Cronograma de la clase magistral (30 minutos — Paso 5)

| Minutos | Momento | Qué se hace | Responsable |
| --- | --- | --- | --- |
| **0 – 3 min** | Apertura | Presentación del grupo, del subtema (*Una acción, muchos dispositivos*) y de los 3 objetivos de aprendizaje. | `[Integrante]` |
| **3 – 12 min** | Presentación | Explicación conceptual, ventajas (pruebas, remapeo y accesibilidad), error frecuente y ejemplo de *Celeste*. | `[Integrante(s)]` |
| **12 – 20 min** | Ejercicio en vivo | Demostración paso a paso en Godot 4.7.x (`ejercicio-g-4/`): teclado primero y segundo dispositivo sin cambiar el código. | `[Integrante(s)]` |
| **20 – 27 min** | Reto para el curso | Remapeo en tiempo de ejecución de la acción `saltar` con `InputMap` (tecla `R`) sin modificar la lógica del salto — el grupo acompaña y entrega la pista si hace falta. | `Todos` |
| **27 – 30 min** | Cierre | Mostrar la solución del reto (`reto-g-4/`) y resumir las tres ideas clave. | `[Integrante]` |

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
