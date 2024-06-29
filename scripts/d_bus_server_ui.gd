extends DBusServerNode

signal show_ui
signal hide_ui
signal switch_ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("initialize DBusServerUI")
	methods[0].callback = _on_show
	methods[1].callback = _on_hide
	methods[2].callback = _on_switch


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_show(request: DBusRequest) -> void:
	call_deferred_thread_group("emit_signal", "show_ui")

func _on_hide(request: DBusRequest) -> void:
	call_deferred_thread_group("emit_signal", "hide_ui")

func _on_switch(request: DBusRequest) -> void:
	call_deferred_thread_group("emit_signal", "switch_ui")
