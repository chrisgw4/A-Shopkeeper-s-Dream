extends Node
class_name InputComponent



@export var movement_component:MovementComponent

signal interact()
signal attack()

func _physics_process(delta: float) -> void:
	_get_input()


func _get_input() -> void:
	var dir:Vector2 = Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"), Input.get_action_strength("move_down")-Input.get_action_strength("move_up"))
	movement_component.accelerate_in_direction(dir)
	
	if Input.is_action_just_pressed("interact"):
		emit_signal("interact")
	
	if Input.is_action_just_pressed("attack"):
		emit_signal("attack")



