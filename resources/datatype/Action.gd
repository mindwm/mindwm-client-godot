extends Resource
class_name Action

var name : String
var description : String
var f : Callable

func _init(action_name: String, action_description: String, action : Callable) -> void:
	name = action_name
	description = action_description
	f = action
