extends DBusServerNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Initializing DBus process listener")
	methods[0].callback = _on_process_output


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_process_output(request: DBusRequest) -> void:
	var msg=request.read()
	var uid = msg[0]
	var output = msg[1]
	var terminated = msg[2]
	print("(%s): %s (%s)" % [uid, output, terminated])
	var response=Array()
	response.append(0)
	request.reply(response)
