extends Node2D
class_name CountDown

var editable: bool = false
var crisisAmount: float = 20.0
var stepsRemaining: float = 100.0
signal outOfSteps

func _process(_delta):
	if(editable or Input.is_action_just_pressed("ui_accept")):
		print(str(global_position.angle_to_point(get_viewport().get_mouse_position()) / PI) + " angle")
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
	$ProgressBar.value = stepsRemaining

func GetItemAvailable(index: int) -> String:
	var output = "None"
	if(index == 0):
		if(len(PowerUpInventory.powerUps) > 0):
			output = PowerUpInventory.powerUps.values()[0]
	if(index == 1):
		output = "Drill-2"
	return output
