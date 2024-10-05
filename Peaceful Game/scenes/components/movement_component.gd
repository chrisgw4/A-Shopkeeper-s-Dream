extends Node
class_name MovementComponent

## The body the component will be moving
@export var character:CharacterBody2D

signal switch_directions(new_state:bool)
signal stop_moving
signal start_moving

var restrict_movement:bool = false

@export var speed:float = 10
var vel:Vector2 = Vector2.ZERO:
	set(new_vel):
		if new_vel == Vector2.ZERO and new_vel != vel:
			emit_signal("stop_moving")
		elif new_vel != Vector2.ZERO and new_vel != vel:
			emit_signal("start_moving")
		
		if new_vel.x < 0:
			emit_signal("switch_directions", true)
		elif new_vel.x > 0:
			emit_signal("switch_directions", false)
		
		vel = new_vel
		character.velocity = vel


func accelerate_in_direction(dir:Vector2) -> void:
	vel = (dir*speed).limit_length(speed)


func _physics_process(delta: float) -> void:
	if restrict_movement:
		return
	move(delta)


func move(delta:float) -> void:
	character.velocity = vel
	character.move_and_slide()
	#vel = vel.lerp(Vector2.ZERO, 15*delta)



