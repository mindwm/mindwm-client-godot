extends DBusServerNode


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
	Global.show_ui.emit.call_deferred()
	#call_deferred_thread_group("Global.emit_signal", "show_ui")

func _on_hide(request: DBusRequest) -> void:
	Global.hide_ui.emit.call_deferred()

func _on_switch(request: DBusRequest) -> void:
	Global.switch_ui.emit.call_deferred()
