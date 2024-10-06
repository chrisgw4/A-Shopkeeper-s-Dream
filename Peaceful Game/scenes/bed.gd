extends Node2D
class_name Bed

signal bed_used


var player_inside:bool = false

func _sleep() -> void:
	emit_signal("bed_used")


func _on_area_2d_body_entered(body: Player) -> void:
	$AnimatedSprite2D3.visible = true
	$Label.show()
	$AnimationPlayer3.play("click")
	player_inside = true
	body.input_component.interact.connect(_sleep)


func _on_area_2d_body_exited(body: Node2D) -> void:
	$AnimatedSprite2D3.visible = false
	$Label.hide()
	player_inside = false
	body.input_component.interact.disconnect(_sleep)
