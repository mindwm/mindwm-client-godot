extends PanelContainer

@export var back_alive : bool = false
@export var nats_alive : bool = false
@export var dbus_alive : bool = false
@export var xorg_alive : bool = false

@export var yes_symbol : String = "✅"
@export var no_symbol : String = "❌"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$VBoxContainer/back/value.text = yes_no(back_alive)
	$VBoxContainer/nats/value.text = yes_no(back_alive)
	$VBoxContainer/dbus/value.text = yes_no(back_alive)
	$VBoxContainer/xorg/value.text = yes_no(back_alive)

func yes_no(b: bool) -> String:
	if b:
		return yes_symbol
	else:
		return no_symbol
