# Guía del Ejercicio — Grupo 4: Una acción, muchos dispositivos

## Ficha rápida

| Dato | Detalle |
| --- | --- |
| **Grupo y subtema** | Grupo 4 — *Una acción, muchos dispositivos* |
| **Herramienta** | Godot 4.7.x (GDScript) |
| **Duración estimada** | ~8 minutos en vivo |
| **Qué demuestra** | Una misma acción (`saltar`) activada desde el teclado y desde un segundo dispositivo (ratón, y opcionalmente mando), usando **exactamente el mismo código** |

---

## Resumen de tiempos para la demo en vivo (8 min)

| Tiempo | Actividad | Qué se hace en vivo |
| --- | --- | --- |
| **0:00 – 1:30** | Crear la escena | Armar los 3 nodos (`Main`, `Cuadro`, `Hud`) y guardar `main.tscn` |
| **1:30 – 2:30** | Configurar `Mapa de entrada` (Fase 1) | Crear la acción `saltar` y asignarle solo `Espacio` |
| **2:30 – 5:00** | Escribir `main.gd` y probar | Explicar el script corto, ejecutar y probar con teclado |
| **5:00 – 6:30** | Agregar segundo dispositivo | Añadir `Botón izquierdo del ratón` a `saltar` **sin tocar el código** |
| **6:30 – 8:00** | Segunda prueba y cierre | Probar ambos dispositivos alternadamente y explicar ventajas |

---

## Paso 1: Crear la escena (3 nodos)

1. Crea una nueva escena y elige como nodo raíz **Otro nodo** → `Node2D`.
2. Renombra la raíz a `Main`.
3. Añade dos nodos hijos a `Main`:
   - `ColorRect` llamado **`Cuadro`**:
     - En el Inspector, ajusta **Layout → Transform**:
       - **Size**: `x = 100`, `y = 100`
       - **Position**: `x = 300`, `y = 250`
     - En **Color**, elige azul: `#3380e6`.
   - `Label` llamado **`Hud`**:
     - En el Inspector, ajusta **Layout → Transform → Position**: `x = 20`, `y = 20`.

El árbol de nodos debe quedar así:

```text
Main (Node2D)
├── Cuadro (ColorRect)
└── Hud (Label)
```

4. Guarda la escena con `Ctrl + S` como **`main.tscn`**.

---

## Paso 2: Configurar la acción solo con Teclado (Fase 1)

1. Abre **Proyecto → Configuración del proyecto...** y ve a la pestaña **Mapa de entrada**.
2. En el campo **Añadir nueva acción**, escribe **`saltar`** y pulsa **Añadir** (o `Enter`).
3. Haz clic en el botón **`+`** a la derecha de `saltar` para agregar un evento.
4. Presiona la tecla **`Espacio`** y pulsa **Aceptar**.
5. Cierra la ventana de Configuración del proyecto.

> En este punto, la acción `saltar` **solo** responde al teclado.

---

## Paso 3: Escribir el script en `Main` (`main.gd`)

1. Selecciona el nodo `Main` y haz clic en el botón **Adjuntar script** (ícono de pergamino con `+`).
2. Guárdalo como **`main.gd`** y pega el siguiente código:

```gdscript
extends Node2D

# Referencias a los nodos de la escena
@onready var hud: Label = $Hud
@onready var cuadro: ColorRect = $Cuadro

# Variables para mostrar el estado en pantalla
var activaciones := 0
var estado := "En reposo"
var dispositivo := "ninguno"
var ultimo_evento := "ninguno"
var posicion_inicial_y := 0.0

func _ready() -> void:
	# Guardamos la altura original del cuadro para volver siempre al mismo lugar
	posicion_inicial_y = cuadro.position.y
	actualizar_hud()

func _input(event: InputEvent) -> void:
	# Ignoramos repeticiones automáticas si se deja la tecla presionada
	if event.is_echo():
		return

	# Comprobamos si el evento activa la acción "saltar"
	if event.is_action_pressed("saltar"):
		activaciones += 1
		estado = "Saltando"

		# Identificamos el dispositivo solo para mostrarlo en el Hud
		if event is InputEventKey:
			dispositivo = "Teclado"
			ultimo_evento = "InputEventKey"
		elif event is InputEventMouseButton:
			dispositivo = "Ratón"
			ultimo_evento = "InputEventMouseButton"
		elif event is InputEventJoypadButton:
			dispositivo = "Mando"
			ultimo_evento = "InputEventJoypadButton"

		# Reacción visible en pantalla: el cuadro sube y se pone verde
		cuadro.position.y = posicion_inicial_y - 40
		cuadro.color = Color.GREEN
		actualizar_hud()

	# Comprobamos si el evento suelta la acción "saltar"
	elif event.is_action_released("saltar"):
		estado = "En reposo"

		# Restauramos la posición original y el color azul
		cuadro.position.y = posicion_inicial_y
		cuadro.color = Color("#3380e6")
		actualizar_hud()

func actualizar_hud() -> void:
	hud.text = "Acción: saltar\n"
	hud.text += "Estado: %s\n" % estado
	hud.text += "Activaciones: %d\n" % activaciones
	hud.text += "Dispositivo: %s\n" % dispositivo
	hud.text += "Último evento: %s" % ultimo_evento
```

> **Nota pedagógica clave:** la lógica del juego (`event.is_action_pressed("saltar")` y `event.is_action_released("saltar")`) **no depende de ningún dispositivo físico**. El bloque `if event is ...` está ahí únicamente para imprimir en el `Hud` qué dispositivo disparó la acción; en un juego real ni siquiera haría falta escribirlo.

---

## Paso 4: Primera prueba (solo Teclado)

1. Ejecuta la escena actual con **`F6`** (o el proyecto con **`F5`** eligiendo `main.tscn` como escena principal).
2. Presiona **`Espacio`** varias veces.
3. Comprueba en pantalla:
   - `Cuadro` sube 40 píxeles y cambia a verde al presionar, y baja a azul al soltar.
   - `Hud` muestra:
     - `Acción: saltar`
     - `Estado: Saltando` / `En reposo`
     - `Activaciones` aumentando en `1`
     - `Dispositivo: Teclado`
     - `Último evento: InputEventKey`
4. Haz clic izquierdo con el ratón en la ventana: verás que **todavía no hace nada** porque aún no está asignado en el Mapa de entrada.

> **Si una acción no responde al probar:** detén el juego, vuelve a ejecutarlo y haz clic dentro de la ventana para darle el foco.

---

## Paso 5: Agregar un segundo dispositivo SIN tocar el código (Momento clave)

1. Detén la ejecución del juego.
2. Abre de nuevo **Proyecto → Configuración del proyecto... → Mapa de entrada**.
3. Busca la acción `saltar` y haz clic en el botón **`+`** para añadir un segundo evento.
4. En la ventana que aparece, selecciona **Botón del ratón → Botón izquierdo del ratón** (o haz clic en el área de captura de ratón) y pulsa **Aceptar**.
   - *(Opcional si hay un mando conectado en clase)*: puedes volver a pulsar **`+`** en `saltar` y presionar el botón `A` / `X` del mando para sumar un tercer dispositivo.
5. Cierra la Configuración del proyecto.

> **Importante:** recalca al curso que **no se editó ni una sola línea de `main.gd`**.

---

## Paso 6: Segunda prueba y cierre conceptual

1. Vuelve a ejecutar la escena (`F6` o `F5`).
2. Alterna entre **`Espacio`** y **`Clic izquierdo`** (y botón del mando si lo agregaron).
3. Observa que `Cuadro` reacciona exactamente igual y el contador `Activaciones` sigue sumando, mientras el `Hud` confirma el cambio de hardware:
   - Con `Espacio` → `Dispositivo: Teclado` (`InputEventKey`)
   - Con `Clic izquierdo` → `Dispositivo: Ratón` (`InputEventMouseButton`)

### Tres ideas para destacar al terminar el ejercicio

- **Por qué no cambia el código:** el script pregunta por la **acción abstracta** (`"saltar"`), no por teclas ni botones concretos; Godot traduce los eventos de entrada a acciones mediante el `Mapa de entrada`.
- **Ventajas para pruebas y remapeo:** puedes probar controles pensados para mando usando teclado o ratón mientras desarrollas, y cambiar controles (remapeo) sin tocar la lógica del personaje.
- **Ventaja para accesibilidad:** permite que distintos jugadores usen el dispositivo o combinación de entradas que mejor se adapte a sus necesidades sin modificar el juego.

---
