extends Resource
class_name Action

var name : String
var description : String

func _init(action_name: String, action_description: String) -> void:
	name = action_name
	description = action_description
