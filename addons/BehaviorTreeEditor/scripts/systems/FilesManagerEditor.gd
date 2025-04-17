@tool
extends Control

@onready var behavior_tree_editor: Control = $"../.."

@onready var file_menu: MenuButton = $"../toolbar/FileMenu"

@onready var new_bt: FileDialog = $NewBT
@onready var open_bt: FileDialog = $OpenBT
@onready var save_bt: FileDialog = $SaveBT

#region GODOT FUNCTIONS
func _ready() -> void:
	file_menu.get_popup().id_pressed.connect(_file_menu_pressed)
	
#endregion

#region SIGNALS
func _file_menu_pressed(id):
	match id:
		3:
			save_bt.popup()
		
func _on_save_file_selected(path: String) -> void:
	print(path)
	behavior_tree_editor.save_behavior_tree(path)
#endregion
