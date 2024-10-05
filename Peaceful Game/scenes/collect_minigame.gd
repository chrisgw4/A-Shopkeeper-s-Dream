extends Control
class_name Minigame

signal win()
signal miss()

@onready var arrow_left:Sprite2D = $ArrowLeft
var move_delta:float = -1

func _physics_process(delta: float) -> void:
	if not visible:
		return
	arrow_left.global_position.y += move_delta * delta * 40
	
	if Input.is_action_just_pressed("interact"):
		if $ArrowLeft/Area2D in $WinCondition.get_overlapping_areas():
			emit_signal("win")
		else:
			emit_signal("miss")


func _on_move_down_now_area_entered(area: Area2D) -> void:
	move_delta = 1


func _on_move_up_now_area_entered(area: Area2D) -> void:
	move_delta = -1
