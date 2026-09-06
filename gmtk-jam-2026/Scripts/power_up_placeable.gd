extends Node2D
class_name PowerUpPlaceable

var hovering: bool = false
var grabbing: bool = false
var heldPowerUp: PowerUp
var countDownRef: CountDown
@export var usedModulate: Color = Color.GRAY

func Initialize(newPowerUp) -> void:
	heldPowerUp = newPowerUp
	$Sprite2D.texture = heldPowerUp.icon
	$Line2D.default_color = heldPowerUp.displayColour1
	$Line2D2.default_color = heldPowerUp.displayColour1
	countDownRef = get_tree().get_first_node_in_group("Countdown")
	if(countDownRef.powerUps.has(heldPowerUp)):
		$Sprite2D2.modulate = usedModulate
	else:
		$Sprite2D2.modulate = heldPowerUp.displayColour1

func _process(_delta):
	if(hovering):
		if(Input.is_action_just_pressed("grab")):
			if(countDownRef.powerUps.has(heldPowerUp)):
				countDownRef.RemovePowerUp(heldPowerUp)
				$Sprite2D2.modulate = heldPowerUp.displayColour1
			else:
				grabbing = true
	if(Input.is_action_just_released("grab")):
		if(grabbing):
			grabbing = false
			if(not hovering):
				AttemptPlacePowerUp()
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
	var centre = point - (heldPowerUp.width / 2.0)
	if(countDownRef.CanAddPowerUp(centre, heldPowerUp.width)):
		countDownRef.AddPowerUp(centre, heldPowerUp)
		$Sprite2D2.modulate = usedModulate
	else:
		var adjustedCentre = countDownRef.CanAdjustPowerUp(centre, heldPowerUp.width)
		if(adjustedCentre != 0):
			countDownRef.AddPowerUp(adjustedCentre, heldPowerUp)
			$Sprite2D2.modulate = usedModulate
		else:
			MusicManager.PlayGeneral(0)

func _on_area_2d_mouse_entered():
	$Sprite2D.scale = Vector2.ONE * 7.0
	hovering = true

func _on_area_2d_mouse_exited():
	$Sprite2D.scale = Vector2.ONE * 6.0
	hovering = false
