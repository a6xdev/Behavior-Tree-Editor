@tool
extends GraphNode
class_name BehaviorTreeSelector

const STYLE_BOX_SELECTOR = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxSelector.tres")
const STYLE_BOX_SELECTED = preload("res://addons/BehaviorTreeEditor/assets/styles/nodes/StyleBoxSelected.tres")

var action:Label = Label.new()
var selector_resource := BehaviorTreeSelectorResource.new()

#region Godot Functions
func _ready() -> void:
	# Node Config
	name = "selector_"
	title = "Selector"
	custom_minimum_size = Vector2(150.0, 0.0)
	add_theme_stylebox_override("titlebar", STYLE_BOX_SELECTOR)
	add_theme_stylebox_override("titlebar_selected", STYLE_BOX_SELECTED)
	
	# Childs
	add_child(action)
	update_label_list()
#endregion

#region CALLS
func execute():
	var bt_executer:BehaviorTreeExecuter = get_parent()
	if bt_executer == null:
		push_error("Selector: BehaviorTreeExecuter não encontrado.")
		return
	
	var selected_slot = _validate_condition()
	
	for conn in bt_executer.connections:
		# Verifica se esta conexão parte deste nó
		if conn["from"] == name:
			# Se temos informação de porta, convertemos para int para garantir a comparação correta
			if "from_port" in conn and int(conn["from_port"]) == selected_slot:
				var connected_node_name = conn["to"]
				var connected_node = bt_executer.get_node_or_null(NodePath(connected_node_name))
				
				if connected_node and connected_node.has_method("execute"):
					connected_node.execute()
					return
			
			elif not "from_port" in conn and selected_slot == 0:
				var connected_node_name = conn["to"]
				var connected_node = bt_executer.get_node_or_null(connected_node_name)
				
				if connected_node and connected_node.has_method("execute"):
					connected_node.execute()
					return

func update_label_list():
	for node in get_children():
		if node != action:
			node.queue_free()
	
	clear_all_slots()
	
	action.text = selector_resource.main_condition
	set_slot(0, true, 0, Color("#ffffff"), false, 0, Color("#ffffff"), null, null, true)
	
	for i in selector_resource.conditions.size():
		var condition = selector_resource.conditions[i]
		var label_condition := Label.new()
		label_condition.name = "selector_condition"
		label_condition.text = str(condition["condition"]) + " " + str(i +1) + " " + str(get_slot_type_right(i + 1))
		add_child(label_condition)
		
		set_slot(i + 1, false, 0, Color("#00ff00"), true, 0, Color("#00ff00"), null, null, true)

func _validate_condition() -> int:
	var main_condition_var = selector_resource.main_condition
	var bt_executer:BehaviorTreeExecuter = get_parent()
	var owner_node = bt_executer.owner_node
	
	if selector_resource.conditions.size() == 0:
		return 0 
		
	if not bt_executer:
		push_error("executador não encontrado")
		return 0
		
	if not main_condition_var in owner_node:
		push_error("Condição não encontrada" )
		return 0
	
	var state_current = owner_node.get(main_condition_var)
	for i in range(selector_resource.conditions.size()):
		var condition = selector_resource.conditions[i]
		if condition["condition"] == str(state_current):
			return i + 1
	return 0
#endregion

#region SIGNALS
#endregion
