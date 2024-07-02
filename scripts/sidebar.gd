extends Control

var current_submenu = null
var tmux_sessions_list : Control = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tmux_sessions_list = $HBoxContainer/VBoxContainer/tmux_sessions_list
	#$HBoxContainer/tmux_sessions.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tmux_sessions_pressed() -> void:
	if (current_submenu == tmux_sessions_list):
		if tmux_sessions_list.visible:
			tmux_sessions_list.hide()
		else:
			tmux_sessions_list.show()
	else:
		if current_submenu:
			current_submenu.hide()
		tmux_sessions_list.show()
		current_submenu = tmux_sessions_list

	Global.ui_updated.emit()
