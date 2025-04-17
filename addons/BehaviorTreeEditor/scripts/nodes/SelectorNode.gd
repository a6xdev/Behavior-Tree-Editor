@tool
extends GraphNode
class_name BehaviorTreeSelector

const STYLE_BOX_ROOT = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxRoot.tres")
const STYLE_BOX_ROOT_SELECTED = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxRootSelected.tres")

var action:Label = Label.new()

#region Godot Functions
func _ready() -> void:
	# Node Config
	name = "Selector"
	title = "Selector"
	custom_minimum_size = Vector2(150.0, 70.0)
	set_slot(0, true, 0, Color("#ffffff"), true, 0, Color("#ffffff"), null, null, true)
	add_theme_stylebox_override("titlebar", STYLE_BOX_ROOT)
	add_theme_stylebox_override("titlebar_selected", STYLE_BOX_ROOT_SELECTED)
	
	# Childs
	action.name = "SelectorAction"
	action.text = "Actions"
	add_child(action)
#endregion

#region Calls
#endregion

#region Signals
#endregion
