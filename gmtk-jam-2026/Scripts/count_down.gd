extends Node2D
class_name CountDown

var editable: bool = false
var crisisAmount: float = 20.0
var stepsRemaining: float = 100.0
signal outOfSteps

var powerUps: Array[PowerUp] = []
var powerUpStartTimes: Array[float] = []

func _process(_delta):
	if(Input.is_action_just_pressed("reset")):
		print(str(round(stepsRemaining)) + " countdown remaining")

func DrainSteps(amount: float) -> void:
	stepsRemaining -= amount
	$ProgressBar.value = stepsRemaining
	if (stepsRemaining <= crisisAmount):
		$Sprite2D2.visible = true;
		$Sprite2D2/AnimationPlayer.play("Shake");
	if(stepsRemaining <= 0):
		$Sprite2D2.visible = false;
		outOfSteps.emit()

func SetSteps(newSteps: float) -> void:
	stepsRemaining = newSteps
	if (stepsRemaining <= crisisAmount):
		$Sprite2D2.visible = true;
		$Sprite2D2/AnimationPlayer.play("Shake");
	else:
		$Sprite2D2.visible = false;
		
	$ProgressBar.value = stepsRemaining

func GetItemAvailable(index: int) -> String:
	var output = "None"
	if(index == 0):
		for ii in range(len(powerUps)):
			print("checking " + str(stepsRemaining))
			if(100 - stepsRemaining >= powerUpStartTimes[ii] and 100 - stepsRemaining <= powerUpStartTimes[ii] + powerUps[ii].width):
				return powerUps[ii].powerUpId
	if(index == 1 and OS.has_feature("editor")):
		output = "Drill-2"
	return output

func GetMouseAngle() -> float:
	var value = ((global_position.angle_to_point(get_viewport().get_mouse_position()) / PI) * -1)
	value = fmod(value + 2.5, 2.0) / 2.0 * 100.0
	return value

func CanAddPowerUp(start: float, width: float) -> bool:
	if(start < 0 or start + width > 100):
		return false
	for ii in range(len(powerUpStartTimes)):
		if!(start > powerUpStartTimes[ii] + powerUps[ii].width or start + width < powerUpStartTimes[ii]):
			return false
	return true

func AddPowerUp(start: float, newPowerUp: PowerUp) -> void:
	powerUps.append(newPowerUp)
	powerUpStartTimes.append(start)
	print("added power up to " + str(start))

func RemovePowerUp(removedPowerUp: PowerUp) -> void:
	var indexToRemove: int = powerUps.find(removedPowerUp)
	powerUps.remove_at(indexToRemove)
	powerUpStartTimes.remove_at(indexToRemove)
	print("removed power up")
