extends Node
class_name AttackComponent

@export var damage:float = 1.0

@export var attack_timer:Timer

@export var attack_delay:float = 1

signal start_attack


func start_attacking() -> void:
	attack()
	attack_timer.start(attack_delay)

func stop_attacking() -> void:
	attack_timer.stop()

func attack() -> void:
	emit_signal("start_attack")


func _on_attack_timer_timeout() -> void:
	start_attacking()
