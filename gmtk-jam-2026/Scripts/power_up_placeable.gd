extends Node2D
class_name PowerUpPlaceable

var hovering: bool = false
var grabbing: bool = false
var heldPowerUp: PowerUp
var countDownRef: CountDown

func Initialize(newPowerUp) -> void:
	heldPowerUp = newPowerUp
	$Sprite2D.texture = heldPowerUp.icon
	$Line2D.default_color = heldPowerUp.displayColour1
	$Line2D2.default_color = heldPowerUp.displayColour1
	countDownRef = get_tree().get_first_node_in_group("Countdown")

func _process(_delta):
	if(hovering):
		if(Input.is_action_just_pressed("grab")):
			grabbing = true
	if(Input.is_action_just_released("grab")):
		if(grabbing):
			grabbing = false
			if(not hovering):
				AttemptPlacePowerUp()
			else:
				countDownRef.RemovePowerUp(heldPowerUp)
	if(grabbing):
		$Line2D.points[1] = get_viewport().get_mouse_position() - global_position
		$Line2D2.points[0] = get_viewport().get_mouse_position() - global_position
		$Line2D2.points[1] = countDownRef.global_position - global_position
	else:
		$Line2D.points[1] = Vector2.ZERO
		$Line2D2.points[0] = Vector2.ZERO
		$Line2D2.points[1] = Vector2.ZERO

func AttemptPlacePowerUp() -> void:
	var point = countDownRef.GetMouseAngle()
	if(countDownRef.CanAddPowerUp(point - (heldPowerUp.width / 2.0), heldPowerUp.width)):
		countDownRef.AddPowerUp(point - (heldPowerUp.width / 2.0), heldPowerUp)
	else:
		MusicManager.PlayGeneral(0)

func _on_area_2d_mouse_entered():
	$Sprite2D.scale = Vector2.ONE * 7.0
	hovering = true

func _on_area_2d_mouse_exited():
	$Sprite2D.scale = Vector2.ONE * 6.0
	hovering = false
