extends Interactable

@export var used: bool = false

func Interact() -> bool:
	if(used):
		$AnimSprite.play_backwards("default")
	else:
		$AnimSprite.play("default")
	used = !used
	return true
