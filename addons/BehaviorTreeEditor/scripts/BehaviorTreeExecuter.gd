extends Node
class_name BehaviorTreeExecuter

@export var owner_node:Node
@export var BehaviorTreeFile:BehaviorTreeResource

var root_node : Node = null
var nodes = {}
var connections = []

func _ready() -> void:
	if BehaviorTreeFile:
		load_tree(BehaviorTreeFile)

func load_tree(tree:BehaviorTreeResource) -> void:
	for child in get_children():
		child.queue_free()
	
	var node_map = {}
	
	for node_data in tree.nodes:
		var node = create_node_from_data(node_data)
		if node:
			node_map[node_data["name"]] = node
			node.name = node_data["name"]
			add_child(node)
			
			if node_data["type"] == "Root":
				root_node = node
	
	connections = []
	for conn in tree.connections:
		var connection_data = {
			"from": conn["from"],
			"to": conn["to"]
		}
		
		if "from_port" in conn:
			connection_data["from_port"] = conn["from_port"]
		if "to_port" in conn:
			connection_data["to_port"] = conn["to_port"]
		
		connections.append(connection_data)
	
	nodes = tree.nodes

func create_node_from_data(node_data: Dictionary) -> Node:
	var node
	match node_data["type"]:
		"Root" :
			node = BehaviorTreeRoot.new()
		"Sequence" :
			node = BehaviorTreeSequence.new()
		"Selector" :
			node = BehaviorTreeSelector.new()
			node.SelectorResource = node_data["SelectorResource"]
			node.update_label_list()
		"Action" :
			node = BehaviorTreeAction.new()
			node.ActionResource = node_data["ActionResource"]
			node.update_resource()
		_:
			print("Node type: ", node_data["type"], " unknown")
			return null
	
	node.position_offset = Vector2(node_data["position"][0], node_data["position"][1])
	node.visible = false
	
	if node_data.has("script"):
		var script_path = node_data["script"]
		var script = load(script_path)
		if script:
			node.ScriptFile = script
	return node

func _physics_process(delta: float) -> void:
	if root_node and root_node is BehaviorTreeRoot:
		(root_node as BehaviorTreeRoot).execute()
