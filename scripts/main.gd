extends Node2D

@export var width : int = 0
@export var height : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set root window min.size to zero
	get_tree().get_root().set_min_size(Vector2i(0,0))
	
	# set initiali size
	get_window().size = Vector2i(width, height)
	
	
	Global.switch_ui.connect(_on_hud_switch)
	Global.hide_ui.connect(_on_hud_hide)

	Global.show_nodegraph.connect(_on_show_nodegraph)
	Global.hide_nodegraph.connect(_on_hide_nodegraph)
	#Global.ui_updated.connect(_on_ui_updaded)

	var output = []
	var rc = OS.execute("tmux", ["-Lmindwm", "ls"], output, true)
	if rc == 0:
		var sessions = output[0].split('\n')
		Global.emit_signal("tmux_sessions_changed", sessions)
		
		print("list of tmux sessions:")
		for s in sessions:
			print("  %s" % [s])
	else:
		print("starting new tmux server")

	#_on_ui_updaded()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_window().size = Vector2i(width, height)

func _on_hud_switch():
	# TODO: hide and show to bring the window
	# to the active workspace in case of tiling WM
	$main_ui_window.visible = !$main_ui_window.visible

func _on_hud_hide():
	# TODO: hide and show to bring the window
	# to the active workspace in case of tiling WM
	$main_ui_window.visible = false

func _on_ui_updaded():
	print("on_ui_updated")
	# set main_ui_window size according to whole UI size
	$main_ui_window.size = $main_ui_window/Control.size

func _on_show_nodegraph():
	$node_graph_window.show()

func _on_hide_nodegraph():
	$node_graph_window.hide()
