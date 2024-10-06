extends Control
class_name MinigameFish

signal win()
signal click()
signal arrow()

var move_delta:float = -1

@export var arrows:Array[AnimatedSprite2D]

var current_arrow = 0

func _physics_process(delta: float) -> void:
	if not visible:
		return
	
	if current_arrow == 4:
		emit_signal("win")
		return
	
	if arrows[current_arrow].frame == 0:
		if Input.is_action_just_pressed("arrow_left"):
			arrows[current_arrow].modulate.a = 1
			current_arrow +=1
			emit_signal("arrow")
		elif Input.is_action_just_pressed("arrow_up") ||Input.is_action_just_pressed("arrow_down") || Input.is_action_just_pressed("arrow_right"):
			_reset_arrows()
			emit_signal("arrow")
			
	
	elif arrows[current_arrow].frame == 1:
		if Input.is_action_just_pressed("arrow_down"):
			arrows[current_arrow].modulate.a = 1
			current_arrow +=1
			emit_signal("arrow")
		elif Input.is_action_just_pressed("arrow_up") ||Input.is_action_just_pressed("arrow_right") || Input.is_action_just_pressed("arrow_left"):
			_reset_arrows()
			emit_signal("arrow")
			
		
	elif arrows[current_arrow].frame == 2:
		if Input.is_action_just_pressed("arrow_right"):
			arrows[current_arrow].modulate.a = 1
			current_arrow +=1
			emit_signal("arrow")
		elif Input.is_action_just_pressed("arrow_up") ||Input.is_action_just_pressed("arrow_down") || Input.is_action_just_pressed("arrow_left"):
			_reset_arrows()
			emit_signal("arrow")
				
			
	
	elif arrows[current_arrow].frame == 3:
		if Input.is_action_just_pressed("arrow_up"):
			arrows[current_arrow].modulate.a = 1	
			current_arrow +=1
			emit_signal("arrow")
		elif Input.is_action_just_pressed("arrow_right") ||Input.is_action_just_pressed("arrow_down") || Input.is_action_just_pressed("arrow_left"):
			_reset_arrows()
			emit_signal("arrow")
				
			


func _on_move_down_now_area_entered(area: Area2D) -> void:
	move_delta = 1


func _on_move_up_now_area_entered(area: Area2D) -> void:
	move_delta = -1


func _on_texture_progress_bar_value_changed(value: float) -> void:
	if value == 100:
		emit_signal("win")
		
func _ready():
	for i in range(0,4):
		arrows[i].frame = randi_range(0,4)
		arrows[i].modulate.a = 0.5

func _reset_arrows() -> void:
	for i in range(0, current_arrow+1):
		arrows[i].modulate.a = 0.5
	current_arrow = 0
	
