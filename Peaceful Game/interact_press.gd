extends Node2D


@export var animated_sprite:AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	animated_sprite.visible = false
	$AnimationPlayer.play("click")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_buttons() -> void:
	if "PS" in Input.get_joy_name(0):
		animated_sprite.animation = "ps4"
	elif Input.get_joy_name(0) == "":
		animated_sprite.animation = "key"
	else:
		animated_sprite.animation = "xbox"

func enable() -> void:
	_update_buttons()
	animated_sprite.visible = true

func disable() -> void:
	animated_sprite.visible = false
