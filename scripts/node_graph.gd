extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.graph_node_created.connect(_on_node_created)
	Global.show_nodegraph.connect(_on_show_nodegraph)
	Global.hide_nodegraph.connect(_on_hide_nodegraph)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_node_created(node_id, node_type):
	var ge : GraphEdit = $VBoxContainer/GraphEdit
	var n : GraphNode = GraphNode.new()
	var l : Label = Label.new()
	l.text = node_type
	n.add_child(l)
	n.set_slot_enabled_left(0, true)
	n.set_slot_enabled_right(0, true)
	ge.add_child(n)
	var count : int = ge.get_children().size()
	if count > 1 and count <= 5:
		ge.connect_node(
			ge.get_child(1).name, 0,
			n.name, 0)
	elif count >= 5:
		ge.connect_node(
			ge.get_child(4).name, 0,
			n.name, 0)
		
	ge.arrange_nodes()


func _on_graph_edit_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Global.hide_nodegraph.emit()
		release_focus()

func _on_show_nodegraph():
	$VBoxContainer/GraphEdit.grab_focus()

func _on_hide_nodegraph():
	$VBoxContainer/GraphEdit.release_focus()
