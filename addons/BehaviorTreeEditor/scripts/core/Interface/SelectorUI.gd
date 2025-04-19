@tool
extends PanelContainer

@onready var condition_title: LineEdit = $VBoxContainer/Condition
@onready var conditions_list: VBoxContainer = $VBoxContainer/ConditionsList

var MainCondition:String
var selector_node:BehaviorTreeSelector

#region SIGNALS
func _on_add_condition_pressed(text:String = "") -> void:
	var condition_edit_line := LineEdit.new()
	condition_edit_line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	condition_edit_line.text = text
	condition_edit_line.placeholder_text = "my_condition_here"
	condition_edit_line.text_submitted.connect(condition_text_changed)
	conditions_list.add_child(condition_edit_line)
	
func condition_text_changed(text:String):
	selector_node.selector_resource.conditions.clear()
	
	for condition in conditions_list.get_children():
		if condition as LineEdit and selector_node:
			var data = {"condition": condition.text}
			selector_node.selector_resource.conditions.append(data)
			selector_node.update_label_list()
#endregion

func reload_conditions():
	condition_title.text = ""
	for condition in conditions_list.get_children():
		condition.queue_free()
	
	condition_title.text = selector_node.selector_resource.main_condition
	for cond in selector_node.selector_resource.conditions:
		_on_add_condition_pressed(cond["condition"])

func _on_condition_text_submitted(new_text: String) -> void:
	selector_node.selector_resource.main_condition = new_text
	selector_node.update_label_list()
