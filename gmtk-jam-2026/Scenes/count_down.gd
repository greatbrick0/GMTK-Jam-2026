extends Node2D
class_name CountDown

var stepsRemaining: float = 100.0
signal outOfSteps

func DrainSteps(amount: float) -> void:
	stepsRemaining -= amount
	$ProgressBar.value = stepsRemaining
	if(stepsRemaining <= 0):
		outOfSteps.emit()

func SetSteps(newSteps: float) -> void:
	stepsRemaining = newSteps
	$ProgressBar.value = stepsRemaining
