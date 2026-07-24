extends Interactable
class_name Lever

@export var used: bool = false
@export var oneWay: bool = false

signal changed

func Interact() -> bool:
	if(used):
		if(oneWay):
			return false
		$AnimSprite.play_backwards("default")
	else:
		$AnimSprite.play("default")
	used = !used
	$Audio2D.play()
	changed.emit()
	return true

func Reset() -> void:
	used = false
	$AnimSprite.frame = 0
