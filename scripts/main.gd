extends Node2D

@export var width : int = 0
@export var height : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set root window min.size to zero
	get_tree().get_root().set_min_size(Vector2i(0,0))
	
	# set initiali size
	get_window().size = Vector2i(width, height)
	
	Global.dbus.hud_switch.connect(_on_hud_switch)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_window().size = Vector2i(width, height)

func _on_hud_switch():
	# TODO: hide and show to bring the window
	# to the active workspace in case of tiling WM
	$main_ui_window.visible = !$main_ui_window.visible
