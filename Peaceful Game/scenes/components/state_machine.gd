extends Node
class_name StateMachine

var states:Dictionary = {}
@export var animation_player:AnimationPlayer


func _enter_state(state:String) -> void:
	pass

func _add_state(state:String) -> void:
	states[len(states)] = state

