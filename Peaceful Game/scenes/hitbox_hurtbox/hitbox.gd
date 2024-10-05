extends Area2D
class_name Hitbox


@export var attack_component:AttackComponent



func _on_area_entered(area: Hurtbox) -> void:
	area.take_damage(attack_component.damage)
