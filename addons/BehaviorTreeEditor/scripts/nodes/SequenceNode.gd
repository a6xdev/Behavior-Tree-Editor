@tool
extends GraphNode
class_name BehaviorTreeSequence

const STYLE_BOX_SEQUENCE = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxSequence.tres")
const STYLE_BOX_SELECTED = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxSelected.tres")

enum {RUNNING, SUCCESS, FAILURE}

var sequence_label:Label = Label.new()
var data:Dictionary
var current_child_index := 0

#region GODOT FUNCTIONS
func _ready() -> void:
	# Node Config
	name = "sequence_"
	title = "Sequence"
	custom_minimum_size = Vector2(150.0, 70.0)
	set_slot(0, true, 0, Color("#ffffff"), true, 0, Color("#ffffff"), null, null, true)
	add_theme_stylebox_override("titlebar", STYLE_BOX_SEQUENCE)
	add_theme_stylebox_override("titlebar_selected", STYLE_BOX_SELECTED)
	
	# Childs
	sequence_label.name = "Sequence"
	sequence_label.text = "Sequence"
	add_child(sequence_label)
#endregion

#region CALLS
func execute() -> int:
	var bt_executer:BehaviorTreeExecuter = get_parent()
	
	if bt_executer == null:
		push_error("Sequence: BehaviorTreeExecuter não encontrado.")
		return FAILURE
	
	# Se não temos nós filhos ordenados ou precisamos recalcular
	# (isto poderia ser calculado uma vez e armazenado até que conexões mudem)
	var connected_nodes = []
	for conn in bt_executer.connections:
		if conn["from"] == name:
			connected_nodes.append({
				"node_name": conn["to"],
				"port": conn.get("from_port", 0)
			})
	
	# Ordena os nós conectados pela porta
	connected_nodes.sort_custom(func(a, b): return a["port"] < b["port"])
	
	# Verifica se temos algum nó para executar
	if connected_nodes.size() == 0:
		return SUCCESS  # Se não há filhos, consideramos como sucesso
	
	# Verifica se o índice atual é válido
	if current_child_index >= connected_nodes.size():
		current_child_index = 0
	
	# Executa apenas o nó atual
	var child_data = connected_nodes[current_child_index]
	var child_node = bt_executer.get_node_or_null(NodePath(child_data["node_name"]))
	
	if not child_node or not child_node.has_method("execute"):
		push_warning("Sequence: Nó filho inválido ou sem método execute: " + child_data["node_name"])
		current_child_index += 1
		
		# Se era o último nó, reiniciamos o índice e retornamos sucesso
		if current_child_index >= connected_nodes.size():
			current_child_index = 0
			return SUCCESS
		# Caso contrário, tentamos executar no próximo ciclo
		return RUNNING
	
	var result = child_node.execute()
	
	match result:
		SUCCESS:
			# Avança para o próximo nó
			current_child_index += 1
			
			# Se completamos todos os nós, reinicia e retorna sucesso
			if current_child_index >= connected_nodes.size():
				current_child_index = 0
				return SUCCESS
			
			# Se ainda há mais nós, retorna RUNNING para continuar no próximo ciclo
			return RUNNING
			
		RUNNING:
			# O nó atual ainda está em execução, mantém o estado e continua
			return RUNNING
			
		FAILURE:
			# Falha em qualquer nó encerra a sequência com falha
			current_child_index = 0
			return FAILURE
	
	return FAILURE
#endregion

#region SIGNALS
#endregion
