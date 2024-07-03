extends Node

@onready var xorg := XorgInterface.new()
@onready var socket := UnixSocketInterface.new()

# Global actions list
var actions : Array = []

# UI related signals
signal show_ui
signal hide_ui
signal switch_ui
signal show_nodegraph
signal hide_nodegraph

signal ui_updated
signal ui_showed
signal ui_hided

# TMUX related signals
signal tmux_sessions_changed
signal tmux_session_created
signal tmux_session_removed

# Node Graph chagned events
signal graph_node_created
signal graph_node_deleted
signal graph_edget_created
signal graph_edget_deleted

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		print("headless branch")
		print("initializing globals")
		xorg._ready()
	# Run your server startup code here...
	#
	# Using this check, you can start a dedicated server by running
	# a Godot binary (editor or export template) with the `--headless`
	# command-line argument.

	print("initializing globals")
	xorg._ready()

	add_global_actions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_global_actions():
	actions.append_array([
		Action.new("restart", "restarts something", _dummy_action),
		Action.new("join", "joint to some team", _dummy_action),
		Action.new("list contexts", "show available contextx", _dummy_action),
		Action.new("nodes", "open a node graph", show_nodegraph.emit)
	])

func _dummy_action():
	print("dummy action performed")
