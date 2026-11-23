# Paso 1 · Investigación del subtema

**Grupo 4 · Subtema: Una acción, muchos dispositivos**
Desarrollo de Videojuegos · Unidad 2.1 · Clase magistral 2.1.4 (Captura de la entrada)
Motor: Godot 4.7.x · Lenguaje: GDScript

---

## 1. Concepto y para qué sirve

**Definición.** Una *acción* es un nombre que describe **lo que el jugador quiere hacer** (por ejemplo `saltar`, `disparar`, `mover_derecha`), no **qué botón presiona**. En Godot, las acciones se guardan en el **Input Map** (*Proyecto → Configuración del proyecto → Mapa de entrada*), y a cada acción se le pueden asignar varios eventos de distintos dispositivos: una tecla, un botón del ratón, un botón del mando, un eje del joystick o un toque en pantalla (Godot Engine, s. f.-a; Godot Engine, s. f.-b).

La idea central del subtema es: **el código del juego solo pregunta por la acción**. Si mañana se agrega un mando, una segunda tecla o un control adaptado, se cambia el Input Map, **no el script**. El código no sabe ni le importa qué dispositivo produjo la acción.

```
 Teclado (Espacio) ─┐
 Mando (botón A)  ──┼──►  acción "saltar"  ──►  script: Input.is_action_just_pressed("saltar")
 Ratón (clic izq.) ─┘
```

Esto aplica el **patrón Command**: se separa "el botón físico" de "la orden del juego" con una capa intermedia, de modo que la orden se puede reasignar sin tocar la lógica (Nystrom, 2014).

**¿Para qué sirve en un videojuego? Tres ventajas:**

| Ventaja | Qué significa en la práctica |
|---|---|
| **Pruebas** | Se puede probar todo el juego con el teclado aunque el destino final sea un mando (o al revés). El equipo no necesita tener todos los dispositivos para probar la lógica, y como hay un solo camino de código, un error se corrige una vez. |
| **Remapeo** | El jugador puede cambiar qué tecla o botón hace cada acción. En Godot se hace en tiempo de ejecución con `InputMap.action_erase_events()` y `InputMap.action_add_event()`, sin reescribir la lógica del personaje (Godot Engine, s. f.-c). |
| **Accesibilidad** | Personas con movilidad reducida, con una sola mano o que usan controles adaptados (por ejemplo, el Xbox Adaptive Controller) pueden asignar las acciones a lo que sí pueden usar. Las guías de accesibilidad recomiendan permitir reasignar todos los controles y admitir varios dispositivos (Microsoft, 2023; Game Accessibility Guidelines, s. f.). |

---

## 2. Cómo se usa en Godot (con código explicado)

### 2.1 Configuración en el editor (sin código)

1. *Proyecto → Configuración del proyecto → pestaña **Mapa de entrada***.
2. Escribir el nombre de la acción (`saltar`) y pulsar **Añadir**.
3. Pulsar el **+** de la acción y asignar:
   - **Tecla física**: `Espacio`.
   - **Botón de joypad**: `Botón 0` (A en Xbox / Cruz en PlayStation), dispositivo *Todos los dispositivos*.
   - (Opcional) **Botón del ratón**: clic izquierdo.
4. Repetir para `mover_izquierda` (A, flecha izq., stick izquierdo X−) y `mover_derecha` (D, flecha der., stick izquierdo X+).

### 2.2 Fragmento de código

```gdscript
extends CharacterBody2D

const VELOCIDAD := 300.0
const FUERZA_SALTO := -450.0

@onready var etiqueta: Label = $"../Label"

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var dir := Input.get_axis("mover_izquierda", "mover_derecha")
	velocity.x = dir * VELOCIDAD
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = FUERZA_SALTO
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("saltar"):
		etiqueta.text = "Acción 'saltar' desde: " + event.get_class()
```

### 2.3 Explicación línea por línea

| Línea | Qué hace |
|---|---|
| `extends CharacterBody2D` | El script controla un personaje 2D con física de movimiento. |
| `const VELOCIDAD := 300.0` | Velocidad horizontal en píxeles por segundo. |
| `const FUERZA_SALTO := -450.0` | Impulso del salto; es negativo porque en Godot el eje Y crece hacia abajo. |
| `@onready var etiqueta ...` | Guarda una referencia al `Label` de la escena cuando el nodo ya está listo. |
| `func _physics_process(delta)` | Se ejecuta en cada paso de física (60 veces por segundo por defecto). |
| `if not is_on_floor(): velocity += get_gravity() * delta` | Si el personaje está en el aire, se le aplica la gravedad del proyecto. |
| `var dir := Input.get_axis("mover_izquierda", "mover_derecha")` | Devuelve un número entre −1 y 1. **Funciona igual con teclas (−1, 0 o 1) que con el stick analógico (valores intermedios)**; el código no distingue el dispositivo. |
| `velocity.x = dir * VELOCIDAD` | Convierte la dirección en velocidad horizontal. |
| `if Input.is_action_just_pressed("saltar") and is_on_floor():` | Pregunta **por la acción**, no por la tecla. Es verdadero el primer frame en que *cualquier* evento asignado a `saltar` se presiona: Espacio, botón A o clic. |
| `velocity.y = FUERZA_SALTO` | Aplica el impulso vertical. |
| `move_and_slide()` | Mueve al personaje y resuelve colisiones. |
| `func _unhandled_input(event)` | Recibe cada evento que la interfaz no consumió. |
| `if event.is_action_pressed("saltar"):` | Comprueba si **este evento concreto** corresponde a la acción, sea del dispositivo que sea. |
| `etiqueta.text = ... + event.get_class()` | Muestra en pantalla la clase del evento (`InputEventKey`, `InputEventJoypadButton`, `InputEventMouseButton`). **Así se demuestra que el dispositivo cambia pero el código es el mismo.** |

### 2.4 Remapeo en tiempo de ejecución (extra)

```gdscript
func remapear_saltar(nuevo_evento: InputEvent) -> void:
	InputMap.action_erase_events("saltar")       # Borra lo asignado antes
	InputMap.action_add_event("saltar", nuevo_evento)  # Asigna el nuevo botón/tecla
```

El script del personaje **no se modifica**: sigue preguntando por `"saltar"`.

---

## 3. Error frecuente de quien empieza y cómo evitarlo

### Error principal: escribir teclas en el código

```gdscript
# ❌ Mal: atado a un solo dispositivo
if Input.is_key_pressed(KEY_SPACE):
	saltar()

# ❌ También mal
func _input(event):
	if event is InputEventKey and event.keycode == KEY_SPACE:
		saltar()
```

**Consecuencia:** el juego solo funciona con el teclado. Para agregar el mando hay que añadir otro `if` con `JOY_BUTTON_A`, luego otro para el ratón… El código crece, se duplica, no se puede remapear y no es accesible.

**Cómo evitarlo:**

```gdscript
# ✅ Bien: se pregunta por la acción
if Input.is_action_just_pressed("saltar"):
	saltar()
```

y los dispositivos se agregan en el **Input Map**. Regla práctica: *si en el script de juego aparece `KEY_`, `JOY_BUTTON_` o `MOUSE_BUTTON_`, probablemente debería ser una acción*.

### Errores secundarios que conviene mencionar

| Error | Síntoma | Cómo evitarlo |
|---|---|---|
| Nombre de acción mal escrito (`"Saltar"` vs `"saltar"`) | Error en consola: la acción no existe en el InputMap; no responde. | Copiar el nombre exacto del Mapa de entrada; usar minúsculas y guion bajo siempre. |
| Asignar el mando a un dispositivo concreto (Dispositivo 0) | Un segundo mando no funciona. | Dejar *Todos los dispositivos* salvo que sea multijugador local. |
| Zona muerta muy baja en el stick | El personaje se desliza solo (*drift*). | Ajustar el *deadzone* de la acción (0,2–0,5) (Godot Engine, s. f.-b). |
| La ventana no tiene el foco | Ninguna entrada responde. | Detener, volver a ejecutar y hacer clic dentro de la ventana. |

---

## 4. Videojuego real donde se nota el concepto

### *Celeste* (Maddy Makes Games, 2018)

- **Cómo se nota:** se puede jugar con teclado o con mando, y **se puede cambiar de uno a otro en plena partida** sin pausar ni configurar nada: Madeline salta igual pulsando la tecla de salto o el botón A. Eso solo es posible porque el juego responde a la acción "saltar", no a una tecla concreta.
- **Remapeo:** en *Opciones → Controles de teclado* y *Controles de mando* el jugador puede reasignar cada acción (saltar, dash, agarrar) a la tecla o botón que prefiera, incluso asignar varias teclas a la misma acción.
- **Accesibilidad:** junto con su *Modo asistido*, el remapeo permite que personas que no pueden usar la distribución por defecto (por ejemplo, jugar con una sola mano) completen el juego.

**Ejemplo complementario:** *The Last of Us Part II* (Naughty Dog, 2020) permite reasignar todos los controles del mando, y es un referente citado en accesibilidad: la misma acción (por ejemplo "esquivar") se mueve al botón que el jugador elija sin que el juego cambie su lógica.

---

## 5. Referencias (APA 7)

Game Accessibility Guidelines. (s. f.). *Allow controls to be remapped / reconfigured*. Recuperado el 23 de noviembre de 2026, de https://gameaccessibilityguidelines.com/allow-controls-to-be-remapped-reconfigured/

Godot Engine. (s. f.-a). *Using InputEvent*. En *Godot Engine documentation* (stable). Recuperado el 23 de noviembre de 2026, de https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html

Godot Engine. (s. f.-b). *Controllers, gamepads, and joysticks*. En *Godot Engine documentation* (stable). Recuperado el 23 de noviembre de 2026, de https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html

Godot Engine. (s. f.-c). *InputMap*. En *Godot Engine documentation* (stable). Recuperado el 23 de noviembre de 2026, de https://docs.godotengine.org/en/stable/classes/class_inputmap.html

Microsoft. (2023). *Xbox Accessibility Guideline 107: Input*. Microsoft Learn. https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/107

Nystrom, R. (2014). *Game programming patterns*. Genever Benning. https://gameprogrammingpatterns.com/command.html

---

> **Nota para el grupo:** antes de pasarlo a la plantilla PDF, reescriban las definiciones con sus propias palabras (la rúbrica lo pide) y abran cada enlace para confirmar la fecha de consulta.
