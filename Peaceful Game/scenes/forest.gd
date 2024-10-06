extends Node2D


var rock_scene:PackedScene = preload("res://scenes/rock/rock.tscn")
var tree_scene:PackedScene = preload("res://scenes/tree/tree.tscn")
var fish_scene:PackedScene = preload("res://scenes/fishing/fishing_spot.tscn")

@export var player:Player 


@export var day_change_ui:DayChangeUI

var end_scene:PackedScene = preload("res://scenes/Ending/ending_scene.tscn")

func end_game() -> void:
	$FadeToBlack.play("fade")
	
	await $FadeToBlack.animation_finished
	
	get_tree().change_scene_to_packed(end_scene)


func start_music() -> void:
	$Music.play()

func show_tired() -> void:
	$CanvasLayer/TiredLabel.show()

func _ready() -> void:
	$Smoke/AnimationPlayer.play("Smoke")
	$CanvasLayer/MoneyUI.end_game.connect(end_game)
	
	player.health_component.death.connect(show_tired)
	
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
	$Music.stream_paused = true
	player.health_component.damage(-player.health_component.max_hp)
	$Tavern.remove_customers()
	day_change_ui.new_day()
	_respawn_objects()
	
	await day_change_ui.get_node("AnimationPlayer").animation_finished
	
	$Music.stream_paused = true


func _on_music_finished() -> void:
	$Music.play()


func _on_day_change_ui_menu_done() -> void:
	if day_change_ui.current_day == 1:
		$"CanvasLayer2/Intro Textbox".show()
	$CanvasLayer/TiredLabel.hide()
	player.stop_activities = false
	start_music()


func _on_intro_textbox_text_finished() -> void:
	pass
