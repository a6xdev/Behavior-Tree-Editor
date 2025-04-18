@tool
extends GraphNode
class_name BehaviorTreeSelector

const STYLE_BOX_SELECTOR = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxSelector.tres")
const STYLE_BOX_SELECTED = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxSelected.tres")

var action:Label = Label.new()
var selector_resource := BehaviorTreeSelectorResource.new()

#region Godot Functions
func _ready() -> void:
	# Node Config
	name = "selector_"
	title = "Selector"
	custom_minimum_size = Vector2(150.0, 0.0)
	add_theme_stylebox_override("titlebar", STYLE_BOX_SELECTOR)
	add_theme_stylebox_override("titlebar_selected", STYLE_BOX_SELECTED)
	
	# Childs
	add_child(action)
#endregion

func update_label_list():
	for node in get_children():
		if node != action:
			node.queue_free()
	
	action.text = selector_resource.main_condition
	set_slot(0, true, 0, Color("#ffffff"), false, 0, Color("#ffffff"), null, null, true)
	
	for i in selector_resource.connections.size():
		var condition = selector_resource.connections[i]
		var label_condition := Label.new()
		label_condition.text = str(condition["condition"])
		add_child(label_condition)

		set_slot(i + 1, false, 0, Color("#ffffff"), true, 0, Color("#ffffff"), null, null, true)


#region Calls
func _has_label_with_name(label_name: String) -> bool:
	for child in get_children():
		if child is Label and child.name == label_name:
			return true
	return false
#endregion

#region Signals
#endregion
