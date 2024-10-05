extends Node
class_name HealthComponent

## The max amount of hp that the object should have
@export var max_hp:float = 1

@onready var current_hp:float = max_hp:
	set(new_hp):
		if new_hp < current_hp:
			emit_signal("hurt", current_hp)
		elif new_hp <= 0:
			emit_signal("death")
		current_hp = new_hp

signal hurt(hp)
signal death()

func damage(dam:float) -> void:
	current_hp -= dam




