extends Node2D


var rock_scene:PackedScene = preload("res://scenes/rock/rock.tscn")
var tree_scene:PackedScene = preload("res://scenes/tree/tree.tscn")
var fish_scene:PackedScene = preload("res://scenes/fishing/fishing_spot.tscn")

@export var player:Player 


@export var day_change_ui:DayChangeUI


func _ready() -> void:
	$Smoke/AnimationPlayer.play("Smoke")
	
	for i in $RockSpawners.get_children():
		var temp = rock_scene.instantiate()
		temp.global_position = i.global_position
		$TileMap.add_child(temp)
	
	for i in $TreeSpawners.get_children():
		var temp = tree_scene.instantiate()
		temp.global_position = i.global_position
		$TileMap.add_child(temp)
	
	for i in $FishingSpawner.get_children():
		var temp = fish_scene.instantiate()
		temp.global_position = i.global_position
		$TileMap.add_child(temp)


func _on_player_detector_body_entered(body: Player) -> void:
	body.input_component.interact.connect(go_to_tavern)
	$AnimationPlayer3.play("click")
	$AnimatedSprite2D3.show()
	player = body


func go_to_tavern() -> void:
	$FadeToBlack.play("fade")
	
	#player.input_component.interact.disconnect(go_to_tavern)
	await $FadeToBlack.animation_finished
	player.global_position = $Tavern/TavernSpawnPoint.global_position
	
	$FadeToBlack.play("fade_back")
	

func _on_player_detector_body_exited(body: Player) -> void:
	body.input_component.interact.disconnect(go_to_tavern)
	$AnimatedSprite2D3.hide()


func _on_tavern_leave_body_entered(body: Node2D) -> void:
	$FadeToBlack.play("fade")
	
	await $FadeToBlack.animation_finished
	body.global_position = $TavernHouseSpawn.global_position
	$FadeToBlack.play("fade_back")


func _respawn_objects() -> void:
	
	for i in $TileMap.get_children():
		if i is TreeObject or i is RockObject or i is FishingObject or i is Item:
			i.queue_free()
	
	
	for i in $RockSpawners.get_children():
		var temp = rock_scene.instantiate()
		temp.global_position = i.global_position
		$TileMap.add_child(temp)
	
	for i in $TreeSpawners.get_children():
		var temp = tree_scene.instantiate()
		temp.global_position = i.global_position
		$TileMap.add_child(temp)
	
	for i in $FishingSpawner.get_children():
		var temp = fish_scene.instantiate()
		temp.global_position = i.global_position
		$TileMap.add_child(temp)


func _on_bed_bed_used() -> void:
	player.health_component.damage(-player.health_component.max_hp)
	$Tavern.remove_customers()
	day_change_ui.new_day()
	_respawn_objects()
