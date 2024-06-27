extends Resource
class_name UnixSocketInterface

var unixsock := StreamPeerUnix.new()

#signal hud_show
#signal hud_hide
#signal hud_switch


func _init() -> void:
	print("starting unix_socket_interface")
