extends Resource
class_name DBusInterface

var dbus := DBus.new()

signal hud_show
signal hud_hide
signal hud_switch

func _init() -> void:
	print("starting dbus_interface")
	if dbus.connect(dbus.DBUS_BUS_SESSION) != OK:
		print("Unable to connect to session DBUS")
	
	dbus.request_name("org.mindwm.client", dbus.DBUS_NAME_FLAG_REPLACE_EXISTING)
	
	if dbus.add_match("interface='org.mindwm',member='client',type='signal'") != OK:
		print("Unable to add matcher for signals")
	
func _process(_delta: float) -> void:
	var msg := dbus.pop_message()
	if not msg:
		return
	
	match msg.get_path():
		"/ui/show":
			print("emit show_HUD signal")
			hud_show.emit()
		"/ui/hide":
			print("emit hide_HUD")
			hud_hide.emit()
		"/ui/switch":
			print("emit switch_HUD")
			hud_switch.emit()
			
		_:
			print("Got unknown message: path: %s, args: %s" % [msg.get_path(), msg.get_args()])
