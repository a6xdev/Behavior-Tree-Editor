@tool
extends PanelContainer

@onready var action_name: LineEdit = $VBoxContainer/PanelContainer/VBoxContainer/ActionName
@onready var script_path: LineEdit = $VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer2/ScriptPath

var ActionNode:BehaviorTreeAction

func _action_name_submitted(new_text: String) -> void:
	ActionNode.ActionResource.ActionName = new_text
	ActionNode.update_resource()
func _action_name_change_rejected(rejected_substring: String) -> void:
	ActionNode.ActionResource.ActionName = rejected_substring
	ActionNode.update_resource()

func _script_path_changed(new_text: String) -> void:
	ActionNode.ActionResource.ActionScriptPath = new_text
	ActionNode.update_resource()
func _script_path_change_rejected(rejected_substring: String) -> void:
	ActionNode.ActionResource.ActionScriptPath = rejected_substring
	ActionNode.update_resource()

func _open_script_pressed() -> void:
	$FileDialog.popup()
	
func _file_selected(path: String) -> void:
	var full_path = $FileDialog.current_path
	var script := load(full_path) as GDScript
	
	if not script:
		print("ERROR LOAD SCRIPT", path)
		return
	
	script_path.text = path
	ActionNode.ActionResource.ScriptFile = script
	ActionNode.ActionResource.ActionScriptPath = path
	ActionNode.update_resource()

func reload_interface():
	action_name.text = ""
	script_path.text = ""
	
	if ActionNode.ActionResource.ActionName != "Action" and ActionNode.ActionResource.ActionScriptPath != "Script Path":
		action_name.text = ActionNode.ActionResource.ActionName
		script_path.text = ActionNode.ActionResource.ActionScriptPath
		
	action_name.placeholder_text = ActionNode.ActionResource.ActionName
	script_path.placeholder_text = ActionNode.ActionResource.ActionScriptPath
