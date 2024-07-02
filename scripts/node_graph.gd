extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.graph_node_created.connect(_on_node_created)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_node_created(node_id, node_type):
	var n : GraphNode = GraphNode.new()
	var l : Label = Label.new()
	l.text = node_type
	n.add_child(l)
	var ge = $VBoxContainer/GraphEdit
	ge.add_child(n)
	ge.arrange_nodes()
