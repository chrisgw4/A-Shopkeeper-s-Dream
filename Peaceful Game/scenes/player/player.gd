extends CharacterBody2D
class_name Player


@export var input_component:InputComponent
@export var state_machine:StateMachine
@export var body_animated_sprite:AnimatedSprite2D
@export var hair_animated_sprite:AnimatedSprite2D
@export var tool_animated_sprite:AnimatedSprite2D
@export var movement_component:MovementComponent

@export var stamina_bar:TextureProgressBar
@export var health_component:HealthComponent


signal new_item_collected(item:Item)
signal dropped_off_items()
signal update_inventory(inventory)

signal interacted


@export var money_ui:MoneyUI

func update_money(mons:int) -> void:
	money_ui.money += mons

var inventory:Dictionary = {}:
	set(new_val):
		inventory = new_val
		if inventory == {}:
			emit_signal("dropped_off_items")
			


func _update_inventory() -> void:
	emit_signal("update_inventory", inventory)


func _add_to_inventory(item:Item) -> void:
	
	
	
	var item_in_inv:bool = false
	for i in inventory:
		if item.item_name == i.item_name:
			if inventory[i] < 3:
				emit_signal("new_item_collected", item)
				inventory[i] += 1
				item.queue_free()
				$PickUpSound.pitch_scale = 1 - randf_range(-0.4, 0.4)
				$PickUpSound.play()
			return
	
	if len(inventory) >= 3:
		return
	
	emit_signal("new_item_collected", item)
	inventory[item] = 1
	$PickUpSound.pitch_scale = 1 - randf_range(-0.4, 0.4)
	$PickUpSound.play()
	
	pass

func _ready() -> void:
	state_machine.hair_style = "spikey"
	_enter_idle_state()
	movement_component.switch_directions.connect(switch_directions)
	movement_component.start_moving.connect(_enter_run_state)
	movement_component.stop_moving.connect(_enter_idle_state)
	input_component.attack.connect(_enter_attack_state)
	
	health_component.death.connect(_stop_activities)
	health_component.hurt.connect(_update_stamina)
	
	

var stop_activities:bool = false

func _update_stamina(new_val) -> void:
	stamina_bar.value = new_val


signal stop_activity()

func _stop_activities() -> void:
	stop_activities = true
	unrestrict_movement()
	emit_signal("stop_activity")


func restrict_movement(type:String) -> void:
	movement_component.restrict_movement = true
	state_machine._enter_state(type)

func unrestrict_movement() -> void:
	movement_component.restrict_movement = false
	_enter_idle_state()


func _enter_attack_state() -> void:
	if movement_component.vel.length() == 0:
		state_machine._enter_state("attack")

func _enter_idle_state() -> void:
	state_machine._enter_state("idle")

func _enter_run_state() -> void:
	state_machine._enter_state("run")

func _play_chop_sound() -> void:
	$WoodChop.play()


func _physics_process(delta: float) -> void:
	
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		emit_signal("interacted")


func switch_directions(state) -> void:
	body_animated_sprite.flip_h = state
	hair_animated_sprite.flip_h = state
	if state == false:
		tool_animated_sprite.position = Vector2(5, -2)
	else:
		tool_animated_sprite.position = Vector2(-5, -2)
	tool_animated_sprite.flip_h = state
