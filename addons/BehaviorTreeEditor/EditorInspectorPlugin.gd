extends EditorInspectorPlugin

func _can_handle(object) -> bool:
	return object is BehaviorTreeAction

func _parse_begin(object):
	add_property_editor("ScriptFile", object)
	
func _parse_property(object, type: Variant.Type, name: String, hint: PropertyHint, hint_text: String, usage: int, wide: bool) -> bool:
	var allowed = ["ScriptFile", "ActionName"]
	if allowed.has(name):
		return false
	else:
		return true
