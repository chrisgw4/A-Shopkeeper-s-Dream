extends Control
class_name Inventory

@onready var inv_slot_1:InventorySlot = $HFlowContainer/InventorySlot
@onready var inv_slot_2:InventorySlot = $HFlowContainer/InventorySlot2
@onready var inv_slot_3:InventorySlot = $HFlowContainer/InventorySlot3


@export var player:Player



func _ready() -> void:
	if player:
		player.new_item_collected.connect(_update_inventory)
		player.dropped_off_items.connect(_erase_items)
		player.update_inventory.connect(update_items)

func update_items(inventory) -> void:
	_erase_items()
	for i in inventory:
		for x in range(inventory[i]):
			_update_inventory_parent(i, false)

func _erase_items() -> void:
	inv_slot_1.erase_item()
	inv_slot_2.erase_item()
	inv_slot_3.erase_item()

func _update_inventory_parent(item:Item, remove_parent:bool) -> void:
	if not inv_slot_1.in_use or (inv_slot_1.item != null and inv_slot_1.item.item_name == item.item_name):
		inv_slot_1._add_item(item, remove_parent)
	elif not inv_slot_2.in_use or (inv_slot_2.item != null and inv_slot_2.item.item_name == item.item_name):
		inv_slot_2._add_item(item, remove_parent)
	elif not inv_slot_3.in_use or (inv_slot_3.item != null and inv_slot_3.item.item_name == item.item_name):
		inv_slot_3._add_item(item, remove_parent)

func _update_inventory(item:Item) -> void:
	if not inv_slot_1.in_use or (inv_slot_1.item != null and inv_slot_1.item.item_name == item.item_name):
		inv_slot_1._add_item(item)
	elif not inv_slot_2.in_use or (inv_slot_2.item != null and inv_slot_2.item.item_name == item.item_name):
		inv_slot_2._add_item(item)
	elif not inv_slot_3.in_use or (inv_slot_3.item != null and inv_slot_3.item.item_name == item.item_name):
		inv_slot_3._add_item(item)
