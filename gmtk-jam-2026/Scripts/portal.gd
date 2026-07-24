extends Interactable

@export var keepLevelData: bool = true
@export var packedLevel: PackedScene
@export var filePathLevel: String
@export var exitPosition: Vector2 = Vector2.ZERO

func _ready():
	pass 

func Interact() -> bool:
	if(packedLevel != null):
		pass
	else:
		pass
	return true
