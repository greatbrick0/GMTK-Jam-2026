extends Interactable

@export var used: bool = false
@export var oneway: bool = false

func Interact() -> bool:
	if(used):
		if(oneway):
			return false
		$AnimSprite.play_backwards("default")
	else:
		$AnimSprite.play("default")
	used = !used
	$Audio2D.play()
	return true

func Reset() -> void:
	used = false
	$AnimSprite.frame = 0
