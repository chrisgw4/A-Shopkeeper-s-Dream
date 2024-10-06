extends TextureRect
class_name InventorySlot

var in_use:bool = false

var item:Item = null
var count:int = 0:
	set(new_val):
		count = new_val
		$Label.text = str(count)
		if count == 0:
			$Label.text = ""

func _add_item(item:Item, remove_parent:bool = true) -> void:
	if count >= 3:
		return
	if self.item != null and item.item_name == self.item.item_name:
		count+=1
		if remove_parent:
			get_tree().current_scene.get_node("TileMap").call_deferred("remove_child", item)
		return
	if remove_parent:
		get_tree().current_scene.get_node("TileMap").call_deferred("remove_child", item)
	$MarginContainer/TextureRect.texture = item.get_texture()
	self.item = item
	$Label.visible = true
	count += 1
	in_use = true

func erase_item() -> void:
	$MarginContainer/TextureRect.texture = null
	$Label.text = ""
	count = 0
	in_use = false
	item = null

func update_items() -> void:
	pass
