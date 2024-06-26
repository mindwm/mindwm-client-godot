extends Resource
class_name XorgInterface

var xorg = Xorg.new()

func _init() -> void:
	print("starting xorg_interface")
	
func _ready():
	print("xorg_interface _ready")
	xorg.init()
	xorg.clipboard_notify.connect(_on_clipboard_event)
	call_deferred("_refresh_windows_list")

func _refresh_windows_list():
	xorg.refresh_xorg_windows()
	#for i in range(xorg.list_windows().size()):
		#if xorg.get_wm_window(i).get_class() == "Godot_Engine":
			#xorg.set_NET_WM_DESKTOP(i, 0xFFFFFFFF)

func _on_clipboard_event(win):
	print("clip event: %s: %s" % [win, DisplayServer.clipboard_get()])
