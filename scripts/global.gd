extends Node

@onready var dbus := DBusInterface.new()
@onready var xorg := XorgInterface.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("initializing globals")
	print("dbus: %s" % dbus.get_instance_id())
	xorg._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dbus._process(delta)
