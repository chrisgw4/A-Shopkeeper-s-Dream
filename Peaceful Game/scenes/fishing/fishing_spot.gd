extends Node2D
class_name fishing_spot
var fish_scene:PackedScene = preload("res://scenes/pick_ups/rock.tscn")

signal died
signal restrict_movement()


@export var mini_game:MinigameFish




# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Shine")
	mini_game.connect("win", _fished)
	mini_game.connect("arrow", _edit_player_stamina)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _edit_player_stamina() -> void:
	if player:
		player.health_component.damage(10)



#func spawn_rocks() -> void:
	#for i in range(2):
		#var temp:Item = rock_scene.instantiate()
		#temp.global_position = global_position
		#temp.lower_bound = global_position.y + randi_range(12, 24)
		#temp.linear_velocity = Vector2(randf_range(-80, 80), randf_range(-200, -100))
		#temp.gravity_scale = 1
		#get_tree().current_scene.add_child(temp)

var player:Player = null

func _on_player_detector_body_entered(p:Player) -> void:
	player = p
	connect("restrict_movement", player.restrict_movement)
	connect("died", player.unrestrict_movement)
	player.input_component.interact.connect(_play_game)
	$AnimatedSprite2D3.visible = true
	$AnimationPlayer3.play("click")


func _play_game() -> void:
	emit_signal("restrict_movement", "cast")
	mini_game.set_deferred("visible", true)



func _on_player_detector_body_exited(p:Player) -> void:
	
	$AnimatedSprite2D3.visible = false
	p.input_component.interact.disconnect(_play_game)
	restrict_movement.disconnect(p.restrict_movement)
	died.disconnect(p.unrestrict_movement)
	player = null

func _fished() -> void:
	mini_game.visible = false
	emit_signal("died")
	queue_free()

