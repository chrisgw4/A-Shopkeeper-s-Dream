extends RigidBody2D
class_name Item

@export var item_name:String
var lower_bound:float = 0.0

func _physics_process(delta: float) -> void:
	if global_position.y >= lower_bound and not gravity_scale == 0:
		gravity_scale = 0
		linear_velocity = Vector2.ZERO
		$AnimationPlayer.play("Bounce")
	

func _on_pickup_area_body_entered(player: Player) -> void:
	player._add_to_inventory(self)
	

func get_texture() -> Texture2D:
	return $AnimatedSprite2D.sprite_frames.get_frame_texture("default", 0)
