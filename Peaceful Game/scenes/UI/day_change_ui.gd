extends CanvasLayer
class_name DayChangeUI

var current_day:int = 0:
	set(new_val):
		current_day = new_val
		$CenterContainer/Label.text = "Dawn of Day " + str(current_day)

func new_day() -> void:
	current_day += 1
	_change_day()


func _change_day() -> void:
	$AnimationPlayer.play("change_day")

func _ready() -> void:
	new_day()
