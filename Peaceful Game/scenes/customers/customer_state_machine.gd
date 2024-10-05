extends StateMachine



func _ready() -> void:
	_add_state("run")
	_add_state("idle")
	




func _enter_state(state:String) -> void:
	animation_player.play(state)

func _add_state(state:String) -> void:
	states[len(states)] = state
