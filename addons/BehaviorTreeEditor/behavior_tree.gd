@tool
extends EditorPlugin

var editor_plugin = preload("res://addons/BehaviorTreeEditor/EditorInspectorPlugin.gd").new()

var dock:Control

func _enter_tree() -> void:
	const BEHAVIOR_TREE_EDITOR = preload("res://addons/BehaviorTreeEditor/scenes/BehaviorTreeEditor.tscn")
	dock = BEHAVIOR_TREE_EDITOR.instantiate()
	add_control_to_bottom_panel(dock, "Behavior Tree")
	add_inspector_plugin(editor_plugin)
	
	print("Behavior Tree Active")

func _exit_tree() -> void:
	remove_control_from_bottom_panel(dock)
	remove_inspector_plugin(editor_plugin)
	dock.free()
