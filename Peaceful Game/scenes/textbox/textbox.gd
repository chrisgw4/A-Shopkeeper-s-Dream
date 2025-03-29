extends Node2D

@export var label:RichTextLabel


var dialogue:Array[String] = ["The names Clerk, Clerk Cache. I’ve been working as a humble shopkeep for 30 years now.", "Heroes of all types come by my store for the three necessities of life:", "Wood…", "Stone…", "and Fish.", "But that all changes soon.", "After years of hard work I’m now only a mere 1000 gold away from achieving my life long dream!", "A house with a beachside view…", "That final stretch starts today, so let the hard work begin!"]

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

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("read_text"):
		_on_texture_button_pressed()
