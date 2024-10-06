extends HFlowContainer
class_name ListItemContainer

signal empty()

var count:int = 0:
	set(new_val):
		count = new_val
		$Label.text = str(count)
		if new_val == 0:
			emit_signal("empty", item_name)
			queue_free()
var item_name:String = ""


func add_item(item:Item) -> void:
	if item.item_name == item_name:
		count += 1
		return
	count += 1
	item_name = item.item_name
	$TextureRect.texture = item.get_texture()

func remove_item(item:Item) -> void:
	if item.item_name == item_name:
		count -= 1
		return
	count -= 1

