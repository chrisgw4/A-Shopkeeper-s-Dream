extends HFlowContainer
class_name ListItemContainer


var count:int = 0:
	set(new_val):
		count = new_val
		$Label.text = str(count)
var item_name:String = ""


func add_item(item:Item) -> void:
	if item.item_name == item_name:
		count += 1
		return
	count += 1
	$TextureRect.texture = item.get_texture()
	

