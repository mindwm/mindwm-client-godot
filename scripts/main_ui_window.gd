extends Control

var search_input : LineEdit = null
var search_results : ItemList = null
var width_ratio : float = 0.5
var height_ratio : float = 0.1
var pos_x : int = 200
var pos_y : int = 200
var width : int = 200
var height : int = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("main_ui ready")
	search_input = $root_container/VBoxContainer/PanelContainer/search_input
	search_results = $root_container/VBoxContainer/PanelContainer2/search_results
	print(search_input)
	search_input.grab_focus()
	
	# calculate position and size
	var screen_size = DisplayServer.screen_get_size()
	var size_x = screen_size.x * width_ratio
	width = size_x
	pos_x = size_x - width / 2
	var size_y = screen_size.y * height_ratio
	height = size_y
	pos_y = screen_size.y / 2 - height / 2
	_on_global_actions_updated()
	#$root_container.connect("sort_children", _on_sort_children)


func _draw() -> void:
	await get_tree().process_frame
	var sz = $root_container.size
	var screen_size = DisplayServer.screen_get_size()
	$root_container.size = Vector2i(width, height)
	print(sz)
	get_window().size = Vector2i(width, height)
	get_window().position = Vector2i(pos_x, pos_y)
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
		if search_results.get_selected_items():
			var ndx = search_results.get_selected_items()[0]
			var f : Callable = search_results.get_item_metadata(ndx)
			f.call()
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
			search_results.set_item_metadata(ndx, a.f)
			ndx += 1
	
	if search_results.item_count > 0:
		search_results.select(0)
