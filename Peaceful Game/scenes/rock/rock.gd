extends Node2D
class_name RockObject

var rock_scene:PackedScene = preload("res://scenes/pick_ups/rock.tscn")

signal died
signal restrict_movement()

@export var mini_game:MinigameSpam
@export var health:int = 3:
	set(new_val):
		health = new_val
		if health <= 0:
			queue_free()
			spawn_rocks()
			emit_signal("died")


func _ready() -> void:
	mini_game.connect("win", _die)
	mini_game.connect("click", _edit_player_stamina)
	$AnimatedSprite2D.frame = randi_range(0,2)


func _edit_player_stamina() -> void:
	if player:
		player.health_component.damage(0.25)


func _die() -> void:
	health = 0

func spawn_rocks() -> void:
	for i in range(2):
		var temp:Item = rock_scene.instantiate()
		temp.global_position = global_position
		temp.lower_bound = global_position.y + randi_range(12, 18)
		temp.linear_velocity = Vector2(randf_range(-80, 80), randf_range(-200, -100))
		temp.gravity_scale = 1
		get_tree().current_scene.get_node("TileMap").add_child(temp)

var player:Player = null

func _on_player_detector_body_entered(p:Player) -> void:
	player = p
	player.stop_activity.connect(stop_game)
	connect("restrict_movement", player.restrict_movement)
	connect("died", player.unrestrict_movement)
	player.input_component.interact.connect(_play_game)
	$AnimatedSprite2D3.visible = true
	$AnimationPlayer3.play("click")


func _play_game() -> void:
	if player.stop_activities:
		return
	emit_signal("restrict_movement", "mine")
	mini_game.set_deferred("visible", true)


func stop_game() -> void:
	player.unrestrict_movement()
	mini_game.set_deferred("visible", false)


func _on_player_detector_body_exited(p:Player) -> void:
	$AnimatedSprite2D3.visible = false
	player.stop_activity.disconnect(stop_game)
	player.unrestrict_movement()
	player.input_component.interact.disconnect(_play_game)
	restrict_movement.disconnect(player.restrict_movement)
	died.disconnect(player.unrestrict_movement)
	player = null
