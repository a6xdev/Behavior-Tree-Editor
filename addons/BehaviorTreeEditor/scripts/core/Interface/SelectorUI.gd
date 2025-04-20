@tool
extends PanelContainer

@onready var condition_title: LineEdit = $VBoxContainer/Condition
@onready var conditions_list: VBoxContainer = $VBoxContainer/ConditionsList

var MainCondition:String
var selector_node:BehaviorTreeSelector

#region SIGNALS
func _on_add_condition_pressed(text:String = "") -> void:
	# Nodes structure
	# ------- | HboxContainer
	# ----- | LineEdit
	# ----- | DeleteButton
	
	var HboxContainer := HBoxContainer.new()
	var condition_edit_line := LineEdit.new()
	var DeleteButton := Button.new()
	
	conditions_list.add_child(HboxContainer)
	
	condition_edit_line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	condition_edit_line.text = text
	condition_edit_line.placeholder_text = "my_condition_here"
	condition_edit_line.text_change_rejected.connect(condition_text_submitted)
	condition_edit_line.text_submitted.connect(condition_text_submitted)
	HboxContainer.add_child(condition_edit_line)
	
	DeleteButton.text = "-"
	DeleteButton.pressed.connect(func(): _delete_button_pressed(HboxContainer))
	HboxContainer.add_child(DeleteButton)

func condition_text_submitted(text:String): # When the condition is modified
	selector_node.SelectorResource.conditions.clear()
	
	for condition in conditions_list.get_children():
		for cond in condition.get_children():
			if cond as LineEdit and selector_node:
				var data = {"condition": cond.text}
				selector_node.SelectorResource.conditions.append(data)
				selector_node.update_label_list()

func _main_condition_submitted(new_text: String) -> void: # When main condition is modified
	selector_node.SelectorResource.main_condition = new_text
	selector_node.update_label_list()
	
func _delete_button_pressed(node): # Remove condition from interface and SelectorResource
	if not selector_node:
		return

	var condition_text := ""
	for child in node.get_children():
		if child is LineEdit:
			condition_text = child.text.strip_edges()
			break

	for i in range(selector_node.SelectorResource.conditions.size()):
		var cond = selector_node.SelectorResource.conditions[i]
		if cond.has("condition") and cond["condition"] == condition_text:
			selector_node.SelectorResource.conditions.remove_at(i)
			break

	node.queue_free()
	selector_node.update_label_list()
#endregion

#region CALLS
func reload_interface(): # When the Selector Node is selected
	condition_title.text = ""
	for condition in conditions_list.get_children():
		condition.queue_free()
	
	condition_title.text = selector_node.SelectorResource.main_condition
	for cond in selector_node.SelectorResource.conditions:
		_on_add_condition_pressed(cond["condition"])
#endregion
