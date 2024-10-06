extends Node2D
class_name TreeObject

signal died

@export var mini_game:Minigame
@export var health:int = 3:
	set(new_val):
		health = new_val
		if health <= 0:
			queue_free()
			spawn_wood()

var wood_scene:PackedScene = preload("res://scenes/pick_ups/wood.tscn")
var tree_hit:PackedScene = preload("res://scenes/tree/tree_hit.tscn")
var happy_hit:PackedScene = preload("res://scenes/reactions/happy_face.tscn")
var sad_hit:PackedScene = preload("res://scenes/reactions/sad_face.tscn")

var player:Player = null

func spawn_wood() -> void:
	for i in range(2):
		var temp:Item = wood_scene.instantiate()
		temp.global_position = global_position
		temp.lower_bound = global_position.y + randi_range(12, 24)
		temp.linear_velocity = Vector2(randf_range(-80, 80), randf_range(-200, -100))
		temp.gravity_scale = 1
		get_tree().current_scene.get_node("TileMap").add_child(temp)

func _ready() -> void:
	$AnimationPlayer.play("idle")
	mini_game.connect("win", _take_damage)
	mini_game.connect("miss", _punish_player)


func _punish_player() -> void:
	if player:
		player.health_component.damage(1)
		var temp = sad_hit.instantiate()
		temp.global_position = player.global_position
		get_tree().current_scene.add_child(temp)

func _take_damage() -> void:
	if player:
		player.health_component.damage(1)
		var temp = happy_hit.instantiate()
		temp.global_position = player.global_position
		get_tree().current_scene.add_child(temp)
	health -= 1
	var temp = tree_hit.instantiate()
	temp.global_position = global_position
	get_tree().current_scene.add_child(temp)
	if health <= 0:
		emit_signal("died")
	


func _on_player_detector_body_entered(player: Player) -> void:
	player.stop_activity.connect(stop_game)
	player.input_component.interact.connect(_play_game)
	connect("restrict_movement", player.restrict_movement)
	connect("died", player.unrestrict_movement)
	$AnimatedSprite2D3.visible = true
	$AnimationPlayer3.play("click")
	self.player = player

signal restrict_movement(type:String)

func stop_game() -> void:
	player.unrestrict_movement()
	mini_game.set_deferred("visible", false)

func _play_game() -> void:
	if player.stop_activities:
		return
	emit_signal("restrict_movement", "axe")
	mini_game.set_deferred("visible", true)
	
	


func _on_player_detector_body_exited(player: Player) -> void:
	player.stop_activity.disconnect(stop_game)
	player.input_component.interact.disconnect(_play_game)
	restrict_movement.disconnect(player.restrict_movement)
	died.disconnect(player.unrestrict_movement)
	$AnimatedSprite2D3.visible = false
	self.player = null
