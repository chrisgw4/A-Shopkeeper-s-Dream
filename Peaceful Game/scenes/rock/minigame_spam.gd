extends Control
class_name MinigameSpam

signal win()
signal click()

var move_delta:float = -1

func _physics_process(delta: float) -> void:
	if not visible:
		return
	
	$TextureProgressBar.value -= 20*delta
	
	if Input.is_action_just_pressed("interact"):
		emit_signal("click")
		$TextureProgressBar.value += 6
		


func _on_move_down_now_area_entered(area: Area2D) -> void:
	move_delta = 1


func _on_move_up_now_area_entered(area: Area2D) -> void:
	move_delta = -1


func _on_texture_progress_bar_value_changed(value: float) -> void:
	if value == 100:
		emit_signal("win")
