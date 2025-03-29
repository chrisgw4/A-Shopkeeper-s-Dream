extends CharacterBody2D
class_name Customer

signal completed_request(gold:int)

static var hair_styles:Array[SpriteFrames] = [preload("res://scenes/customers/customer_bowl_hair.tres"), preload("res://scenes/customers/customer_curly_hair.tres"), preload("res://scenes/customers/customer_long_hair.tres"), preload("res://scenes/customers/customer_mop_hair.tres"), preload("res://scenes/customers/customer_short_hair.tres")]

@export var hair_sprite:AnimatedSprite2D
@export var body_sprite:AnimatedSprite2D
@export var state_machine:StateMachine
@export var movement_component:MovementComponent

static var items_to_want:Array[PackedScene] = [preload("res://scenes/pick_ups/wood.tscn"), preload("res://scenes/pick_ups/rock.tscn"), preload("res://scenes/pick_ups/fish.tscn")]
var item_to_want:Item
@onready var item_texture:TextureRect = $TextureRect/TextureRect

var happy_scene:PackedScene = preload("res://scenes/reactions/happy_face.tscn")
var sad_scene:PackedScene = preload("res://scenes/reactions/sad_face.tscn")



var textures_dict:Dictionary = {"C_Mouse":preload("res://assets/sprites/Sunnyside_World_Assets/UI/confirm.png"), "D_Mouse":preload("res://assets/sprites/Sunnyside_World_Assets/UI/cancel.png"),
								"C_Xbox":preload("res://assets/sprites/Keys/Xbox one-Confirm.png"), "D_Xbox":preload("res://assets/sprites/Keys/Xbox one-Deny.png"),
								"C_Ps4":preload("res://assets/sprites/Keys/Ps4-Confirm.png"), "D_Ps4":preload("res://assets/sprites/Keys/Ps4-Deny.png")}


var request_accepted:bool = false


var on_way_to_chair:bool = false
var on_way_out:bool = false:
	set(new_val):
		if new_val:
			movement_component.accelerate_in_direction(global_position.direction_to(Vector2(global_position.x, carpet_position.y)))
			
		on_way_out = new_val

var carpet_position:Vector2 = Vector2.ZERO:
	set(new_val):
		movement_component.accelerate_in_direction(global_position.direction_to(new_val))
		carpet_position = new_val

var door_position:Vector2 = Vector2.ZERO
var target_chair:Vector2 = Vector2.ZERO:
	set(new_val):
		movement_component.accelerate_in_direction(global_position.direction_to(Vector2(new_val.x, global_position.y)))
		target_chair = new_val



func _ready() -> void:
	hair_sprite.sprite_frames = hair_styles.pick_random()
	item_to_want = items_to_want.pick_random().instantiate()
	
	item_texture.texture = item_to_want.get_texture()
	
	


func free_item() -> void:
	if is_instance_valid(item_to_want):
		item_to_want.queue_free()


func _physics_process(delta: float) -> void:
	#if global_position.distance_to(carpet_position) <= 1:
	#	movement_component.accelerate_in_direction(global_position.direction_to(Vector2(target_chair.x, global_position.y)))
	
	if on_way_to_chair:
		#print(abs(global_position.x - target_chair.x))
		if abs(global_position.x - target_chair.x) < 0.2:
			on_way_to_chair = false
			movement_component.accelerate_in_direction(global_position.direction_to(target_chair))

	#
	#if on_way_out:
		#if abs(global_position.x - target_chair.x) < 0.02:
			#on_way_out = false
			#movement_component.accelerate_in_direction(global_position.direction_to(Vector2(door_position.x, global_position.y)))


func stop_moving(body) -> void:
	movement_component.accelerate_in_direction(Vector2.ZERO)
	$PlayerDetector/CollisionShape2D.set_deferred("disabled", false)
	
	


func _leave_tavern() -> void:
	on_way_out = true
	if is_instance_valid(item_to_want):
		item_to_want.queue_free()


signal confirmed_request(item:Item, amount:int, customer:Customer)
signal end_request(item:Item, amount:int, _customer:Customer)

func _on_confirm_pressed() -> void:
	if on_way_out or on_way_to_chair or request_accepted:
		return
	request_accepted = true
	$TextureRect/HFlowContainer/Confirm.hide()
	$TextureRect/HFlowContainer/Cancel.hide()
	
	$TextureRect/HFlowContainer/Accept.visible = false
	$TextureRect/HFlowContainer/Deny.visible = false
	
	#$PlayerDetector/CollisionShape2D.set_deferred("disabled", false)
	emit_signal("confirmed_request", item_to_want, 1, self)
	$Menuclick.pitch_scale = 1 - randf_range(-0.4, 0.4)
	$Menuclick.play()


func _on_cancel_pressed() -> void:
	if on_way_out or on_way_to_chair:
		return
	var temp = sad_scene.instantiate()
	temp.global_position = global_position
	get_tree().current_scene.add_child(temp)
	_leave_tavern()
	$Menuclick.pitch_scale = 1 - randf_range(-0.4, 0.4)
	$Menuclick.play()


func request_completed() -> void:
	
	_leave_tavern()
	var temp = happy_scene.instantiate()
	temp.global_position = global_position
	get_tree().current_scene.add_child(temp)
	emit_signal("end_request", item_to_want, 1, self)
	
	if item_to_want.item_name == "Rock":
		emit_signal("completed_request", 25)
	elif item_to_want.item_name == "Wood":
		emit_signal("completed_request", 10)
	elif item_to_want.item_name == "Fish":
		emit_signal("completed_request", 3)


func _on_movement_component_start_moving() -> void:
	state_machine._enter_state("run")


func _on_movement_component_stop_moving() -> void:
	state_machine._enter_state("idle")
	_update_buttons()


func _on_movement_component_switch_directions(new_state: bool) -> void:
	hair_sprite.flip_h = new_state
	body_sprite.flip_h = new_state


func _on_player_detector_area_entered(area: Area2D) -> void:
	
	pass
	

func _update_buttons() -> void:
	if request_accepted:
		return
	
	if "PS" in Input.get_joy_name(0):
		#$TextureRect/HFlowContainer/Confirm.texture_normal = textures_dict["C_Ps4"]
		#$TextureRect/HFlowContainer/Cancel.texture_normal = textures_dict["D_Ps4"]
		$TextureRect/HFlowContainer/Accept.visible = true
		$TextureRect/HFlowContainer/Deny.visible = true
		$TextureRect/HFlowContainer/Accept.frame = 0
		$TextureRect/HFlowContainer/Deny.frame = 0
		$TextureRect/HFlowContainer/Confirm.hide()
		$TextureRect/HFlowContainer/Cancel.hide()
	elif Input.get_joy_name(0) == "":
		$TextureRect/HFlowContainer/Accept.visible = false
		$TextureRect/HFlowContainer/Deny.visible = false
		#$TextureRect/HFlowContainer/Confirm.texture_normal = textures_dict["C_Mouse"]
		#$TextureRect/HFlowContainer/Cancel.texture_normal = textures_dict["D_Mouse"]
		$TextureRect/HFlowContainer/Confirm.show()
		$TextureRect/HFlowContainer/Cancel.show()
	else:
		$TextureRect/HFlowContainer/Accept.visible = true
		$TextureRect/HFlowContainer/Deny.visible = true
		$TextureRect/HFlowContainer/Accept.frame = 1
		$TextureRect/HFlowContainer/Deny.frame = 1
		$TextureRect/HFlowContainer/Confirm.hide()
		$TextureRect/HFlowContainer/Cancel.hide()
		#$TextureRect/HFlowContainer/Confirm.texture_normal = textures_dict["C_Xbox"]
		#$TextureRect/HFlowContainer/Cancel.texture_normal = textures_dict["D_Xbox"]

func _input(event: InputEvent) -> void:
	_update_buttons()


func _on_player_detector_body_entered(player: Player) -> void:
	#_update_buttons()
	$ControllerButton.play("grow")
	player.accepted_request.connect(_on_confirm_pressed)
	player.denied_request.connect(_on_cancel_pressed)


func _on_player_detector_body_exited(player: Player) -> void:
	$ControllerButton.play("RESET")
	player.accepted_request.disconnect(_on_confirm_pressed)
	player.denied_request.disconnect(_on_cancel_pressed)
