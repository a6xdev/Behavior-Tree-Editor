@tool
extends Control

@onready var behavior_tree_editor: Control = $"../.."

@onready var file_menu: MenuButton = $"../toolbar/FileMenu"
@onready var add_menu: MenuButton = $"../toolbar/AddMenu"

@onready var new_bt: FileDialog = $NewBT
@onready var open_bt: FileDialog = $OpenBT
@onready var save_bt: FileDialog = $SaveBT

#region GODOT FUNCTIONS
func _ready() -> void:
	file_menu.get_popup().id_pressed.connect(_file_menu_pressed)
	add_menu.get_popup().id_pressed.connect(_add_menu_pressed)
#endregion

#region SIGNALS
func _file_menu_pressed(id):
	match id:
		0:
			new_bt.popup()
		1:
			open_bt.popup()
		3:
			behavior_tree_editor.save_behavior_tree()

func _add_menu_pressed(id):
	match id:
		0:
			behavior_tree_editor.add_node(BehaviorTreeRoot)
		1:
			behavior_tree_editor.add_node(BehaviorTreeSequence)
		2:
			behavior_tree_editor.add_node(BehaviorTreeSelector)
		3:
			behavior_tree_editor.add_node(BehaviorTreeAction)

func _on_new_file_selected(path: String) -> void:
	behavior_tree_editor.new_behavior_tree(path)

func on_save_file(path:String) -> void:
	behavior_tree_editor.current_file_path = path
	behavior_tree_editor.save_behavior_tree(path)

func on_open_file(path: String) -> void:
	behavior_tree_editor.current_file_path = path
	behavior_tree_editor.load_behavior_tree(path)
#endregion
