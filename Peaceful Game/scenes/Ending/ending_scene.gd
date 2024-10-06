extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("start")
	
	await $AnimationPlayer.animation_finished
	$"End Textbox".show()
	$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_end_textbox_text_finished():
	$AnimationPlayer.play("the_end")


func _on_end_textbox_turn_black_on():
	$AnimationPlayer.play("fade")
	print("nsdjsdnj")
