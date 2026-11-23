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
