@tool
extends GraphNode
class_name BehaviorTreeAction

const STYLE_BOX_ACTION = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxAction.tres")
const STYLE_BOX_SELECTED = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxSelected.tres")

enum {RUNNING, SUCCESS, FAILURE}

var ActionResource := BehaviorTreeActionResource.new()
var action_name_node:Label = Label.new()
var action_script_path:Label = Label.new()

var script_file:Script

#region GODOT FUNCTIONS
func _ready() -> void:
	name = "action_"
	title = "Action"
	custom_minimum_size = Vector2(150.0, 70.0)
	set_slot(0, true, 0, Color("#ffffff"), false, 0, Color("#ffffff"), null, null, true)
	add_theme_stylebox_override("titlebar", STYLE_BOX_ACTION)
	add_theme_stylebox_override("titlebar_selected", STYLE_BOX_SELECTED)
	
	action_name_node.name = "ActionLabelName"
	action_name_node.text = ActionResource.ActionName
	
	action_script_path.name = "ActionScriptPath"
	action_script_path.text = ActionResource.ActionScriptPath
	
	add_child(action_name_node)
	add_child(action_script_path)
	print(ActionResource.ActionName)
#endregion

#region CALLS
func execute() -> int:
	var bt_executer:BehaviorTreeExecuter = get_parent()
	
	if not ActionResource.ScriptFile:
		print("No script: ", ActionResource.ScriptFile)
		return FAILURE
		
	var action_instance = ActionResource.ScriptFile.new()
	var owner_node = bt_executer.owner_node if bt_executer else null
	
	var result = action_instance.run(self)
	match result:
		SUCCESS:
			action_instance = null
		FAILURE:
			action_instance = null
		RUNNING:
			# keeps the instance
			pass
	
	return result
	
func update_resource():
	action_name_node.text = ActionResource.ActionName
	action_script_path.text = ActionResource.ActionScriptPath
	print(ActionResource.ScriptFile)
#endregion
