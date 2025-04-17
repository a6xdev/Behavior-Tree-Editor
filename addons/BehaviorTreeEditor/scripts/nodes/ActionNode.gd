@tool
extends GraphNode
class_name BehaviorTreeAction

enum {RUNNING, SUCESS, FAILURE}

@export var ScriptFile:Script
@export var ActionName:String = "ActionTest"

var action_name_node:Label = Label.new()

func _ready() -> void:
	name = "Action"
	title = "Action"
	custom_minimum_size = Vector2(150.0, 70.0)
	set_slot(0, true, 0, Color("#ffffff"), false, 0, Color("#ffffff"), null, null, true)
	
	action_name_node.name = "ActionLabelName"
	action_name_node.text = ActionName
	add_child(action_name_node)

func execute() -> int:
	var bt_executer:BehaviorTreeExecuter = get_parent()
	
	if not ScriptFile:
		print("No script in: ", name)
		return FAILURE
		
	var action_instance = ScriptFile.new()
	
	if action_instance.has_method("run_action"):
		action_instance.run_action(bt_executer.owner_node)
		print("BEHAVIOR_TREE::ACTION_EXECUTE::RUN")
	else:
		print("BEHAVIOR_TREE::ACTION_EXECUTE::FAILURE")
		return FAILURE
		
	return SUCESS
