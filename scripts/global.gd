extends Node

@onready var xorg := XorgInterface.new()
@onready var socket := UnixSocketInterface.new()

# Global actions list
var actions : Array = []

# UI related signals
signal show_ui
signal hide_ui
signal switch_ui

signal ui_updated
signal ui_showed
signal ui_hided

# TMUX related signals
signal tmux_sessions_changed
signal tmux_session_created
signal tmux_session_removed

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
		Action.new("restart", "restarts something"),
		Action.new("join", "joint to some team"),
		Action.new("list contexts", "show available contextx"),
		Action.new("nodes", "open a node graph")
	])
