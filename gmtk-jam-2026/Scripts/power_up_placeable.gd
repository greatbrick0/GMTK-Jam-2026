extends Node2D

var hovering: bool = false
var grabbing: bool = false
var heldPowerUp: PowerUp

func Initialize(newPowerUp) -> void:
	heldPowerUp = newPowerUp
	$Line2D.default_color = heldPowerUp.displayColour1
	$Line2D2.default_color = heldPowerUp.displayColour1

func _process(_delta):
	if(hovering):
		if(Input.is_action_just_pressed("grab")):
			grabbing = true
	if(Input.is_action_just_released("grab")):
		grabbing = false
	if(grabbing):
		$Line2D.points[1] = get_viewport().get_mouse_position() - global_position
		$Line2D2.points[0] = get_viewport().get_mouse_position() - global_position
		$Line2D2.points[1] = get_tree().get_first_node_in_group("Countdown").global_position - global_position
	else:
		$Line2D.points[1] = Vector2.ZERO
		$Line2D2.points[0] = Vector2.ZERO
		$Line2D2.points[1] = Vector2.ZERO

func _on_area_2d_mouse_entered():
	hovering = true

func _on_area_2d_mouse_exited():
	hovering = false
