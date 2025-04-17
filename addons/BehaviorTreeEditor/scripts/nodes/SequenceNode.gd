@tool
extends GraphNode
class_name BehaviorTreeSequence

const STYLE_BOX_ROOT = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxRoot.tres")
const STYLE_BOX_ROOT_SELECTED = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxRootSelected.tres")

var sequence_label:Label = Label.new()

#region Godot Functions
func _ready() -> void:
	# Node Config
	name = "Sequence"
	title = "Sequence"
	custom_minimum_size = Vector2(150.0, 70.0)
	set_slot(0, true, 0, Color("#ffffff"), true, 0, Color("#ffffff"), null, null, true)
	add_theme_stylebox_override("titlebar", STYLE_BOX_ROOT)
	add_theme_stylebox_override("titlebar_selected", STYLE_BOX_ROOT_SELECTED)
	
	# Childs
	sequence_label.name = "Sequence"
	sequence_label.text = "Sequence"
	add_child(sequence_label)
#endregion

#region Calls
#endregion

#region Signals
#endregion
