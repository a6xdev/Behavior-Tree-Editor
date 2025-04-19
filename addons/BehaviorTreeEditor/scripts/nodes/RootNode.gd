@tool
extends GraphNode
class_name BehaviorTreeRoot

const STYLE_BOX_ROOT = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxRoot.tres")
const STYLE_BOX_SELECTED = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxSelected.tres")

enum {RUNNING, SUCCESS, FAILURE}

var ObjectName:Label = Label.new()

#region GODOT FUNCTIONS
func _ready() -> void:
	# Node Config
	name = "root_"
	title = "Root"
	custom_minimum_size = Vector2(150.0, 70.0)
	set_slot(0, false, 0, Color("#ffffff"), true, 0, Color("#ffffff"), null, null, true)
	add_theme_stylebox_override("titlebar", STYLE_BOX_ROOT)
	add_theme_stylebox_override("titlebar_selected", STYLE_BOX_SELECTED)
	
	# Childs
	ObjectName.text = "ObjectName"
	add_child(ObjectName)
#endregion

#region CALLS
func execute():
	var bt_executer:BehaviorTreeExecuter = get_parent()
	
	for conn in bt_executer.connections:
		if conn.from == name:
			var connected_node = bt_executer.get_node(NodePath(conn.to))
			if connected_node.has_method("execute"):
				connected_node.execute()
#endregion
