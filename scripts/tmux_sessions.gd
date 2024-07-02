extends Control

var sessions_list : ItemList = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Starting tmux_sessions node")
	sessions_list = $HBoxContainer/VBoxContainer/sessions_list
	Global.tmux_sessions_changed.connect(_on_tmux_sessions_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_tmux_sessions_changed(sessions) -> void:
	if not sessions_list:
		return

	sessions_list.clear()
	for s in sessions:
		sessions_list.add_item(s)

	Global.ui_updated.emit()
