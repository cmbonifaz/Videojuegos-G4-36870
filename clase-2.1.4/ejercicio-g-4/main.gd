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
