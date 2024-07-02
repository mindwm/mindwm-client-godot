extends Control

var search_input : LineEdit = null
var search_results : ItemList = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("main_ui ready")
	search_input = $root_container/VBoxContainer/PanelContainer/search_input
	search_results = $root_container/VBoxContainer/PanelContainer2/search_results
	print(search_input)
	search_input.grab_focus()
	_on_global_actions_updated()
	#$root_container.connect("sort_children", _on_sort_children)


func _draw() -> void:
	await get_tree().process_frame
	var sz = $root_container.size
	var screen_size = DisplayServer.screen_get_size()
	print(sz)
	get_window().size = sz
	get_window().position = Vector2i(screen_size.x / 2 - (screen_size.x*0.2), screen_size.y / 2 - 200)
	search_input.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _hide_and_reset() -> void:
		search_input.text = ""
		search_input.release_focus()
		Global.hide_ui.emit()
		_on_search_input_text_changed("")
	
func _on_search_input_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_hide_and_reset()
	elif event.is_action_pressed("ui_accept"):
		var ndx = search_results.get_selected_items()[0]
		print("Execute action: %s: %s" % [
			search_results.get_item_text(ndx),
			search_results.get_item_metadata(ndx)
			])
		_hide_and_reset()

func _on_global_actions_updated():
	if search_results:
		search_results.clear()
		for a in Global.actions:
			search_results.add_item(a.name)


func _on_search_input_text_changed(new_text: String) -> void:
	search_results.clear()
	var re : RegEx = RegEx.new()
	re.compile(".*%s.*" % new_text)
	var ndx = 0
	for a in Global.actions:
		if re.search(a.name):
			search_results.add_item("%s (%s)" % [a.name, a.description])
			# TODO: maybe it needs just to store ref. to action to execute?
			# or just to `execute` an action to emit a signal from it
			# or something like that
			search_results.set_item_metadata(ndx, a.get_rid())
			ndx += 1
	
	if search_results.item_count > 0:
		search_results.select(0)
