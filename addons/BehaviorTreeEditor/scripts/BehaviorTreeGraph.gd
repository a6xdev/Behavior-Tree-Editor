@tool
extends GraphEdit
class_name BehaviorTreeGraph

var nodes_selected:Array[Node] = []

#region Godot Functions
#endregion

#region Calls
#endregion

func _on_node_selected(node: Node) -> void:
	nodes_selected.append(node)
func _on_node_deselected(node: Node) -> void:
	nodes_selected.erase(node)

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if from_port == to_port:
		connect_node(from_node, from_port, to_node, to_port)
func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)

#region Features
func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for node_name in nodes:
		for conn in connections:
			disconnect_node(conn.from_node, conn.from_port, conn.to_node, conn.to_port)
			
		var node = get_node_or_null(NodePath(node_name))
		if node:
			node.queue_free()

func _on_duplicate_nodes_request() -> void:
	for node in nodes_selected:
		var original = get_node_or_null(NodePath(node.name))
		if original and original is GraphNode:
			var copy = original.duplicate(DUPLICATE_USE_INSTANTIATION | DUPLICATE_SIGNALS) as GraphNode
			copy.position_offset += Vector2(40, 40)
			original.selected = false
			add_child(copy)
#endregion
