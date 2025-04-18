@tool
extends Window

@onready var behavior_tree_editor: Control = $".."
@onready var action_name: LineEdit = $VBoxContainer/Options/HBoxContainer/ActionName
@onready var src_path: LineEdit = $VBoxContainer/Options/HBoxContainer/LoadScript/SrcPath
@onready var file_dialog: FileDialog = $FileDialog

var ScriptPath:String

func _on_close_requested() -> void:
	hide()

func _on_open_script_pressed() -> void:
	file_dialog.popup()
	
func _on_file_dialog_file_selected(path: String) -> void:
	src_path.text = path

func _on_create_pressed() -> void:
	var full_path := file_dialog.current_path
	var script := load(full_path) as GDScript
	
	if not script:
		printerr("ERROR LOAD SCRIPT", full_path)
		return
	
	behavior_tree_editor.add_action_node(script, action_name.text)
	hide()
	src_path.text = ""
	action_name.text = ""
