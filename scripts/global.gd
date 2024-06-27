extends Node

@onready var dbus := DBusInterface.new()
@onready var xorg := XorgInterface.new()
@onready var socket := UnixSocketInterface.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		print("headless branch")
		print("initializing globals")
		print("dbus: %s" % dbus.get_instance_id())
		xorg._ready()
	# Run your server startup code here...
	#
	# Using this check, you can start a dedicated server by running
	# a Godot binary (editor or export template) with the `--headless`
	# command-line argument.

	print("initializing globals")
	print("dbus: %s" % dbus.get_instance_id())
	xorg._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dbus._process(delta)
