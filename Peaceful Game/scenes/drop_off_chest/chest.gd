extends Node2D
class_name Chest


signal collected_item(item:Item)


var queued_items:Dictionary = {}
var player:Player

signal deposited_item(item:Item)
var customers:Array[Customer] = []
var items_wanted:Dictionary = {}


func move_item_into_chest() -> void:
	
	for i in queued_items:
		for x in range(queued_items[i]):
			$Item.texture = i.get_texture()
			$Item2.play("go_in_chest")
			
			await $Item2.animation_finished
			emit_signal("deposited_item", i)
	
	for i in queued_items:
		if i not in player.inventory:
			i.queue_free()
	queued_items = {}


func drop_off() -> void:
	#print(player.inventory)
	#print(customers)
	if $Item2.is_playing():
		return
	if player:
		for i in player.inventory:
			for customer in customers:
				if customer.item_to_want.item_name == i.item_name and player.inventory[i] > 0 and i not in queued_items:
					#print("num: ", i.item_name,  " ", player.inventory[i], " Player Inventory: ", player.inventory)
					queued_items[i] = clamp(player.inventory[i], 0, items_wanted[i.item_name])
					player.inventory[i] -= queued_items[i]
		
		for i in player.inventory:
			if player.inventory[i] <= 0:
				player.inventory.erase(i)
			
		player._update_inventory()
		#print(player.inventory)
		#print("Queued Items: ",queued_items)
		if len(queued_items) > 0:
			move_item_into_chest()



func _on_player_detector_body_entered(body: Player) -> void:
	player = body
	$AnimationPlayer3.play("click")
	$AnimatedSprite2D3.visible = true
	player.input_component.interact.connect(drop_off)


func _on_player_detector_body_exited(body: Player) -> void:
	player.input_component.interact.disconnect(drop_off)
	$AnimatedSprite2D3.visible = false
	
