extends Control
class_name MoneyUI

signal end_game

var money:int = 0:
	set(new_val):
		money = new_val
		
		var tween:Tween = create_tween()
		tween.tween_property(self, "current_money", money, 0.75)
		
		tween.play()
		
		if money >= 1000:
			emit_signal("end_game")

var current_money:int = 0:
	set(new_val):
		current_money = new_val
		$Label.text = "Gold: " + str(current_money)
