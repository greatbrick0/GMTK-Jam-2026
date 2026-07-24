extends Node2D
class_name CountDown

var stepsRemaining: float = 100.0
signal outOfSteps

func _process(_delta):
	if(Input.is_action_just_pressed("reset")):
		print(str(round(stepsRemaining)) + " countdown remaining")

func DrainSteps(amount: float) -> void:
	stepsRemaining -= amount
	$ProgressBar.value = stepsRemaining
	if(stepsRemaining <= 0):
		outOfSteps.emit()

func SetSteps(newSteps: float) -> void:
	stepsRemaining = newSteps
	$ProgressBar.value = stepsRemaining
