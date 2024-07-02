extends DBusServerNode


func mkMethod(member : String, signature : Dictionary, callback : Callable):
	var m = DBusMethod.new()
	m.member = member
	
	m.signature = []

	var sign : Array	
	for k in signature:
		var p = DBusMethodArgument.new()
		p.arg_name = k
		p.type = signature[k]
		sign.append(p)

	m.set_signature(sign)
	print("%s" % [m.signature])

	m.callback = callback
	return m

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("initialize DBusServerGraph")
	methods.append(
		mkMethod(
			"node_created",
			{"node_id": TYPE_INT,
			"node_type": TYPE_STRING,
			},
			_on_node_created))
	methods.append(
		mkMethod(
			"node_deleted",
			{"node_id": TYPE_INT},
			_on_node_deleted))
	methods.append(mkMethod(
		"edge_created",
		{"edge_type": TYPE_STRING,
		 "node_a_id": TYPE_INT,
		 "node_b_id": TYPE_INT,
		},
		_on_edge_created))
	methods.append(mkMethod(
		"edge_deleted",
		{"edge_type": TYPE_STRING,
		 "node_a_id": TYPE_INT,
		 "node_b_id": TYPE_INT,
		},
		_on_edge_deleted))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_node_created(request: DBusRequest) -> void:
	var msg=request.read()
	var node_id: int = msg[0]
	var node_type: String = msg[1]
	Global.graph_node_created.emit.call_deferred(node_id, node_type)

func _on_node_deleted(request: DBusRequest) -> void:
	var msg=request.read()
	var node_id: int = msg[0]
	Global.graph_node_deleted.emit.call_deferred(node_id)

func _on_edge_created(request: DBusRequest) -> void:
	var msg=request.read()
	var edge_type: String = msg[0]
	var node_a_id: int = msg[1]
	var node_b_id: int = msg[2]
	Global.graph_edge_created.emit.call_deferred(edge_type, node_a_id, node_b_id)

func _on_edge_deleted(request: DBusRequest) -> void:
	var msg=request.read()
	var edge_type: String = msg[0]
	var node_a_id: int = msg[1]
	var node_b_id: int = msg[2]
	Global.graph_edget_deleted.emit.call_deferred(edge_type, node_a_id, node_b_id)
