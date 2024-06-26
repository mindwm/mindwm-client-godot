extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.dbus.hud_switch.connect(_on_hud_switch)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hud_switch():
	$main_ui_window.visible = !$main_ui_window.visible
