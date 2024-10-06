extends StateMachine



@export var hair_style:String

func _ready() -> void:
	_add_state("run")
	_add_state("idle")
	#_add_state("attack")
	_add_state("axe")
	_add_state("mine")
	_add_state("reel")
	_add_state("cast")
	




func _enter_state(state:String) -> void:
	animation_player.play(state)

func _add_state(state:String) -> void:
	states[len(states)] = state
