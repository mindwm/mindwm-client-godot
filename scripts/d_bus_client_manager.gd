extends DBusClientNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var res = spawn_process("ls -la /home/pion", "")
	print(res)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# dbus-send --session --dest=org.mindwm.client.manager --type=method_call --print-reply / org.mindwm.client.manager.Run string:"ls /home/pion" string:'' string:'destination=org.mindwm.client.godot.process,path=/,interface=org.mindwm.client.godot.process,member=ProcessOutput'
func spawn_process(cmd: String, filter_regex : String) -> Variant:
	var client=DBusClient.new()
	client.open()
	var member = "Run"
	var req = client.create_request(destination, path, interface, member)
	#var dest = "destination=%s,path=%s,interface=%s,member=%s" % [destination, path, interface, member]
	var dest = "destination=org.mindwm.client.godot.process,path=/,interface=org.mindwm.client.godot.process,member=ProcessOutput"
	print(dest)
	req.append_all([
		cmd,
		filter_regex,
		dest
	])
	var res=client.send_request(req)
	if res==null:
		print("failed request")
		return null

	client.close()
	return res
