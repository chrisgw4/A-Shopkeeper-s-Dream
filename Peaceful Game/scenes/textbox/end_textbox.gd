extends Node2D

@export var label:RichTextLabel


var dialogue:Array[String] = ["I can't believe it...after all these years...", "My hard work finally paid off...", "No more heroes...", "No more requests...", "Just me and the ocean breeze.", "I think its finally time for me...", "to relax."]

var text_index=0

signal text_finished

signal turn_black_on

# Called when the node enters the scene tree for the first time.
func _ready():
	label.append_text(dialogue[text_index])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	label.clear()
	text_index+=1

	if text_index == len(dialogue)-1:
		emit_signal("turn_black_on")
	if text_index == len(dialogue):
		emit_signal("text_finished")
		queue_free()
		return
	label.append_text(dialogue[text_index])
