@tool
extends Control

@onready var add_action_menu: Window = $main/HSplitContainer/BehaviorTreeOptions/VBoxContainer/AddAction/AddActionMenu
@onready var behavior_tree_graph: BehaviorTreeGraph = $main/HSplitContainer/BehaviorTreeGraph

func _on_add_root_pressed() -> void:
	var node = BehaviorTreeRoot.new()
	behavior_tree_graph.add_child(node)

func _on_add_sequence_pressed() -> void:
	var node = BehaviorTreeSequence.new()
	behavior_tree_graph.add_child(node)

func _on_add_selector_pressed() -> void:
	var node = BehaviorTreeSelector.new()
	behavior_tree_graph.add_child(node)

func _on_add_action_pressed() -> void:
	add_action_menu.popup()

func add_action_node(script:Script, action_name:String):
	var node = BehaviorTreeAction.new()
	node.ScriptFile = script
	node.ActionName = action_name
	behavior_tree_graph.add_child(node)

func save_behavior_tree(file_path: String) -> void:
	var data := {
		"nodes": [],
		"connections": []
	}

	for node in behavior_tree_graph.get_children():
		if node is GraphNode:
			var node_data = {
				"type": _get_node_type(node),
				"name": node.name,
				"position": [node.position_offset.x, node.position_offset.y]
			}

			if "ScriptFile" in node:
				node_data["script"] = node.ScriptFile.resource_path

			data["nodes"].append(node_data)

	for conn in behavior_tree_graph.connections:
		var connection_data = {
			"from": conn.from_node,
			"to": conn.to_node
		}
		data["connections"].append(connection_data)

	var json_text = JSON.stringify(data, "\t")
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(json_text)
	file.close()

	print("File Saved")

func _get_node_type(node: Node) -> String:
	if node is BehaviorTreeRoot:
		return "Root"
	elif node is BehaviorTreeSequence:
		return "Sequence"
	elif node is BehaviorTreeSelector:
		return "Selector"
	elif node is BehaviorTreeAction:
		return "Action"
	return "Unknown"
