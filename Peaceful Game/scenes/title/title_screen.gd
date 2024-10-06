extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$FadeToBlack.play("fade_back")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_music_effects_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))



func _on_sound_effects_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


var game_scene:PackedScene = preload("res://scenes/forest.tscn")

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_audio_stream_player_2d_finished() -> void:
	$AudioStreamPlayer2D.play()
