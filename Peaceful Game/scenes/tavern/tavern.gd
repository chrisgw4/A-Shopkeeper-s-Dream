extends Node2D


var customer_scene:PackedScene = preload("res://scenes/customers/customer.tscn")
@onready var spawn_point:Node2D = $SpawnPoint

var num_of_customers:int = 0

@onready var chest:Chest = $Chest

@onready var arr = [$Chair1, $Chair3, $Chair5]
@onready var dict:Dictionary = {$Chair1:0, $Chair3:0, $Chair5:0}
@onready var carpet_position:Node2D = $CarpetPosition
@export var collect_list:CollectList

@export var player:Player

var customer_dict:Dictionary = {}

var customers:Array[Customer] = []
var items_wanted:Dictionary = {}

func _ready() -> void:
	$Timer.start()
	chest.connect("deposited_item", _check_customer_request)


func _on_timer_timeout() -> void:
	$Timer.start()
	if num_of_customers >= 3:
		return
	
	
	
	num_of_customers += 1
	var customer:Customer = customer_scene.instantiate()
	customer.global_position = spawn_point.global_position
	
	customer.carpet_position = carpet_position.global_position
	
	customer.modulate = Color(1,1,1,0)
	var tween:Tween = create_tween()
	tween.tween_property(customer, "modulate", Color(1,1,1,1), 0.5)
	
	
	
	get_tree().current_scene.add_child(customer)
	#$TileMap.add_child(customer)
	
	customer.connect("confirmed_request", collect_list._add_item)
	customer.connect("confirmed_request", customer_confirmed)
	customer.connect("completed_request", player.update_money)
	customer.connect("end_request", collect_list._remove_item)
	
	
	

func customer_confirmed(item:Item, amount:int, customer:Customer) -> void:
	customers.append(customer)
	if item.item_name in items_wanted:
		items_wanted[item.item_name] += 1
	else:
		items_wanted[item.item_name] = 1
	chest.items_wanted = items_wanted
	chest.customers = customers


func _check_customer_request(item:Item) -> void:
	for i in range(0, len(customers), 1):
		if customers[i].item_to_want.item_name == item.item_name:
			customers[i].request_completed()
			
			customers.remove_at(i)
			i -= 1
			chest.customers = customers
			items_wanted[item.item_name] -= 1
			chest.items_wanted = items_wanted
			return


func _on_customer_carpet_capture_body_entered(customer: Customer) -> void:
	if customer.on_way_out:
		customer.movement_component.accelerate_in_direction(customer.global_position.direction_to(Vector2(spawn_point.global_position.x, customer.global_position.y)))
		return
	if customer in customer_dict:
		return
	
	var temp:Area2D = arr.pick_random()
	while dict[temp] != 0:
		temp = arr.pick_random()
		
	dict[temp] = 1
	customer.target_chair = temp.global_position
	customer.on_way_to_chair = true
	customer.door_position = spawn_point.global_position
	temp.body_entered.connect(customer.stop_moving)
	customer_dict[customer] = temp
	



func _on_carpet_to_door_body_entered(customer: Customer) -> void:
	if customer.on_way_out:
		customer.movement_component.accelerate_in_direction(customer.global_position.direction_to(spawn_point.global_position))
		dict[customer_dict[customer]] = 0


func _on_door_area_body_entered(customer: Customer) -> void:
	if not customer.on_way_out:
		return
	var tween:Tween = create_tween()
	tween.tween_property(customer, "modulate", Color(1,1,1,0), 0.75)
	num_of_customers -= 1
	customer_dict.erase(customer)
	
	await tween.finished
	customer.queue_free()

func remove_customers() -> void:
	for i in get_tree().current_scene.get_children():
		if i is Customer:
			i.queue_free()
			i.free_item()
	num_of_customers = 0
	customers = []
	customer_dict = {}
	items_wanted = {}
	dict = {$Chair1:0, $Chair3:0, $Chair5:0}
	
