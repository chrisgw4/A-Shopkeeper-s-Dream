extends MarginContainer
class_name CollectList

var dict:Dictionary = {}

var item_list_container_scene:PackedScene = preload("res://scenes/tree/list_item_container.tscn")

func _add_item(item:Item, amount:int, _customer:Customer):
	if item.item_name in dict:
		dict[item.item_name].add_item(item)
		return
	
	var temp = item_list_container_scene.instantiate()
	$VFlowContainer.add_child(temp)
	temp.add_item(item)
	dict[item.item_name] = temp
	temp.empty.connect(_remove_collect_list_item)

func _remove_item(item:Item, amount:int, _customer:Customer) -> void:
	if item.item_name in dict:
		dict[item.item_name].remove_item(item)
		#dict.erase(item.item_name)

func remove_all() -> void:
	for i in $VFlowContainer.get_children():
		i.queue_free()
	dict.clear()


func _remove_collect_list_item(item_name:String) -> void:
	dict.erase(item_name)
