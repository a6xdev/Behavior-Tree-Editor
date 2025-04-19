extends Resource
class_name BehaviorTreeActionScript

enum {RUNNING, SUCCESS, FAILURE}

var owner_node = null

func run(owner) -> int:
	owner_node = owner
	return execute()

## Function to be overridden in subclasses
func execute():
	push_warning("BehaviorTreeAction_Base: Função execute() não foi implementada.")
	return SUCCESS

func get_behavior_tree_owner():
	if owner_node and "owner_node" in owner_node.get_parent():
		return owner_node.get_parent().owner_node
	return null

func finish_success() -> int:
	return SUCCESS
func finish_failure() -> int:
	return FAILURE
func continue_running() -> int:
	return RUNNING
