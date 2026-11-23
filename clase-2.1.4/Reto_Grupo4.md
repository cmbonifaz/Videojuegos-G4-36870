# Reto para los compañeros — Grupo 4: Una acción, muchos dispositivos

## Ficha rápida

| Dato | Detalle |
| --- | --- |
| **Grupo y subtema** | Grupo 4 — *Una acción, muchos dispositivos* (pruebas, remapeo y accesibilidad) |
| **Herramienta** | Godot 4.7.x (GDScript) |
| **Duración estimada** | ~7 minutos en el aula |
| **Base de partida** | Proyecto del ejercicio visto en clase (`clase-2.1.4/ejercicio-g-4/`) |
| **Qué aporta de nuevo** | **Remapeo en tiempo de ejecución** mediante `InputMap`, demostrando que el jugador puede cambiar la tecla o el dispositivo de `saltar` sin detener el juego y **sin modificar la lógica del salto** |

---

## Parte 1 — Consigna para el aula (mostrar a los compañeros)

### Enunciado

Partiendo del proyecto del ejercicio (`Ejercicio_G4`), añade una función de **remapeo en tiempo de ejecución** para que el jugador pueda reasignar la acción `saltar` a cualquier otra tecla o botón (por ejemplo, `W`, `Clic derecho` o un botón de mando) sin detener el juego. La lógica que ejecuta el salto (`is_action_pressed("saltar")` e `is_action_released("saltar")`) **no debe modificarse**.

### Requisitos comprobables

1. **Acción de remapeo:** crear una acción **`remapear`** en el *Mapa de entrada* (asignada a la tecla **`R`**) que ponga el juego en modo de espera para capturar una nueva entrada.
2. **Reasignación con `InputMap`:** al presionar la siguiente tecla, botón del ratón o botón de mando, reemplazar los eventos de la acción **`saltar`** en tiempo de ejecución usando `InputMap`, sin editar el bloque que maneja `"saltar"`.
3. **Confirmación en pantalla (`Hud`):** mostrar en el `Hud` cuándo el juego está esperando una nueva entrada y cuál es el nuevo control asignado (`event.as_text()`), comprobando que el control anterior dejó de activar `saltar` y el nuevo sí lo activa.

### Distribución sugerida del tiempo (7 minutos)

| Tiempo | Actividad |
| --- | --- |
| **0:00 – 1:00** | Crear la acción `remapear` (tecla `R`) en **Proyecto → Configuración del proyecto → Mapa de entrada** |
| **1:00 – 4:30** | Agregar la bandera `remapeando`, capturar el siguiente evento válido y actualizar `InputMap` en `main.gd` |
| **4:30 – 5:30** | Mostrar el control asignado y el estado de espera en `actualizar_hud()` |
| **5:30 – 7:00** | Ejecutar (`F5`/`F6`), remapear `saltar` a otra tecla (`W`) y luego a otro dispositivo (`Clic derecho`), y verificar en pantalla |

### Cómo se sabe que está logrado (qué debe verse en pantalla)

1. Al iniciar la escena, `saltar` responde a `Espacio` y `Clic izquierdo`, y el `Hud` muestra el control asignado inicial (`Espacio / Clic izquierdo`).
2. Al presionar **`R`**, `Cuadro` cambia a color amarillo (`Color.GOLD`) y el `Hud` muestra `Estado: Esperando nueva tecla o botón...` (mover el ratón no debe cancelar ni sobrescribir el remapeo).
3. Al presionar una nueva entrada (por ejemplo, tecla **`W`** o **`Clic derecho`**), `Cuadro` vuelve a azul y el `Hud` actualiza la línea **`Control asignado:`** con el nombre del nuevo botón (`W` o `Right Mouse Button`).
4. Al probar de nuevo:
   - `Espacio` y `Clic izquierdo` **ya no hacen saltar** al `Cuadro`.
   - El nuevo control elegido **sí eleva el `Cuadro` 40 píxeles en verde**, incrementa `Activaciones` y actualiza `Dispositivo` y `Último evento` (`Teclado`, `Ratón` o `Mando`), **sin haber modificado la lógica de `"saltar"`**.

---

## Parte 2 — Pista y solución (guardar hasta el cierre)

> **Uso en clase:** mantener esta sección oculta durante el reto. Entregar la **pista** alrededor del minuto 3–4 solo si el curso se traba, y mostrar la **solución** en el cierre (minutos 27–30).

### Pista

Usa una variable booleana `remapeando := false`. Cuando se pulse `remapear` (`R`), cámbiala a `true` y haz `return`. Mientras `remapeando` sea `true`, dentro de `_input(event)` verifica que `event.is_pressed()` sea verdadero y filtra la clase con `event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton` (para evitar que mover el ratón o soltar `R` sobrescriba el control); luego ejecuta:

```gdscript
InputMap.action_erase_events("saltar")
InputMap.action_add_event("saltar", event)
```

### Solución paso a paso

#### 1. Configuración en el *Mapa de entrada*
1. Abre **Proyecto → Configuración del proyecto → Mapa de entrada**.
2. Añade la nueva acción **`remapear`**.
3. Pulsa **`+`** junto a `remapear`, presiona la tecla **`R`** y haz clic en **Aceptar**.

#### 2. Código completo de la solución (`reto-g-4/main.gd`)

El proyecto ejecutable completo se encuentra en `clase-2.1.4/reto-g-4/`.

```gdscript
extends Node2D

# Referencias a los nodos de la escena
@onready var hud: Label = $Hud
@onready var cuadro: ColorRect = $Cuadro

# Variables para mostrar el estado en pantalla (del ejercicio base)
var activaciones := 0
var estado := "En reposo"
var dispositivo := "ninguno"
var ultimo_evento := "ninguno"
var posicion_inicial_y := 0.0

# Variables nuevas del reto (remapeo en tiempo de ejecución)
var remapeando := false
var control_actual := "Espacio / Clic izquierdo"

func _ready() -> void:
	# Guardamos la altura original del cuadro para volver siempre al mismo lugar
	posicion_inicial_y = cuadro.position.y
	actualizar_hud()

func _input(event: InputEvent) -> void:
	# Ignoramos repeticiones automáticas si se deja una tecla presionada
	if event.is_echo():
		return

	# --- LÓGICA DEL RETO: Remapeo en tiempo de ejecución ---
	# 1) Si estamos esperando una nueva entrada, capturamos tecla, ratón o mando
	if remapeando:
		var es_entrada_valida := (
			event is InputEventKey
			or event is InputEventMouseButton
			or event is InputEventJoypadButton
		)
		if event.is_pressed() and es_entrada_valida and not event.is_action("remapear"):
			# Reemplazamos los eventos de "saltar" sin tocar su lógica más abajo
			InputMap.action_erase_events("saltar")
			InputMap.action_add_event("saltar", event)

			remapeando = false
			control_actual = event.as_text()
			estado = "Control remapeado"
			cuadro.color = Color("#3380e6")
			actualizar_hud()
		return

	# 2) Activamos el modo de remapeo con la acción "remapear" (tecla R)
	if event.is_action_pressed("remapear"):
		remapeando = true
		estado = "Esperando nueva tecla o botón..."
		cuadro.color = Color.GOLD
		actualizar_hud()
		return
	# --- FIN LÓGICA DEL RETO ---

	# --- CÓDIGO ORIGINAL DEL EJERCICIO (SIN MODIFICAR) ---
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
	hud.text += "Control asignado: %s\n" % control_actual
	hud.text += "Estado: %s\n" % estado
	hud.text += "Activaciones: %d\n" % activaciones
	hud.text += "Dispositivo: %s\n" % dispositivo
	hud.text += "Último evento: %s\n" % ultimo_evento
	hud.text += "\nPulsa [R] para remapear 'saltar'"
```

### Por qué este reto refuerza el subtema

- **Remapeo y accesibilidad reales:** muestra cómo los menús de configuración de controles funcionan en videojuegos reales (como *Celeste* o *The Last of Us Part II*).
- **Cero cambios en la mecánica:** aunque el jugador reasigne `saltar` de teclado a ratón o a mando durante la partida, el bloque que ejecuta el salto permanece exactamente igual.
