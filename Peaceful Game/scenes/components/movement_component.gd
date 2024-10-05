extends Node
class_name MovementComponent

## The body the component will be moving
@export var character:CharacterBody2D

var speed:float = 10
var vel:Vector2 = Vector2.ZERO


func accelerate_in_direction(dir:Vector2) -> void:
	vel = (dir*speed).limit_length(speed)


func _physics_process(delta: float) -> void:
	move(delta)


func move(delta:float) -> void:
	character.velocity = vel
	character.move_and_slide()
	#vel = vel.lerp(Vector2.ZERO, 15*delta)



