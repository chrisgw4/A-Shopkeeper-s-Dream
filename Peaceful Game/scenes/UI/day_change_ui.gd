extends CanvasLayer
class_name DayChangeUI


signal menu_done()

var current_day:int = 0:
	set(new_val):
		current_day = new_val
		$CenterContainer/Label.text = "Dawn of Day " + str(current_day)

func new_day() -> void:
	current_day += 1
	$AudioStreamPlayer2D.play(1.1)
	_change_day()


func _change_day() -> void:
	$AnimationPlayer.play("change_day")

func _ready() -> void:
	new_day()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	emit_signal("menu_done")
