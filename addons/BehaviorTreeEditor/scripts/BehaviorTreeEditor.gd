@tool
extends Control

@onready var add_action_menu: Window = $AddActionMenu
@onready var behavior_tree_graph: BehaviorTreeGraph = $main/HSplitContainer/BehaviorTreeGraph
@onready var selector_ui: PanelContainer = $main/HSplitContainer/Sidebar/VBoxContainer/SelectorUI

var is_modified:bool = false
var current_file_path:String = ""
var has_file:bool = false

#region GODOT FUNCTIONS
func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_S) and has_file:
		save_behavior_tree(current_file_path)
		
func _process(delta: float) -> void:
	if has_file:
		$main/HSplitContainer.show()
		$main/toolbar/AddMenu.show()
	else:
		$main/HSplitContainer.hide()
		$main/toolbar/AddMenu.hide()
	
#endregion

#region CALLS
func _update_window_title():
	var title = "File"
	if is_modified:
		title += "*"
	$main/toolbar/FileMenu.text = title

func new_behavior_tree(path):
	for child in behavior_tree_graph.get_children():
		if child as GraphNode:
			child.queue_free()
	
	var tree_resource = BehaviorTreeResource.new()
	ResourceSaver.save(tree_resource, path)
	current_file_path = path
	
	has_file = true
	is_modified = false
	_update_window_title()

func save_behavior_tree(file_path: String = current_file_path) -> void:
	if current_file_path == "":
		$main/Files/SaveBT.popup()
		return
		
	var tree_resource = BehaviorTreeResource.new()
	var node_map := {}
	
	for node in behavior_tree_graph.get_children():
		if node is GraphNode:
			var node_data = {
				"type": _get_node_type(node),
				"name": node.name,
				"position": [node.position_offset.x, node.position_offset.y]
			}
			
			if "ScriptFile" in node:
				node_data["script"] = node.ScriptFile.resource_path
			
			if "selector_resource" in node:
				node_data["selector_resource"] = node.selector_resource
			
			tree_resource.nodes.append(node_data)
			
	for conn in behavior_tree_graph.get_connection_list():  # Usa get_connection_list() para garantir todas as conexões
		tree_resource.connections.append({
			"from": conn.from_node,
			"to": conn.to_node,
			"from_port": conn.from_port,
			"to_port": conn.to_port
		})
	
	ResourceSaver.save(tree_resource, file_path)
	has_file = true
	is_modified = false
	_update_window_title()

func load_behavior_tree(file_path: String) -> void:
	var resource = ResourceLoader.load(file_path)
	if not resource:
		push_error("Erro ao carregar o arquivo .tres")
		return

	for child in behavior_tree_graph.get_children():
		if child as GraphNode:
			child.queue_free()

	var node_map := {}
	
	for node_data in resource.nodes:
		var node = _create_node_from_data(node_data)
		if node:
			node_map[node_data["name"]] = node
			node.position_offset = Vector2(node_data["position"][0], node_data["position"][1])
			
			if "selector_resource" in node:
				node.selector_resource = node_data["selector_resource"]
			
			behavior_tree_graph.add_child(node)

	for conn_data in resource.connections:
		var from_node = node_map.get(conn_data["from"])
		var to_node = node_map.get(conn_data["to"])
		
		if from_node and to_node:
			var from_port = conn_data.get("from_port", 0)  # Usa 0 como padrão se não existir
			var to_port = conn_data.get("to_port", 0)      # Usa 0 como padrão se não existir
			
			behavior_tree_graph.connect_node(from_node.name, from_port, to_node.name, to_port)
	
	has_file = true
	is_modified = false
	_update_window_title()

func _create_node_from_data(node_data: Dictionary) -> Node:
	var node
	match node_data["type"]:
		"Root" :
			node = BehaviorTreeRoot.new()
		"Sequence" :
			node = BehaviorTreeSequence.new()
		"Selector" :
			node = BehaviorTreeSelector.new()
		"Action" :
			node = BehaviorTreeAction.new()
		_:
			print("Node type: ", node_data["type"], " unknown")
			return null
	
	node.position_offset = Vector2(node_data["position"][0], node_data["position"][1])
	if node_data.has("script"):
		var script_path = node_data["script"]
		var script = load(script_path)
		if script:
			node.ScriptFile = script
	return node

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
	
func add_node(type):
	if type:
		var node = type.new()
		behavior_tree_graph.add_child(node)
		is_modified = true
		_update_window_title()
#endregion

#region SIGNALS
func _on_add_action_pressed() -> void:
	add_action_menu.popup()

func add_action_node(script:Script, action_name:String):
	var node = BehaviorTreeAction.new()
	node.ScriptFile = script
	node.ActionName = action_name
	behavior_tree_graph.add_child(node)
	is_modified = true
	_update_window_title()
#endregion
