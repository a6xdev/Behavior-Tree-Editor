extends Node
class_name BehaviorTreeExecuter

@export_file("*.json") var BehaviorTreeFile : String
@export var owner_node:Node

var root_node : Node = null
var nodes = {}
var connections = []

var can_run:bool = false

func _ready() -> void:
	if BehaviorTreeFile != "":
		load_behavior_tree(BehaviorTreeFile)

func load_behavior_tree(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("Erro ao abrir o arquivo.")
		return

	var json_text = file.get_as_text()
	file.close()
	var data = JSON.parse_string(json_text)
	nodes = data["nodes"]
	connections = data["connections"]
	var node_map = {}
	
	for node_data in nodes:
		var node = _create_node_from_data(node_data)
		node_map[node_data["name"]] = node
		node.name = node_data["name"]
		add_child(node)

		if node_data["type"] == "Root":
			root_node = node

	for conn in connections:
		var from_node = node_map[conn["from"]]
		var to_node = node_map[conn["to"]]
		_connect_nodes(from_node, to_node)
	
	if root_node:
		print("Root node configured for execution.")
		print("nodes: ", nodes.size(), " children: ", get_children().size())
		if not get_children().size() < nodes.size():
			can_run = true
			print("assss")
	else:
		print("Erro: Root node não encontrado.")

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

func _connect_nodes(from_node: Node, to_node: Node) -> void:
	if from_node and to_node:
		if from_node is GraphNode and to_node is GraphNode:
			from_node.add_child(to_node)

func _physics_process(delta: float) -> void:
	if root_node and root_node is BehaviorTreeRoot and can_run:
		(root_node as BehaviorTreeRoot).execute()
